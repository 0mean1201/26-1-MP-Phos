# Phos - 인생네컷 포토부스 앱 작업 요약

> 이 문서는 Claude가 참고하기 위한 프로젝트 내부 요약본입니다.

---

## 프로젝트 개요

**Phos**는 인생네컷 스타일의 포토부스 앱으로, Flutter 프론트엔드와 Node.js 백엔드로 구성된 풀스택 프로젝트입니다.
핵심 차별점은 **온디바이스 AI 얼굴 인식** 기능으로, FaceNet 모델을 사용해 사진 속 인물을 분류하고 검색할 수 있습니다.

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| 프론트엔드 | Flutter (Dart) |
| ML / 얼굴 인식 | Google ML Kit + TFLite (FaceNet_512) |
| 카메라 | image_picker |
| 로컬 저장소 | SharedPreferences |
| 백엔드 API | Express.js (Node.js / TypeScript) |
| 데이터베이스 | MariaDB |
| ORM | Prisma |

---

## 폴더 구조

```
26-1-MP-Phos/
├── apps/
│   ├── flutter_project/     # Flutter 앱 (프론트엔드 + ML)
│   └── server/              # Express 백엔드 API
├── packages/                # 공유 패키지
├── design-system/           # 디자인 시스템
└── docs/                    # 문서
```

---

## Flutter 앱 (`apps/flutter_project`)

### 화면 구성

| 화면 | 역할 |
|------|------|
| `main_layout.dart` | 하단 탭 네비게이션 (START / GALLERY / STUDIO) |
| `home_screen.dart` | 메인 홈 - 촬영 시작, 최근 사진 목록 |
| `frame_selection_screen.dart` | 프레임 타입 선택 (4종) |
| `result_screen.dart` | 촬영 결과 - 프레임 합성 및 저장 |
| `frame_conversion_screen.dart` | 기존 갤러리 사진을 프레임으로 변환 |
| `gallery_screen.dart` | 사진 갤러리 + 얼굴 검색 기능 |
| `search_result_screen.dart` | 얼굴 검색 결과 화면 |

### 프레임 타입 (4종)

| 타입 | 설명 |
|------|------|
| CLASSIC | 4장 세로 스트립 |
| SQUARE | 2x2 그리드 |
| TRIO | 3장 세로 |
| SOLO | 1장 단독 |

### 얼굴 인식 파이프라인 (`face_recognition_service.dart`)

```
입력 이미지
  ↓
[ML Kit] 얼굴 영역 감지 (bounding box)
  ↓
[image 패키지] 얼굴 크롭 → 160x160 리사이즈
  ↓
[전처리] 픽셀값 -1 ~ 1 정규화
  ↓
[TFLite] FaceNet_512 모델 추론
  ↓
512차원 임베딩 벡터 출력
```

- 모델: `assets/ml/facenet_512.tflite` (약 24MB)
- 유사도 계산: **코사인 유사도**로 얼굴 매칭
- 모든 ML 처리는 **온디바이스** (프라이버시 보호)

### 로컬 데이터 저장 구조 (SharedPreferences)

```json
[
  {
    "path": "/storage/...",
    "frameType": "classic",
    "title": "제목",
    "tag": "태그",
    "date": "2026-05-06T15:30:00Z",
    "embeddings": ["[0.1, -0.2, ...]", "..."]
  }
]
```

---

## 백엔드 서버 (`apps/server`)

### 기술

- Express.js v5 + TypeScript
- Prisma ORM + MariaDB
- 환경변수: `.env` (DB 연결 정보)

### 데이터베이스 모델

| 모델 | 역할 |
|------|------|
| `AppInstance` | 기기/앱 인스턴스 식별 |
| `Photo` | 촬영된 사진 메타데이터 |
| `Face` | 감지된 얼굴 + 512D 임베딩 벡터 (JSON) |
| `Group` | 유사한 얼굴들의 클러스터 그룹 |

### API 엔드포인트

| 메서드 | 경로 | 설명 |
|--------|------|------|
| POST | `/api/photos` | 사진 + 얼굴 임베딩 업로드 |
| GET | `/api/groups/representatives/:appInstanceId` | 그룹별 대표 얼굴 벡터 조회 |

### 코드 아키텍처 (Clean MVC)

```
controller.ts  →  service.ts  →  repository.ts  →  Prisma  →  MariaDB
(HTTP 처리)       (비즈니스 로직)   (DB 쿼리)
```

---

## 전체 데이터 흐름

```
1. 사용자가 프레임 타입 선택 후 사진 촬영
2. 사진을 프레임 레이아웃으로 합성
3. 합성 이미지를 기기 갤러리에 저장
4. ML Kit으로 얼굴 감지 → FaceNet으로 512D 임베딩 추출
5. 임베딩을 SharedPreferences에 로컬 저장
6. (선택) 서버 API로 임베딩 동기화 → MariaDB 저장
7. 갤러리에서 얼굴 검색 시: 쿼리 임베딩 vs 저장 임베딩 코사인 유사도 비교
8. 유사도 높은 사진들을 검색 결과로 반환
```

---

## 현재 브랜치 상태 (`server-setup`)

- `apps/server/` 폴더 신규 추가 (Express 백엔드 구축 중)
- 기존 NestJS 기반 `apps/api/` 관련 파일들 삭제됨 (Express로 전환)
- Flutter 앱의 갤러리 필터, 프레임 변환, 로컬 저장 기능 구현 완료
- 사진 분류(그룹핑) 기능 v1 추가 완료

---

## 앱 UI 컬러 팔레트

| 이름 | 색상 |
|------|------|
| primary | `#9D72FF` (보라) |
| background | `#FAF9F6` (크림) |
| textMain | black87 |
| textSub | grey |

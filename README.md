# Phos - 인생네컷 포토부스 앱 기술 문서

> 이 문서는 과제 제출용 최종 프로젝트 기술 문서입니다. (2026-06-11 기준)

---

## 프로젝트 개요

**Phos**는 인생네컷 스타일의 포토부스 모바일 앱입니다. Flutter 프론트엔드와 Express.js 백엔드로 구성된 풀스택 프로젝트이며, 핵심 차별점은 **온디바이스 AI 얼굴 인식** 기능입니다. FaceNet 512 모델을 TFLite로 구동하여 사진 속 인물을 자동 분류하고, 얼굴 기반으로 사진을 검색할 수 있습니다. 얼굴 원본 이미지는 절대 서버로 전송되지 않으며, 512차원 임베딩 벡터만 저장·전송됩니다.

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| 프론트엔드 | Flutter 3.x (Dart, SDK ^3.11.4) |
| ML / 얼굴 감지 | Google ML Kit Face Detection (^0.13.2) |
| ML / 얼굴 임베딩 | TFLite Flutter (^0.12.1) + FaceNet_512 모델 |
| 이미지 처리 | image 패키지 (^4.2.0) |
| 카메라 | camera (^0.11.0), image_picker (^1.2.1) |
| 로컬 저장소 | SharedPreferences (^2.5.5), gal (^2.3.0) |
| 기기 식별 | android_id (^0.3.0) — ANDROID_ID 사용 |
| HTTP 클라이언트 | http (^1.2.1) |
| 백엔드 프레임워크 | Express.js v5 (Node.js / TypeScript) |
| ORM | Prisma v7 + @prisma/adapter-mariadb |
| 데이터베이스 | MariaDB (Cloudtype 호스팅) |
| 배포 | Cloudtype (Docker 기반 자동 배포) |

---

## 폴더 구조

```
26-1-MP-Phos/
├── apps/
│   ├── flutter_project/          # Flutter 앱 (프론트엔드 + ML)
│   │   ├── lib/
│   │   │   ├── main.dart         # 앱 진입점, 기기 등록, 라이프사이클
│   │   │   ├── core/             # 공통 상수, 테마, 앱 상태
│   │   │   ├── screens/          # 화면 단위 UI 컴포넌트
│   │   │   └── services/         # 비즈니스 로직 / ML / API
│   │   ├── assets/
│   │   │   ├── ml/               # TFLite 모델 파일
│   │   │   ├── poses/            # 포즈 가이드 이미지
│   │   │   └── images/           # 프레임 템플릿 이미지
│   │   └── pubspec.yaml
│   └── server/                   # Express 백엔드 API
│       ├── src/
│       │   ├── index.ts          # 서버 진입점, 라우팅
│       │   ├── controller.ts     # HTTP 요청/응답 처리
│       │   ├── service.ts        # 비즈니스 로직
│       │   ├── repository.ts     # Prisma DB 쿼리
│       │   ├── dto.ts            # TypeScript 인터페이스
│       │   └── generated/        # Prisma 자동 생성 클라이언트
│       ├── prisma/
│       │   └── schema.prisma     # DB 스키마 정의
│       └── package.json
├── docs/                         # 기획 문서
├── design-system/                # 디자인 시스템
└── readme2.md                    # (본 문서)
```

---

## Flutter 앱 (`apps/flutter_project`)

### 앱 초기화 흐름 (`main.dart`)

```
앱 실행
  ↓
FaceRecognitionService 초기화 (TFLite 모델 로드)
  ↓
ANDROID_ID로 서버에 AppInstance upsert (등록 또는 조회)
  ↓
appInstanceId를 ApiService에 캐시
  ↓
SyncService.retryPendingUploads() — 미전송 사진 재시도
  ↓
메인 레이아웃 진입
```

- `AppLifecycleState.resumed` 감지 시 SyncService 재실행
- 라이트/다크 모드는 `AppStateNotifier`(ChangeNotifier)로 전역 관리

---

### 화면 구성 (`lib/screens/`)

| 파일 | 화면명 | 역할 |
|------|--------|------|
| `main_layout.dart` | 메인 레이아웃 | 하단 탭 네비게이션 (START / GALLERY / STUDIO) |
| `home_screen.dart` | 홈 화면 | 촬영 시작 버튼, 최근 스트립 캐러셀, 사이드 드로어 |
| `frame_selection_screen.dart` | 프레임 선택 | 기본/컨셉 카테고리 전환, 4종 프레임 타입 선택 |
| `pose_camera_screen.dart` | 포즈 카메라 | 포즈 가이드 오버레이, 실시간 얼굴 감지 피드백, 연속 촬영 |
| `cut_selection_screen.dart` | 컷 선택 | 촬영된 N장 중 프레임 슬롯에 수동 배정 |
| `result_screen.dart` | 결과 화면 | 프레임 합성 렌더링, 얼굴 인식, 로컬 저장, 서버 동기화 |
| `gallery_screen.dart` | 갤러리 | 프레임 타입 필터, 얼굴 기반 검색, 제목/태그 편집 |
| `frame_conversion_screen.dart` | 프레임 변환 | 기존 갤러리 사진을 다른 프레임 레이아웃으로 변환 |
| `search_result_screen.dart` | 얼굴 검색 결과 | 유사 얼굴 사진 목록 표시 |
| `studio_screen.dart` | 스튜디오 | 인물별 친밀도(사진 수) 랭킹, 그룹 이름 변경 |

#### 주요 화면 상세

**`pose_camera_screen.dart`**
- 카메라 플러그인으로 프리뷰 스트림 제공
- 포즈 카테고리: active (역동적) / basic (자연스러운) / couple (커플) / random
- 인원수 (1~4명)에 맞는 포즈 이미지 오버레이
- N+2장 촬영 후 cut_selection_screen으로 이동

**`result_screen.dart`**
- `RenderRepaintBoundary`로 프레임+사진 합성 위젯을 PNG로 캡처
- 기기 갤러리 (`gal`) + 앱 내부 저장소 (`path_provider`) 동시 저장
- 저장 직후 FaceRecognitionService → GroupingService 파이프라인 실행
- 서버 업로드 실패 시 `pendingUpload: true`로 로컬 마킹

**`studio_screen.dart`**
- ApiService.getIntimacy()로 그룹별 얼굴 수 조회
- 얼굴 수 기준 내림차순 정렬, 프로그레스 바로 시각화
- 그룹 대표 얼굴 이미지(imagePath 기반 아바타) 표시
- 인라인 텍스트 필드로 그룹(인물) 이름 변경

---

### 프레임 타입 (4종)

| 타입 | 슬롯 수 | 레이아웃 |
|------|---------|---------|
| CLASSIC | 4장 | 세로 4x1 스트립 |
| SQUARE | 4장 | 2x2 그리드 |
| TRIO | 3장 | 세로 3x1 스트립 |
| SOLO | 1장 | 단독 정방형 |

- **기본 프레임**: 단색 배경 24종
- **컨셉 프레임**: 브랜드/이벤트 디자인 13종

---

### 서비스 레이어 (`lib/services/`)

#### `face_recognition_service.dart` — 얼굴 임베딩 추출

```
입력 이미지 (XFile)
  ↓
[ML Kit FaceDetector] 얼굴 바운딩 박스 감지 + 눈 랜드마크 추출
  (performanceMode: accurate, enableLandmarks: true)
  ↓
[눈 정렬] leftEye / rightEye 좌표 → atan2로 기울기 각도 계산
          → copyRotate로 이미지 수평 정렬
          → 눈 간격(eyeDist) × 1.8 = halfSize로 얼굴 영역 크롭
  ※ 랜드마크 없을 시: boundingBox에 30% 패딩 크롭으로 폴백
  ↓
[image 패키지] copyResize → 160×160 RGB
  ↓
[전처리] 픽셀값 정규화: (px - 127.5) / 127.5 → Float32List
  ↓
[TFLite] FaceNet_512 모델 추론 (입력: [1,160,160,3])
  ↓
512차원 원시 벡터 → L2 정규화 (단위 벡터 변환)
  ↓
출력: List<List<double>> (사진 당 감지된 얼굴 수만큼)
```

- 모델 파일: `assets/ml/facenet_512.tflite` (약 23MB)
- 싱글턴 패턴, 앱 시작 시 1회 초기화
- 모든 처리 온디바이스 — 원본 이미지 외부 전송 없음

#### `grouping_service.dart` — 그룹 자동 배정

```
추출된 임베딩 벡터 배열
  ↓
서버에서 기존 그룹 대표 벡터 목록 조회 (GET representatives)
  ↓
각 임베딩에 대해:
  코사인 유사도 계산 (모든 그룹 대표 벡터와 비교)
  ├── 최고 유사도 > 0.6 → 해당 그룹에 배정
  └── 최고 유사도 ≤ 0.6 → 새 그룹 생성 (POST /api/groups)
        └── 생성된 그룹을 로컬 대표 목록에 즉시 추가
              (같은 배치 내 다음 얼굴도 이 그룹과 비교 가능)
  ↓
출력: GroupAssignmentResult { groupIds: [], vectors: [] }
```

- 임계값(threshold): **0.6** (코사인 유사도)
- 서버 불가 시: 모든 groupId를 -1로 폴백 (오프라인 내성)

#### `api_service.dart` — 서버 HTTP 클라이언트

| 메서드 | 역할 |
|--------|------|
| `registerAppInstance(deviceId)` | POST /api/app-instances |
| `getRepresentatives(appInstanceId)` | GET /api/groups/representatives/:id |
| `createGroup(appInstanceId, name)` | POST /api/groups |
| `uploadPhoto(appInstanceId, imagePath, vectors)` | POST /api/photos |
| `renameGroup(groupId, name)` | PATCH /api/groups/:groupId |
| `getIntimacy(appInstanceId)` | GET /api/groups/intimacy/:id |

- 베이스 URL: `https://port-0-phos-mpiml6p754ac32d4.sel3.cloudtype.app`
- 싱글턴, `appInstanceId` 내부 캐시

#### `photo_storage_service.dart` — 로컬 데이터 영속성

SharedPreferences에 JSON 직렬화하여 저장:

```json
{
  "path": "/data/user/0/.../app_flutter/phos_classic_*.png",
  "frameType": "classic",
  "title": "제목",
  "tag": "my_moment",
  "date": "2026-06-11T15:30:00Z",
  "serverPhotoId": 42,
  "groupIds": [1, 2],
  "pendingUpload": false,
  "pendingVectors": [[0.1, -0.2, ...]]
}
```

#### `sync_service.dart` — 비동기 업로드 재시도

- `pendingUpload: true`인 사진을 큐에 적재
- AppInstance 미등록(-1)이면 등록 재시도 후 업로드
- 앱 시작 및 `resumed` 이벤트마다 자동 실행

#### `frame_service.dart` — 프레임 에셋 관리

- 기본(24종) + 컨셉(13종) 프레임 메타데이터 관리
- 각 프레임의 슬롯 좌표(정규화 0~1) 및 aspect ratio 제공
- FrameType ↔ 프레임 파일 매핑

---

### 기기 식별 및 데이터 지속성

- `android_id` 패키지로 `ANDROID_ID` 획득 (앱 재설치 후에도 동일 기기 인식)
- `appInstanceId`를 SharedPreferences에 캐시 → 앱 재시작 시 서버 호출 최소화
- 서버 데이터 기반으로 재설치 후 사진 연결 복구 가능

---

## 백엔드 서버 (`apps/server`)

### 아키텍처

```
클라이언트 HTTP 요청
  ↓
index.ts (Express 라우터)
  ↓
controller.ts (요청 파싱, 유효성 검사, 응답 직렬화)
  ↓
service.ts (비즈니스 로직, 자동 이름 부여 등)
  ↓
repository.ts (Prisma ORM 쿼리)
  ↓
MariaDB (Cloudtype 호스팅, mariadb:3306)
```

### 서버 초기화 (`index.ts`)

- 포트: `process.env.PORT` 또는 3000
- 미들웨어: `cors()`, `express.json()`, `express.urlencoded()`
- 기동 시 `npx prisma db push --accept-data-loss` 자동 실행 → 스키마 자동 동기화

### API 엔드포인트

| 메서드 | 경로 | 설명 | 요청 Body / Param | 응답 |
|--------|------|------|-------------------|------|
| POST | `/api/app-instances` | 기기 등록 (upsert) | `{ deviceId: string }` | `{ appInstanceId: number }` |
| POST | `/api/photos` | 사진 + 얼굴 벡터 저장 | `{ appInstanceId, imagePath, vectors[] }` | 생성된 Photo + Face 목록 |
| POST | `/api/groups` | 새 그룹 생성 | `{ appInstanceId, name?: string }` | `{ groupId, name }` |
| PATCH | `/api/groups/:groupId` | 그룹 이름 수정 | `{ name: string }` | `{ groupId, name }` |
| GET | `/api/groups/representatives/:appInstanceId` | 그룹별 대표 벡터 조회 | — | `RepresentativeFaceResponse[]` |
| GET | `/api/groups/intimacy/:appInstanceId` | 친밀도(그룹별 얼굴 수) 조회 | — | `IntimacyEntry[]` |

#### 응답 인터페이스 (`dto.ts`)

```typescript
// 대표 벡터 응답
interface RepresentativeFaceResponse {
  groupId: number;
  groupName: string;
  representativeFaceId: number;
  vector: number[];           // 512차원
}

// 친밀도 응답
interface IntimacyEntry {
  groupId: number;
  groupName: string;
  photoCount: number;
  representativeVector: number[];
  representativeImagePath: string | null;
}
```

### 비즈니스 로직 (`service.ts`) 상세

| 함수 | 동작 |
|------|------|
| `registerAppInstance(deviceId)` | deviceId로 AppInstance upsert → id 반환 |
| `uploadPhotoData(data)` | Photo + 연결된 Face 레코드 일괄 생성 |
| `getRepresentativeVectors(appInstanceId)` | 각 그룹의 가장 오래된 Face(faces[0]) 반환 |
| `createNewGroup(appInstanceId, name)` | 이름 비어있으면 "Person N" 자동 부여 후 생성 |
| `getIntimacyData(appInstanceId)` | 그룹별 faces._count 기준 내림차순 정렬 반환 |
| `renameGroup(groupId, name)` | Group.name 업데이트 |

### DB 커넥션 (`repository.ts`)

- `PrismaMariaDb` 어댑터로 MariaDB 네이티브 드라이버 사용
- 환경변수: `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`
- `connectionLimit: 5`

---

## 데이터베이스 스키마

**DBMS**: MariaDB | **ORM**: Prisma v7

```
AppInstance
  id         INT  PK AUTO_INCREMENT
  deviceId   VARCHAR  UNIQUE          ← ANDROID_ID
  createdAt  DATETIME DEFAULT NOW()
  ┌──────────────────────────────┐
  │  1 : N → Photo               │
  │  1 : N → Group               │
  └──────────────────────────────┘

Photo
  id             INT  PK AUTO_INCREMENT
  appInstanceId  INT  FK → AppInstance(id)  ON DELETE CASCADE
  imagePath      TEXT                        ← 로컬 디바이스 경로
  createdAt      DATETIME DEFAULT NOW()
  ┌──────────────────────────────┐
  │  1 : N → Face                │
  └──────────────────────────────┘

Face
  id         INT   PK AUTO_INCREMENT
  photoId    INT   FK → Photo(id)   ON DELETE CASCADE
  groupId    INT?  FK → Group(id)   ON DELETE SET NULL  ← nullable
  vector     JSON                   ← 512차원 Float 배열
  createdAt  DATETIME DEFAULT NOW()

Group
  id             INT  PK AUTO_INCREMENT
  appInstanceId  INT  FK → AppInstance(id)  ON DELETE CASCADE
  name           VARCHAR
  createdAt      DATETIME DEFAULT NOW()
  UNIQUE(appInstanceId, name)       ← 같은 기기 내 중복 이름 방지
  ┌──────────────────────────────┐
  │  1 : N → Face                │
  └──────────────────────────────┘
```

### 설계 특이사항

- `Face.groupId`는 NULL 허용 → 촬영 직후 그룹 미배정 상태 지원
- `Group.UNIQUE(appInstanceId, name)` → 동일 기기 내 동명 그룹 방지
- 모든 하위 레코드에 `CASCADE` 삭제 → 기기(AppInstance) 삭제 시 전체 데이터 정리
- 원본 이미지는 서버에 저장하지 않음 (`imagePath`는 디바이스 내 경로)

---

## 전체 데이터 플로우

```
1. 앱 시작
   ANDROID_ID → POST /api/app-instances (upsert)
   → appInstanceId 획득 및 캐시

2. 프레임 타입 선택
   frame_selection_screen → CLASSIC / SQUARE / TRIO / SOLO 선택

3. 촬영
   pose_camera_screen → 포즈 가이드 오버레이로 N+2장 연속 촬영

4. 컷 선택
   cut_selection_screen → 프레임 슬롯에 원하는 컷 수동 배정

5. 합성 및 저장
   result_screen
   → RenderRepaintBoundary로 프레임+사진 PNG 합성
   → 기기 갤러리(gal) + 앱 내부 저장소(path_provider) 저장

6. 얼굴 인식 (온디바이스)
   → ML Kit으로 얼굴 바운딩 박스 + 눈 랜드마크 감지
   → 눈 정렬 후 160×160 크롭
   → FaceNet_512 TFLite 추론 → 512D 임베딩 L2 정규화

7. 그룹 자동 배정
   → GET /api/groups/representatives/:appInstanceId (기존 대표 벡터 조회)
   → 코사인 유사도 비교 (임계값 0.6)
   → 유사 그룹 발견: 해당 groupId 배정
   → 신규 인물: POST /api/groups → 새 그룹 생성

8. 서버 동기화
   → POST /api/photos { appInstanceId, imagePath, vectors[{vector, groupId}] }
   → MariaDB에 Photo + Face 레코드 저장
   → 실패 시 pendingUpload: true 로컬 마킹 → 다음 앱 재시작 시 재시도

9. 갤러리 얼굴 검색
   → 사용자가 쿼리 사진 선택
   → FaceRecognitionService로 쿼리 임베딩 추출
   → 로컬 저장된 사진들의 임베딩과 코사인 유사도 계산
   → 임계값 0.6 이상 사진을 search_result_screen에 표시

10. 스튜디오 친밀도 확인
    → GET /api/groups/intimacy/:appInstanceId
    → 그룹별 얼굴 수 기준 랭킹 표시
    → 대표 얼굴 아바타 + 이름 변경 (PATCH /api/groups/:groupId)
```

---

## 프라이버시 및 오프라인 지원

| 항목 | 구현 내용 |
|------|----------|
| 얼굴 이미지 보호 | 원본 이미지는 서버로 전송되지 않음; 512D 벡터만 업로드 |
| 온디바이스 ML | 모든 얼굴 감지·임베딩 추출이 기기 내에서 처리 |
| 오프라인 폴백 | 서버 연결 불가 시 groupId=-1로 로컬 저장, 재연결 시 자동 동기화 |
| 기기 데이터 복구 | ANDROID_ID 기반 appInstanceId → 앱 재설치 후에도 데이터 연속성 |

---

## 배포 구조

| 항목 | 내용 |
|------|------|
| 플랫폼 | Cloudtype (Docker 기반 PaaS) |
| 배포 트리거 | GitHub main 브랜치 push → 자동 빌드 및 배포 |
| 서버 URL | `https://port-0-phos-mpiml6p754ac32d4.sel3.cloudtype.app` |
| DB 접속 | Cloudtype MariaDB 내부 네트워크 (`mariadb:3306`) |
| 스키마 관리 | 서버 시작 시 `prisma db push --accept-data-loss` 자동 실행 |
| 환경변수 | `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME` |

---

## 앱 UI 컬러 팔레트

| 이름 | Light | Dark |
|------|-------|------|
| primary | `#9D72FF` (보라) | `#9D72FF` |
| darkPrimary | — | `#B89AFF` |
| background | `#FAF9F6` (크림) | `#1A1A2E` (딥네이비) |
| textMain | black87 | white |
| textSub | grey | grey |

---

## 주요 에셋 목록

| 경로 | 내용 |
|------|------|
| `assets/ml/facenet_512.tflite` | FaceNet 512 TFLite 모델 (약 23MB) |
| `assets/ml/mobilefacenet.tflite` | 경량 대체 모델 (약 5MB) |
| `assets/poses/active/{1~4}_person/` | 역동적 포즈 가이드 이미지 |
| `assets/poses/basic/{1~4}_person/` | 자연스러운 포즈 가이드 이미지 |
| `assets/poses/couple/` | 커플 포즈 가이드 이미지 |
| `assets/images/` | 프레임 템플릿 PNG (기본 24종 + 컨셉 13종) |

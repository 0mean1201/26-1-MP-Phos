# Phos 발표 자료

---

## 1. 한 줄 소개

> "찍는 순간, AI가 사람을 기억한다"
> 인생네컷 스타일 포토부스 + 온디바이스 얼굴 인식 앱

---

## 2. 핵심 차별점

### 일반 포토부스 앱과의 비교

| 기능 | 일반 포토부스 앱 | Phos |
|------|----------------|------|
| 사진 촬영 | ✅ | ✅ |
| 프레임 합성 | ✅ | ✅ |
| 얼굴 자동 인식 | ❌ | ✅ |
| 인물별 사진 검색 | ❌ | ✅ |
| 사진 서버 전송 없음 | ❌ | ✅ (온디바이스) |
| 재설치 후 데이터 유지 | ❌ | ✅ (ANDROID_ID) |

### 핵심 차별점 3가지

**① 온디바이스 AI 얼굴 인식**
- 사진이 서버로 전송되지 않음 → 개인정보 완전 보호
- 인터넷 없이도 얼굴 인식 동작
- FaceNet 512차원 임베딩으로 높은 정확도

**② 자동 인물 그루핑**
- 촬영할 때마다 자동으로 "누가 찍혔는지" 분류
- 코사인 유사도 기반 그룹 자동 배정/생성
- 나중에 "이 사람이 찍힌 사진만 보기" 검색 가능

**③ 기기 기반 데이터 지속성**
- 로그인 없이 ANDROID_ID로 기기 고유 식별
- 앱 재설치해도 서버의 그룹/얼굴 데이터 자동 복구

---

## 3. 기술적 도전과 해결 방법

### 도전 1: 얼굴 인식 정확도 향상

**문제**: 기울어진 얼굴 사진에서 임베딩 품질 저하

**해결**:
- ML Kit의 눈 랜드마크(좌/우 눈 좌표) 활용
- `atan2(ry - ly, rx - lx)`로 기울기 각도 계산
- 회전 보정 후 크롭 → 정면 얼굴 기준으로 정규화
- 랜드마크 없는 경우 30% 패딩 크롭으로 폴백

```dart
final angle = atan2(ry - ly, rx - lx) * 180 / pi;
final rotated = img.copyRotate(image, angle: -angle);
```

---

### 도전 2: 실시간 그루핑 성능

**문제**: 촬영 직후 모든 기존 그룹과 유사도 계산 시 지연

**해결**:
- 서버에서 그룹별 **대표 벡터 1개만** 조회 (전체 얼굴 아님)
- 같은 배치(한 장의 사진) 내 새 그룹 생성 시 **로컬 캐시**에 즉시 추가
  → 같은 배치 내 다음 얼굴도 새 그룹과 비교 가능 (서버 왕복 없음)

```dart
representatives.add(RepresentativeDto(
  groupId: newGroupId,
  vector: embedding,  // 로컬 캐시에 즉시 추가
));
```

---

### 도전 3: 오프라인 환경 대응

**문제**: 서버 연결 실패 시 사진 데이터 유실

**해결**: 비동기 업로드 큐 (`sync_service.dart`)
- 업로드 실패 시 `pendingUpload: true`로 로컬 마킹
- 앱 재시작 / 포어그라운드 복귀 시 자동 재시도
- 서버 미연결 상태에서도 촬영 및 로컬 저장은 정상 동작

---

### 도전 4: 로그인 없는 사용자 식별

**문제**: 구글 로그인 구현 시 SHA-1 키 관리 복잡성, 팀 개발 환경 충돌

**해결**: ANDROID_ID 기반 기기 식별
- `Settings.Secure.ANDROID_ID` → 앱 재설치에도 유지되는 고유값
- 서버에서 `deviceId`로 upsert → 동일 기기 재설치 시 기존 데이터 자동 복구
- 로그인 불필요 → UX 단순화

---

### 도전 5: Prisma v7 마이그레이션 이슈

**문제**: Prisma v7에서 `schema.prisma`의 `url` 필드 제거됨

**해결**: `prisma.config.ts`로 DB 연결 분리
```ts
export default defineConfig({
  schema: 'prisma/schema.prisma',
  datasource: { url: env('DATABASE_URL') },
});
```

---

### 도전 6: Docker 빌드 환경에서 DB 접근 불가

**문제**: 빌드 타임에 `prisma db push` 실행 시 DB 연결 불가 (네트워크 격리)

**해결**: 서버 **시작 시** 자동 스키마 동기화
```ts
execSync("npx prisma db push --accept-data-loss", { stdio: "inherit" });
```
→ 런타임에 MariaDB 컨테이너와 같은 네트워크에서 실행

---

## 4. 시스템 아키텍처

```
┌─────────────────────────────────────────┐
│           Flutter 앱 (Android)           │
│                                         │
│  ┌─────────┐  ┌──────────────────────┐  │
│  │ Camera  │  │  FaceRecognition      │  │
│  │ + Frame │  │  Service (TFLite)     │  │
│  │ Compose │  │  - ML Kit 감지        │  │
│  └────┬────┘  │  - FaceNet 추론       │  │
│       │       │  - L2 정규화          │  │
│       │       └──────────┬───────────┘  │
│       │                  │              │
│       └──────────────────▼──────────┐   │
│                  GroupingService    │   │
│                  (코사인 유사도)     │   │
│                         │           │   │
│                  SyncService        │   │
│                  (비동기 업로드)     │   │
└─────────────────────────┼───────────┘
                          │ HTTPS
                          ▼
┌─────────────────────────────────────────┐
│         Express.js 서버 (Cloudtype)      │
│                                         │
│  controller → service → repository      │
│                              │          │
│                           Prisma        │
│                              │          │
│                          MariaDB        │
└─────────────────────────────────────────┘
```

---

## 5. ML 파이프라인 상세

```
원본 이미지
    ↓
[ML Kit FaceDetector]
- 얼굴 바운딩 박스
- 눈 랜드마크 (좌/우)
    ↓
[전처리]
- 눈 기울기 보정 (회전)
- 얼굴 영역 크롭
- 160 × 160 리사이즈
- 픽셀 정규화 [-1, 1]
    ↓
[FaceNet_512 TFLite]
- Input:  [1, 160, 160, 3]
- Output: [1, 512]
    ↓
[L2 정규화]
    ↓
512차원 임베딩 벡터
    ↓
[코사인 유사도 비교]
- 임계값: 0.6
- 기존 그룹 매칭 or 신규 그룹 생성
```

---

## 6. 데이터 프라이버시

- **원본 사진**: 절대 서버 전송 안 함
- **얼굴 이미지**: 서버 전송 안 함
- **전송되는 것**: 512차원 숫자 벡터 + 파일 경로(로컬 경로)
- **얼굴 인식 처리**: 100% 온디바이스

---

## 7. 기술 스택 요약

```
Frontend  : Flutter (Dart)
ML        : Google ML Kit + TFLite (FaceNet_512, 24MB)
Backend   : Express.js v5 + TypeScript
DB        : MariaDB + Prisma v7
Deploy    : Cloudtype (Docker)
DevId     : ANDROID_ID (android_id 패키지)
```

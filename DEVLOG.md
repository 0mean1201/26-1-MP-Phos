# Phos — 개발 작업 기록

> 인생네컷 스타일 포토부스 앱. Flutter + Express + FaceNet 기반 풀스택 프로젝트.
> 브랜치: `server-setup`

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 앱 컨셉 | 인생네컷 스타일 셀프 포토부스 |
| 프레임 종류 | CLASSIC(4x1), SQUARE(2x2), TRIO(3x1), SOLO(1x1) |
| 핵심 기능 | 온디바이스 얼굴 인식, 인물 자동 그루핑, 친밀도 분석 |
| 주요 기술 | Flutter, TFLite (FaceNet_512), Google ML Kit, Express.js, Prisma, MariaDB |

---

## 폴더 구조

```
26-1-MP-Phos/
├── apps/
│   ├── flutter_project/          # Flutter 앱
│   │   ├── lib/
│   │   │   ├── core/constants.dart
│   │   │   ├── screens/
│   │   │   │   ├── main_layout.dart
│   │   │   │   ├── home_screen.dart
│   │   │   │   ├── frame_selection_screen.dart
│   │   │   │   ├── result_screen.dart
│   │   │   │   ├── gallery_screen.dart
│   │   │   │   ├── search_result_screen.dart
│   │   │   │   ├── studio_screen.dart          ← 신규
│   │   │   │   └── frame_conversion_screen.dart
│   │   │   └── services/
│   │   │       ├── face_recognition_service.dart
│   │   │       ├── grouping_service.dart        ← 신규
│   │   │       ├── photo_storage_service.dart   ← 신규
│   │   │       ├── sync_service.dart            ← 신규
│   │   │       └── api_service.dart             ← 신규
│   │   └── assets/ml/
│   │       └── facenet_512.tflite
│   └── server/                   # Express 백엔드
│       └── src/
│           ├── index.ts
│           ├── controller.ts
│           ├── service.ts
│           ├── repository.ts
│           └── dto.ts
```

---

## 이번 작업에서 구현한 기능

### 1. 서버 API 구축 (`apps/server`)

기존에 API가 없던 상태에서 아래 엔드포인트를 전부 새로 만들었다.

| 메서드 | 경로 | 설명 |
|--------|------|------|
| POST | `/api/app-instances` | 앱 최초 실행 시 인스턴스 등록, ID 발급 |
| POST | `/api/photos` | 사진 + 얼굴 임베딩 벡터 업로드 |
| POST | `/api/groups` | 새 인물 그룹 생성 |
| PATCH | `/api/groups/:groupId` | 그룹 이름 수정 |
| GET | `/api/groups/representatives/:appInstanceId` | 그룹별 대표 얼굴 벡터 조회 (클라이언트 그루핑용) |
| GET | `/api/groups/intimacy/:appInstanceId` | 인물별 친밀도(사진 수) + 대표 이미지 경로 조회 |

**아키텍처**: `index.ts` → `controller.ts` → `service.ts` → `repository.ts` → Prisma → MariaDB

**주요 수정 사항**
- `dto.ts`: `CreatePhotoRequest` 중복 정의 제거, 타입 통일 (`appInstanceId: number`)
- `repository.ts`: `createAppInstance()`, `findGroupsWithFaceCounts()` (Face→Photo 조인으로 대표 이미지 경로 포함), `updateGroupName()` 추가
- `controller.ts`: `parseInt(String(req.params.X ?? ''), 10)` 패턴으로 TypeScript 오류 수정

---

### 2. Flutter ↔ 서버 연결

#### `ApiService` (신규, `lib/services/api_service.dart`)
- HTTP 클라이언트 싱글톤
- `baseUrl = 'http://10.0.2.2:3000'` (Android 에뮬레이터에서 호스트 localhost)
- 앱 인스턴스 ID를 싱글톤에 보관 (prop drilling 방지)
- 메서드: `registerAppInstance()`, `getRepresentatives()`, `createGroup()`, `uploadPhoto()`, `getIntimacy()`, `renameGroup()`
- DTO: `RepresentativeDto`, `IntimacyDto` (representativeImagePath 포함)

#### Android 네트워크 설정 (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<!-- application 태그에 추가 -->
android:usesCleartextTraffic="true"
```

---

### 3. 앱 최초 실행 흐름 (`main.dart` 개편)

- `_ensureAppInstance()`: SharedPreferences에 `phos_app_instance_id` 키로 ID 보관
  - 서버 미응답 시 `-1` sentinel 저장 (오프라인 sentinel)
- `PhotoBoothApp` → `StatefulWidget` + `WidgetsBindingObserver` 적용
  - `initState`, `AppLifecycleState.resumed` 시 `SyncService().enqueuePendingPhotos()` 호출

---

### 4. 로컬 사진 저장소 통합 (`PhotoStorageService` 신규)

기존에 화면별로 흩어진 SharedPreferences 접근을 하나로 통합.

**`LocalPhoto` 모델**

```dart
class LocalPhoto {
  final String path;        // 앱 documents 디렉터리 경로 (영구 저장)
  final String frameType;
  final String title, tag, date;
  final int? serverPhotoId;         // null = 아직 서버 미동기화
  final List<int> groupIds;         // 배정된 그룹 ID 목록
  final bool pendingUpload;         // 오프라인 큐 플래그
  final List<List<double>>? pendingVectors; // 얼굴 임베딩 (갤러리 검색 및 업로드에 사용)
}
```

**중요**: 이미지 저장 경로를 `getTemporaryDirectory()` → `getApplicationDocumentsDirectory()`로 변경. 앱 재시작 후에도 이미지가 유지된다.

---

### 5. 클라이언트 사이드 얼굴 그루핑 (`GroupingService` 신규)

```
1. 서버에서 getRepresentatives() 호출 → 기존 그룹의 대표 벡터 목록 수신
2. 각 임베딩 × 각 대표 벡터 코사인 유사도 계산
3. 최고 유사도 > 0.35 → 해당 groupId 배정
4. 매칭 없음 → 서버에 createGroup() 요청 → 새 groupId 배정
5. 같은 배치 내 새 그룹도 이후 임베딩과 비교할 수 있도록 임시 보관
```

- 그루핑 임계값: `0.4 → 0.35` (낮을수록 더 관대하게 같은 사람으로 판단)

---

### 6. 오프라인 동기화 (`SyncService` 신규)

- `_isSyncing` 플래그로 중복 실행 방지
- 앱 ID가 `-1`이면 서버 등록 재시도 후 업로드 진행
- 각 pending 사진: `uploadPhoto()` 호출 → 성공 시 `serverPhotoId` 저장, `pendingUpload = false`
- 실패 시 `pendingUpload = true` 유지 → 다음 재개 시 자동 재시도
- **벡터는 업로드 후에도 삭제하지 않음**: 갤러리 얼굴 검색이 `pendingVectors`에 의존하므로 유지 필요

---

### 7. 촬영 결과 화면 개편 (`result_screen.dart`)

저장 버튼 클릭 시 순서:
1. 위젯 캡처 → documents 디렉터리에 PNG 저장
2. `Gal.putImage()`로 기기 갤러리에 복사
3. 원본 사진 각각에 `FaceRecognitionService().getEmbeddings()` 호출
4. `GroupingService().assignGroups()` 호출
5. `LocalPhoto(pendingUpload: true, pendingVectors: ...)` 로컬 저장
6. `SyncService().enqueuePendingPhotos()` 백그라운드 호출 (기다리지 않음)
- 저장 중 로딩 인디케이터 (`_isSaving` 상태) 추가

---

### 8. STUDIO 탭 구현 (`studio_screen.dart` 신규)

- `getIntimacy()` 호출로 인물별 사진 수 조회
- 인물 카드: 대표 사진 원형 아바타 + 이름 + 친밀도 바 + 사진 수
- 이름 편집: 탭 시 다이얼로그 → `PATCH /api/groups/:id` 호출
- `RefreshIndicator`로 pull-to-refresh
- 서버 미연결 시 에러 메시지 + 재시도 버튼
- `dialogContext` vs `context` 이름 충돌 수정 (Flutter 경고 제거)

---

### 9. 갤러리 개편 (`gallery_screen.dart`)

- `PhotoStorageService().loadAll()` 사용으로 통합 (기존 SharedPreferences 직접 접근 제거)
- `SavedPhoto.embeddings` → `p.pendingVectors ?? []` 로 매핑
- 얼굴 검색 임계값: `0.3 → 0.2`
- `GroupingService.cosineSimilarity()` 사용 (중복 제거)

---

### 10. 에뮬레이터 테스트용 갤러리 픽커 추가 (`frame_selection_screen.dart`)

에뮬레이터에서는 카메라로 얼굴 사진을 찍기 어려우므로 갤러리 선택 버튼 추가.

```dart
// 카메라 버튼 옆에 갤러리 버튼 추가
_takePictures(source: ImageSource.gallery)
```

---

### 11. 얼굴 인식 정확도 개선 (`face_recognition_service.dart`)

#### 변경 전 (단순 크롭)
```
ML Kit 감지 → bounding box 크롭 → 160×160 리사이즈 → FaceNet
```

#### 변경 후 (Affine Warp + L2 정규화)
```
ML Kit 감지 (enableLandmarks: true) → 눈 좌표 추출
→ Similarity Transform으로 출력 이미지 역산
→ 쌍선형 보간으로 160×160 직접 생성 (눈 위치 고정)
→ FaceNet → L2 정규화
```

**Affine Warp 원리**

복소수 나눗셈으로 similarity transform 행렬을 구한 뒤, 출력 픽셀에서 입력 픽셀로 역변환하는 방식.

```
a = (dst_right - dst_left) / (src_right - src_left)   # 복소수
b = dst_left - a * src_left
```

출력 160×160의 기준 눈 위치:
- 왼쪽 눈: (55, 65)
- 오른쪽 눈: (105, 65)

기존 방식(회전→크롭)은 보간 오류가 2회 발생하지만, affine warp는 1회로 끝나며 눈 위치가 항상 동일한 좌표에 고정된다.

**L2 정규화**

FaceNet은 L2 normalized 벡터 간 코사인 유사도로 비교하도록 설계됨. 정규화 없이 비교하면 유사도가 실제보다 낮게 나온다.

```dart
final norm = sqrt(embedding.fold(0.0, (sum, e) => sum + e * e));
return embedding.map((e) => e / norm).toList();
```

---

## 임계값 정리

| 구분 | 이전 | 현재 | 의미 |
|------|------|------|------|
| 갤러리 얼굴 검색 | 0.3 | **0.2** | 코사인 유사도 0.2 이상이면 동일인 |
| 그루핑 (새 그룹 생성) | 0.4 | **0.35** | 0.35 미만이면 새 인물로 판단 |

---

## 알려진 이슈 / 한계

| 항목 | 설명 |
|------|------|
| FaceNet 모델 한계 | 아시아 얼굴 데이터 비중이 낮은 모델일 수 있음. ArcFace로 교체 시 성능 향상 가능 |
| 얼굴 미감지 시 무음 실패 | ML Kit이 얼굴을 찾지 못하면 벡터 없이 저장됨 (사용자에게 알림 없음) |
| Affine Warp 성능 | Dart 픽셀 루프로 구현, 160×160 = 25,600 픽셀 처리. 대부분의 기기에서 문제 없으나 저사양 기기에서 느릴 수 있음 |
| 대표 이미지 경로 | 서버가 앱 내부 파일 경로를 저장하므로 기기가 바뀌면 경로가 무효화됨 |

---

## 로컬 개발 환경

### 서버 실행
```bash
cd apps/server
npm run start     # 또는 ts-node src/index.ts
```
포트: 3000

### Flutter 앱 실행
```bash
cd apps/flutter_project
flutter run
```
에뮬레이터 기준 서버 URL: `http://10.0.2.2:3000`

### 테스트 초기화
```bash
# 앱 데이터 삭제 (SharedPreferences 초기화)
adb shell pm clear com.example.flutter_project
```

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'photo_storage_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;

  /// pending 사진들을 서버에 업로드한다.
  /// 앱 시작 및 포어그라운드 복귀 시 호출된다.
  Future<void> enqueuePendingPhotos() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      // appInstanceId가 미등록(-1)이면 먼저 등록을 재시도한다.
      if (ApiService().appInstanceId == -1) {
        await _retryRegistration();
        if (ApiService().appInstanceId == -1) return; // 여전히 실패면 중단
      }

      final pending = await PhotoStorageService().getPendingUploads();
      for (final photo in pending) {
        try {
          await _uploadOne(photo);
        } catch (e) {
          debugPrint('SyncService: upload failed for ${photo.path}: $e');
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _retryRegistration() async {
    try {
      final id = await ApiService().registerAppInstance();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('phos_app_instance_id', id);
      ApiService().setAppInstanceId(id);
    } catch (e) {
      debugPrint('_retryRegistration failed: $e');
    }
  }

  Future<void> _uploadOne(LocalPhoto photo) async {
    final appInstanceId = ApiService().appInstanceId;
    if (appInstanceId == null || appInstanceId == -1) return;

    final vectors = <Map<String, dynamic>>[];
    final pendingVectors = photo.pendingVectors ?? [];

    for (int i = 0; i < pendingVectors.length; i++) {
      vectors.add({
        'vector': pendingVectors[i],
        'groupId': i < photo.groupIds.length ? photo.groupIds[i] : null,
      });
    }

    final serverPhotoId = await ApiService().uploadPhoto(
      appInstanceId: appInstanceId,
      imagePath: photo.path,
      vectors: vectors,
    );

    final updated = photo.copyWith(
      serverPhotoId: serverPhotoId,
      pendingUpload: false,
      // pendingVectors는 갤러리 얼굴 검색에 계속 필요하므로 유지
    );
    await PhotoStorageService().updatePhoto(photo.path, updated);
  }
}

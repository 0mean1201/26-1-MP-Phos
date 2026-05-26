import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 전역에서 선택된 프레임을 관리하는 싱글톤 서비스.
/// ChangeNotifier를 상속하여 선택 변경 시 UI를 자동으로 업데이트합니다.
class FrameService extends ChangeNotifier {
  // ── 싱글톤 ──────────────────────────────────────────────────────────────
  static final FrameService _instance = FrameService._internal();
  factory FrameService() => _instance;
  FrameService._internal();

  // ── 상수 ────────────────────────────────────────────────────────────────
  static const String _prefKey = 'phos_selected_frame';

  /// assets/images/ 폴더에 실제로 존재하는 파일명 목록.
  /// 새 프레임 파일을 추가하면 여기에도 추가해주세요.
  static const List<String> availableFrames = [
    '1.png',
    '2.png',
    '3.png',
    '4.png',
  ];

  // ── 상태 ────────────────────────────────────────────────────────────────
  /// 현재 선택된 프레임의 asset 경로. null이면 "프레임 없음".
  String? _selectedFrame;

  String? get selectedFrame => _selectedFrame;

  bool get hasFrame => _selectedFrame != null;

  // ── 초기화 ──────────────────────────────────────────────────────────────
  /// main()에서 FaceRecognitionService 초기화 직후 호출하세요.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    // 저장된 값이 현재 availableFrames 목록에 없으면 무시
    if (saved != null && availableFrames.contains(saved)) {
      _selectedFrame = 'assets/images/$saved';
    }
    // notifyListeners 불필요 (아직 위젯 트리 없음)
  }

  // ── 선택 변경 ────────────────────────────────────────────────────────────
  Future<void> selectFrame(String? fileName) async {
    final prefs = await SharedPreferences.getInstance();
    if (fileName == null) {
      _selectedFrame = null;
      await prefs.remove(_prefKey);
    } else {
      _selectedFrame = 'assets/images/$fileName';
      await prefs.setString(_prefKey, fileName);
    }
    notifyListeners();
  }

  /// 파일명만 반환 (UI 비교용)
  String? get selectedFileName {
    if (_selectedFrame == null) return null;
    return _selectedFrame!.split('/').last;
  }
}

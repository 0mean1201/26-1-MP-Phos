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
  // ── 기본 프레임: 장식 없이 단색 배경만 있는 프레임 ───────────────────────
  static const List<String> basicFrames = [
    '6.png',   // 1x4 검정
    '7.png',   // 1x4 파랑
    '8.png',   // 1x4 빨강
    '9.png',   // 1x4 검정2
    '10.png',  // 2x2 검정
    '11.png',  // 2x2 초록
    '12.png',  // 1x3 노랑
    '13.png',  // 1x3 보라
  ];

  // ── 컨셉 프레임: 캐릭터/브랜드 등 장식이 있는 프레임 ────────────────────
  static const List<String> conceptFrames = [
    '1.png',   // 1x3 베이지 (with natural ground)
    '2.png',   // 1x3 가천 파랑
    '3.png',   // 1x3 가천 뉴스
    '4.png',   // 2x2 빅변내컷
    '5.png',   // 1x4 맨유
  ];

  // ── 전체 목록 (저장값 유효성 검사용) ──────────────────────────────────
  static List<String> get availableFrames => [...basicFrames, ...conceptFrames];

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

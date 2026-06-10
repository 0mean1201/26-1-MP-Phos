import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
/// 앱 전역에서 선택된 프레임을 관리하는 싱글톤 서비스.
class FrameService extends ChangeNotifier {
  // ── 싱글톤 ──────────────────────────────────────────────────────────────
  static final FrameService _instance = FrameService._internal();
  factory FrameService() => _instance;
  FrameService._internal();
 
  static const String _prefKey = 'phos_selected_frame';
 
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
    '15.png',  // 1x4 보라
    '16.png',  // 1x4 노랑
    '17.png',  // 1x4 빨강2
    '18.png',  // 2x2 노랑
    '19.png',  // 2x2 파랑
    '20.png',  // 2x2 빨강
    '21.png',  // 1x3 초록
    '22.png',  // 1x3 보라2
    '23.png',  // 1x3 파랑
    '24.png',  // 1x3 빨강
    '31.png',  // solo 검정
    '32.png',  // solo 보라
    '33.png',  // solo 파랑
    '34.png',  // solo 초록
    '35.png',  // solo 노랑
    '36.png',  // solo 빨강
  ];
 
  // ── 컨셉 프레임: 캐릭터/브랜드 등 장식이 있는 프레임 ────────────────────
  static const List<String> conceptFrames = [
    '1.png',   // 1x3 베이지
    '2.png',   // 1x3 가천 파랑
    '3.png',   // 1x3 가천 뉴스
    '4.png',   // 2x2 빅변내컷
    '5.png',   // 1x4 맨유
    '25.png',  // 1x3 가천 학교
    '26.png',  // 1x3 맨유
    '27.png',  // 2x2 맨유
    '28.png',  // 2x2 가천대컷
    '29.png',  // 1x4 가천컷
    '30.png',  // 1x4 빅변내컷
    '37.png',  // solo 가천
    '38.png',  // solo 빅변내컷
    '39.png',  // solo 맨유
  ];
 
  // ── 전체 목록 (저장값 유효성 검사용) ──────────────────────────────────
  static List<String> get availableFrames => [...basicFrames, ...conceptFrames];
 
  // ── FrameType별 호환 프레임 목록 (레이아웃 모양 기준) ──────────────────
  // classic = 1×4 세로 스트립
  // square  = 2×2 그리드
  // trio    = 1×3 세로 스트립
  // solo    = 호환 프레임 없음
  static const Map<String, List<String>> frameTypeCompatibility = {
    'classic': ['5.png','6.png','7.png','8.png','15.png','16.png','17.png','29.png','30.png'],
    'square':  ['4.png','9.png','10.png','11.png','18.png','19.png','20.png','27.png','28.png'],
    'trio':    ['1.png','2.png','3.png','12.png','13.png','21.png','22.png','23.png','24.png','25.png','26.png'],
    'solo':    ['31.png','32.png','33.png','34.png','35.png','36.png','37.png','38.png','39.png'],
  };
 
  /// 현재 FrameType에서 사용 가능한 프레임 목록 반환
  static List<String> compatibleFrames(String frameTypeName) {
    return frameTypeCompatibility[frameTypeName] ?? [];
  }
 
  // ── 상태 ──────────────────────────────────────────────────────────────
  String? _selectedFrame;
  String? get selectedFrame => _selectedFrame;
  bool get hasFrame => _selectedFrame != null;
 
  // ── 초기화 ────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null && availableFrames.contains(saved)) {
      _selectedFrame = 'assets/images/$saved';
    }
  }
 
  // ── 선택 변경 ──────────────────────────────────────────────────────────
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
 
  String? get selectedFileName {
    if (_selectedFrame == null) return null;
    return _selectedFrame!.split('/').last;
  }
}
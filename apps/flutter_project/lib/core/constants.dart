import 'package:flutter/material.dart';

class AppColors {
  // ── 라이트 모드 ──────────────────────────────────
  static const Color primary     = Color(0xFF9D72FF);
  static const Color background  = Color(0xFFFAF9F6);
  static const Color textMain    = Colors.black87;
  static const Color textSub     = Colors.grey;

  // ── 다크 모드 ────────────────────────────────────
  static const Color darkBackground  = Color(0xFF1E1030); // 다크 퍼플
  static const Color darkSurface     = Color(0xFF2A1F45); // 카드/서피스
  static const Color darkNavBar      = Color(0xFF251840); // 하단 네비
  static const Color darkPrimary     = Color(0xFFC4A8FF); // 밝은 라벤더
  static const Color darkTextMain    = Color(0xFFF0EAFF);
  static const Color darkTextSub     = Color(0xFF9B8FBB);
  static const Color darkDivider     = Color(0xFF3D2E60);
  static const Color darkSurface2 = Color(0xFF2C2C2C);

  /// 현재 테마에 맞는 색상을 리턴하는 헬퍼
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBackground : background;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : Colors.white;

  static Color primaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkPrimary : primary;

  static Color textMainOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextMain : textMain;

  static Color textSubOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSub : textSub;

  static Color dividerOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkDivider : Colors.grey.shade200;
}

enum FrameType {
  classic('CLASSIC', 120.0, 4),
  square('SQUARE',  100.0, 4),
  trio('TRIO',      110.0, 3),
  solo('SOLO',       90.0, 1);

  final String label;
  final double defaultHeight;
  final int photoCount;

  const FrameType(this.label, this.defaultHeight, this.photoCount);
}
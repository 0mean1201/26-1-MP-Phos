import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'frame_selection_screen.dart';
import '../core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gallery_screen.dart';
import 'main_layout.dart';

// ====================================================
// 1. 홈 화면
// ====================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.bg(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 상단 헤더 ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu,
                          color: isDark ? AppColors.darkTextSub : Colors.black54),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Text(
                    "pho's",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 40),

              // ── 타이틀 ─────────────────────────────
              Text(
                'CAPTURE THE MOMENT',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: AppColors.textSubOf(context),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '오늘의 조각을\n기록해보세요',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 30),

              // ── 촬영 버튼 ──────────────────────────
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FrameSelectionScreen()),
                    );
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    'Take a Shot',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ── Latest Strips ──────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Strips',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textMain),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('VIEW ALL',
                        style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const LatestStripsList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}


// ====================================================
// 2. Drawer
// ====================================================
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.bg(context);
    final surfaceColor = AppColors.surface(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("pho's",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Capture the moment',
                      style: TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 설정 섹션 라벨 ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('설정',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textSub,
                      letterSpacing: 1.2)),
            ),
            const SizedBox(height: 8),

            // ── 테마 토글 ────────────────────────────
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                final isD = mode == ThemeMode.dark;
                return _DrawerTile(
                  icon: isD ? Icons.dark_mode : Icons.light_mode,
                  title: '테마',
                  subtitle: isD ? '다크 모드' : '라이트 모드',
                  iconColor: primaryColor,
                  textColor: textMain,
                  subtitleColor: textSub,
                  surfaceColor: surfaceColor,
                  trailing: Switch(
                    value: isD,
                    activeColor: primaryColor,
                    onChanged: (val) {
                      themeNotifier.value =
                          val ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                  onTap: () {
                    themeNotifier.value =
                        isD ? ThemeMode.light : ThemeMode.dark;
                  },
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: AppColors.dividerOf(context)),
            ),

            // ── 정보 섹션 라벨 ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('정보',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textSub,
                      letterSpacing: 1.2)),
            ),
            const SizedBox(height: 8),

            _DrawerTile(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전 및 라이센스',
              iconColor: primaryColor,
              textColor: textMain,
              subtitleColor: textSub,
              surfaceColor: surfaceColor,
              onTap: () {
                Navigator.pop(context);
                _showAppInfoDialog(context, primaryColor, isDark);
              },
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('v1.0.0',
                  style: TextStyle(fontSize: 11, color: textSub)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog(
      BuildContext context, Color primaryColor, bool isDark) {
    final dialogBg =
        isDark ? AppColors.darkSurface : AppColors.background;
    final textMain =
        isDark ? AppColors.darkTextMain : AppColors.textMain;
    final textSub =
        isDark ? AppColors.darkTextSub : const Color(0xFF9E9E9E);
    final cardBg =
        isDark ? AppColors.darkBackground : Colors.grey.shade100;
    final borderColor = primaryColor.withOpacity(0.25);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 앱 아이콘 + 이름
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("pho's",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                        Text('버전 1.0.0',
                            style: TextStyle(
                                fontSize: 12, color: textSub)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : Colors.grey.shade300),
                const SizedBox(height: 12),

                Text('오픈소스 라이센스',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textMain)),
                const SizedBox(height: 12),

                _LicenseItem(
                  name: 'FaceNet TFLite Model',
                  copyright: 'Copyright © 2019 Kuan-Yu Huang',
                  license: 'Apache License 2.0',
                  description:
                      '얼굴 인식에 사용된 FaceNet 512 모델입니다.\n'
                      '원본 저작권자의 권리가 보호됩니다.',
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textMain: textMain,
                  textSub: textSub,
                ),
                const SizedBox(height: 10),
                _LicenseItem(
                  name: 'tflite_flutter',
                  copyright: 'Copyright © 2024 Shubham Panchal',
                  license: 'Apache License 2.0',
                  description:
                      'Flutter에서 TFLite 모델 실행을 위한 플러그인입니다.\n'
                      'Apache License 2.0에 따라 자유롭게 사용, 배포 및 수정이 가능합니다.',
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textMain: textMain,
                  textSub: textSub,
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Apache License 2.0 — 소스 코드 사용, 복제, 배포, 수정 및 '
                    '파생 저작물 배포를 허용합니다. 재배포 시 원본 라이센스 사본을 포함해야 합니다.\n\n'
                    'http://www.apache.org/licenses/LICENSE-2.0',
                    style: TextStyle(
                        fontSize: 10, color: textSub, height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('닫기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 라이센스 항목 ─────────────────────────────────────
class _LicenseItem extends StatelessWidget {
  final String name, copyright, license, description;
  final Color primaryColor, cardBg, borderColor, textMain, textSub;

  const _LicenseItem({
    required this.name,
    required this.copyright,
    required this.license,
    required this.description,
    required this.primaryColor,
    required this.cardBg,
    required this.borderColor,
    required this.textMain,
    required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textMain)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(license,
                    style: TextStyle(
                        fontSize: 9,
                        color: primaryColor,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(copyright,
              style: TextStyle(fontSize: 10, color: textSub)),
          const SizedBox(height: 6),
          Text(description,
              style: TextStyle(
                  fontSize: 11, height: 1.5, color: textSub)),
        ],
      ),
    );
  }
}

// ── Drawer 타일 ───────────────────────────────────────
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color iconColor, textColor, subtitleColor, surfaceColor;

  const _DrawerTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    required this.iconColor,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(fontSize: 11, color: subtitleColor))
          : null,
      trailing: trailing ??
          Icon(Icons.chevron_right, color: subtitleColor),
      onTap: onTap,
    );
  }
}


// ====================================================
// 3. LatestStripsList
// ====================================================
class LatestStripsList extends StatefulWidget {
  const LatestStripsList({super.key});

  @override
  State<LatestStripsList> createState() => _LatestStripsListState();
}

class _LatestStripsListState extends State<LatestStripsList> {
  List<SavedPhoto> _latestPhotos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestPhotos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLatestPhotos();
  }

  Future<void> _loadLatestPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStrings = prefs.getStringList('phos_gallery_data') ?? [];
    final loadedPhotos = <SavedPhoto>[];

    for (final jsonStr in savedStrings) {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final type = FrameType.values.firstWhere(
        (e) => e.name == data['frameType'],
        orElse: () => FrameType.classic,
      );
      loadedPhotos.add(SavedPhoto(
        path: data['path'],
        frameType: type,
        title: data['title'],
        tag: data['tag'],
      ));
    }

    if (mounted) {
      setState(() {
        _latestPhotos = loadedPhotos.reversed.take(5).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.surface(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final shadowColor =
        isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05);

    if (_isLoading) {
      return const SizedBox(
          height: 260,
          child: Center(child: CircularProgressIndicator()));
    }

    if (_latestPhotos.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: Text(
          '아직 촬영된 사진이 없습니다.\n첫 조각을 기록해보세요!',
          textAlign: TextAlign.center,
          style: TextStyle(color: textSub),
        ),
      );
    }

    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _latestPhotos.length,
        itemBuilder: (context, index) {
          final photo = _latestPhotos[index];
          final fileStat = File(photo.path).statSync();
          final dateStr =
              "${fileStat.modified.year}.${fileStat.modified.month.toString().padLeft(2, '0')}.${fileStat.modified.day.toString().padLeft(2, '0')}";

          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16, bottom: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: shadowColor,
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            color: isDark
                                ? AppColors.darkBackground
                                : Colors.black12,
                            child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey)),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(photo.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textMain),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(dateStr,
                          style: TextStyle(
                              color: textSub, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
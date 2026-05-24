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
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  Text("pho's",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 40),
              Text('CAPTURE THE MOMENT',
                  style: TextStyle(fontSize: 12, letterSpacing: 1.5, color: textSub)),
              const SizedBox(height: 10),
              Text('오늘의 조각을\n기록해보세요',
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w900, height: 1.3, color: textMain)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FrameSelectionScreen())),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text('Take a Shot',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Latest Strips',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textMain)),
                  TextButton(
                    onPressed: () {},
                    child: Text('VIEW ALL', style: TextStyle(color: primaryColor)),
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
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final drawerBg = isDark ? AppColors.darkSurface : AppColors.background;

    return Drawer(
      backgroundColor: drawerBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("pho's",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Capture the moment',
                      style: TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 설정 섹션
            _SectionLabel(label: '설정', color: textSub),
            const SizedBox(height: 8),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                final isD = mode == ThemeMode.dark;
                return _DrawerTile(
                  icon: isD ? Icons.dark_mode : Icons.light_mode_outlined,
                  title: '테마',
                  subtitle: isD ? '다크 모드' : '라이트 모드',
                  iconColor: primaryColor,
                  textColor: textMain,
                  subtitleColor: textSub,
                  trailing: Switch(
                    value: isD,
                    activeColor: primaryColor,
                    onChanged: (val) =>
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light,
                  ),
                  onTap: () => themeNotifier.value = isD ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: AppColors.dividerOf(context)),
            ),

            // ── 정보 섹션
            _SectionLabel(label: '정보', color: textSub),
            const SizedBox(height: 8),
            _DrawerTile(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전 및 라이센스',
              iconColor: primaryColor,
              textColor: textMain,
              subtitleColor: textSub,
              onTap: () {
                Navigator.pop(context);
                _showAppInfoDialog(context);
              },
            ),
            _DrawerTile(
              icon: Icons.privacy_tip_outlined,
              title: '개인정보 처리방침',
              subtitle: '수집 · 이용 · 보호 정책',
              iconColor: primaryColor,
              textColor: textMain,
              subtitleColor: textSub,
              onTap: () {
                Navigator.pop(context);
                _showPrivacyDialog(context);
              },
            ),
            _DrawerTile(
              icon: Icons.mail_outline,
              title: '문의하기',
              subtitle: 'mpphos.support@gmail.com',
              iconColor: primaryColor,
              textColor: textMain,
              subtitleColor: textSub,
              onTap: () {
                Navigator.pop(context);
                _showContactDialog(context);
              },
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('v1.0.0', style: TextStyle(fontSize: 11, color: textSub)),
            ),
          ],
        ),
      ),
    );
  }

  // ── 앱 정보 다이얼로그
  void _showAppInfoDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryOf(context);
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.background;
    final cardBg = isDark ? AppColors.darkSurface2 : Colors.grey.shade100;
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final borderColor = AppColors.dividerOf(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("pho's",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                        Text('버전 1.0.0', style: TextStyle(fontSize: 12, color: textSub)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: borderColor),
                const SizedBox(height: 12),
                Text('오픈소스 라이센스',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
                const SizedBox(height: 12),
                _LicenseItem(
                  name: 'FaceNet TFLite Model',
                  copyright: 'Copyright © 2019 Kuan-Yu Huang',
                  license: 'Apache License 2.0',
                  description: '얼굴 인식에 사용된 FaceNet 512 모델입니다.\n원본 저작권자의 권리가 보호됩니다.',
                  primaryColor: primaryColor, cardBg: cardBg,
                  borderColor: borderColor, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 10),
                _LicenseItem(
                  name: 'tflite_flutter',
                  copyright: 'Copyright © 2024 Shubham Panchal',
                  license: 'Apache License 2.0',
                  description: 'Flutter에서 TFLite 모델 실행을 위한 플러그인입니다.\nApache License 2.0에 따라 자유롭게 사용, 배포 및 수정이 가능합니다.',
                  primaryColor: primaryColor, cardBg: cardBg,
                  borderColor: borderColor, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Apache License 2.0 — 소스 코드 사용, 복제, 배포, 수정 및 파생 저작물 배포를 허용합니다. 재배포 시 원본 라이센스 사본을 포함해야 합니다.\n\nhttp://www.apache.org/licenses/LICENSE-2.0',
                    style: TextStyle(fontSize: 10, color: textSub, height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  // ── 개인정보 처리방침 다이얼로그
  void _showPrivacyDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryOf(context);
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.background;
    final cardBg = isDark ? AppColors.darkSurface2 : Colors.grey.shade100;
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final borderColor = AppColors.dividerOf(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.privacy_tip_outlined, color: primaryColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('개인정보 처리방침',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textMain)),
                          Text('최종 업데이트: 2026.05', style: TextStyle(fontSize: 11, color: textSub)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: borderColor),
                const SizedBox(height: 12),

                _PrivacySection(
                  icon: Icons.info_outline,
                  title: '1. 개요',
                  content: "pho's(이하 '앱')는 사용자의 개인정보를 매우 중요하게 생각합니다. "
                      "본 방침은 앱이 수집하는 정보의 종류, 사용 방법, 보호 조치를 설명합니다.",
                  primaryColor: primaryColor, cardBg: cardBg, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 10),
                _PrivacySection(
                  icon: Icons.no_photography_outlined,
                  title: '2. 이미지 데이터 처리',
                  content: "• 얼굴 인식 및 분류에 사용되는 AI 모델(FaceNet)은 기기 내에서만 동작합니다.\n"
                      "• 촬영 또는 선택한 이미지는 외부 서버로 전송되지 않으며, 오직 기기 로컬 저장소에만 저장됩니다.\n"
                      "• 얼굴 임베딩(특징 벡터) 데이터는 인물 그룹화 목적으로만 사용되며, 원본 이미지와 함께 기기에 저장됩니다.\n"
                      "• 앱 삭제 시 저장된 모든 데이터는 기기에서 완전히 삭제됩니다.",
                  primaryColor: primaryColor, cardBg: cardBg, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 10),
                _PrivacySection(
                  icon: Icons.cloud_outlined,
                  title: '3. 서버 통신',
                  content: "• 앱 인스턴스 등록 및 인물 그룹 정보(그룹 ID, 그룹 이름) 관리를 위해 최소한의 데이터만 서버와 통신합니다.\n"
                      "• 서버로 전송되는 데이터는 이미지 파일 경로(기기 내부 경로)와 얼굴 특징 벡터(숫자 배열)에 한정됩니다.\n"
                      "• 실제 이미지(사진 파일)는 어떠한 경우에도 외부 서버로 전송되지 않습니다.",
                  primaryColor: primaryColor, cardBg: cardBg, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 10),
                _PrivacySection(
                  icon: Icons.perm_camera_mic_outlined,
                  title: '4. 앱 권한',
                  content: "• 카메라: 사진 촬영 기능에만 사용됩니다.\n"
                      "• 저장소: 촬영된 사진을 기기에 저장하기 위해 사용됩니다.\n"
                      "• 위 권한들은 해당 기능 사용 시에만 요청되며, 목적 외 용도로 사용되지 않습니다.",
                  primaryColor: primaryColor, cardBg: cardBg, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 10),
                _PrivacySection(
                  icon: Icons.mail_outline,
                  title: '5. 문의',
                  content: "개인정보 처리방침에 관한 문의사항은 아래 이메일로 연락해 주세요.\nmpphos.support@gmail.com",
                  primaryColor: primaryColor, cardBg: cardBg, textMain: textMain, textSub: textSub,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 문의하기 다이얼로그
  void _showContactDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryOf(context);
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.background;
    final cardBg = isDark ? AppColors.darkSurface2 : Colors.grey.shade100;
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: dialogBg,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.mail_outline, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('문의하기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: cardBg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('앱 사용 중 불편한 점이나 건의사항이 있으신가요?\n아래 이메일로 문의해 주시면 빠르게 답변 드리겠습니다.',
                        style: TextStyle(fontSize: 13, color: textSub, height: 1.6)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.email, color: primaryColor, size: 18),
                        const SizedBox(width: 8),
                        SelectableText(
                          'mpphos.support@gmail.com',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('· 이메일 제목에 [pho\'s 문의]를 포함해 주세요.\n· 문의 내용과 기기 정보를 함께 작성해 주시면 더욱 빠른 답변이 가능합니다.',
                        style: TextStyle(fontSize: 11, color: textSub, height: 1.6)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 섹션 라벨
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color, letterSpacing: 1.2)),
    );
  }
}

// ── 개인정보 처리방침 섹션 카드
class _PrivacySection extends StatelessWidget {
  final IconData icon;
  final String title, content;
  final Color primaryColor, cardBg, textMain, textSub;

  const _PrivacySection({
    required this.icon, required this.title, required this.content,
    required this.primaryColor, required this.cardBg,
    required this.textMain, required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 16),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textMain)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 12, color: textSub, height: 1.6)),
        ],
      ),
    );
  }
}

// ── 라이센스 항목
class _LicenseItem extends StatelessWidget {
  final String name, copyright, license, description;
  final Color primaryColor, cardBg, borderColor, textMain, textSub;

  const _LicenseItem({
    required this.name, required this.copyright,
    required this.license, required this.description,
    required this.primaryColor, required this.cardBg,
    required this.borderColor, required this.textMain, required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textMain)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(license,
                    style: TextStyle(fontSize: 9, color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(copyright, style: TextStyle(fontSize: 10, color: textSub)),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(fontSize: 11, height: 1.5, color: textSub)),
        ],
      ),
    );
  }
}

// ── Drawer 타일
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color iconColor, textColor, subtitleColor;

  const _DrawerTile({
    required this.icon, required this.title, this.subtitle,
    this.trailing, required this.onTap,
    required this.iconColor, required this.textColor, required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(fontSize: 11, color: subtitleColor))
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: subtitleColor),
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
  void initState() { super.initState(); _loadLatestPhotos(); }

  @override
  void didChangeDependencies() { super.didChangeDependencies(); _loadLatestPhotos(); }

  Future<void> _loadLatestPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStrings = prefs.getStringList('phos_gallery_data') ?? [];
    final loaded = <SavedPhoto>[];
    for (final s in savedStrings) {
      final data = jsonDecode(s) as Map<String, dynamic>;
      final type = FrameType.values.firstWhere(
          (e) => e.name == data['frameType'], orElse: () => FrameType.classic);
      loaded.add(SavedPhoto(path: data['path'], frameType: type, title: data['title'], tag: data['tag']));
    }
    if (mounted) setState(() { _latestPhotos = loaded.reversed.take(5).toList(); _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.surface(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final shadowColor = isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.05);

    if (_isLoading) return const SizedBox(height: 260, child: Center(child: CircularProgressIndicator()));
    if (_latestPhotos.isEmpty) {
      return Container(
        height: 150, alignment: Alignment.center,
        child: Text('아직 촬영된 사진이 없습니다.\n첫 조각을 기록해보세요!',
            textAlign: TextAlign.center, style: TextStyle(color: textSub)),
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
          final dateStr = "${fileStat.modified.year}.${fileStat.modified.month.toString().padLeft(2,'0')}.${fileStat.modified.day.toString().padLeft(2,'0')}";
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16, bottom: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: AppColors.darkDivider, width: 1) : null,
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 4 : 10, spreadRadius: isDark ? 0 : 2)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200, width: double.infinity,
                    child: Image.file(File(photo.path), fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: isDark ? AppColors.darkSurface2 : Colors.black12,
                          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(photo.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textMain),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(dateStr, style: TextStyle(color: textSub, fontSize: 10)),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
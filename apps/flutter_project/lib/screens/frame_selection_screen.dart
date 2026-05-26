import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';
import '../services/frame_service.dart';
import 'pose_camera_screen.dart';
import 'result_screen.dart';
 
class FrameSelectionScreen extends StatefulWidget {
  const FrameSelectionScreen({super.key});
 
  @override
  State<FrameSelectionScreen> createState() => _FrameSelectionScreenState();
}
 
class _FrameSelectionScreenState extends State<FrameSelectionScreen>
    with SingleTickerProviderStateMixin {
  FrameType _selectedFrame = FrameType.classic;
  final ImagePicker _picker = ImagePicker();
  bool _isShooting = false;
 
  final FrameService _frameService = FrameService();
  String? _pendingOverlayFileName;
 
  late final AnimationController _fadeController;
  late final Animation<double> _fadeIn;
 
  @override
  void initState() {
    super.initState();
    _pendingOverlayFileName = _frameService.selectedFileName;
 
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }
 
  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
 
  // ── 인앱 카메라 (main 브랜치: PoseCameraScreen 연동) ──────────────────────
  Future<void> _launchInAppCamera() async {
    final String? overlayPath = _pendingOverlayFileName != null
        ? 'assets/images/$_pendingOverlayFileName'
        : null;
    await _frameService.selectFrame(_pendingOverlayFileName);
 
    setState(() => _isShooting = true);
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PoseCameraScreen(
            cameras: cameras,
            selectedFrame: _selectedFrame,
            overlayFrame: overlayPath,
          ),
        ),
      );
    } catch (e) {
      debugPrint('카메라 초기화 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카메라를 열 수 없습니다. 권한을 확인해주세요.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isShooting = false);
    }
  }
 
  // ── 갤러리에서 선택 ───────────────────────────────────────────────────────
  Future<void> _pickFromGallery() async {
    final String? overlayPath = _pendingOverlayFileName != null
        ? 'assets/images/$_pendingOverlayFileName'
        : null;
    await _frameService.selectFrame(_pendingOverlayFileName);
 
    setState(() => _isShooting = true);
    final pickedPhotos = <XFile>[];
    final targetCount = _selectedFrame.photoCount;
    try {
      for (int i = 0; i < targetCount; i++) {
        final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
        if (photo != null) {
          pickedPhotos.add(photo);
        } else {
          break;
        }
      }
      if (pickedPhotos.length == targetCount && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              selectedFrame: _selectedFrame,
              photos: pickedPhotos,
              overlayFrame: overlayPath,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('갤러리 오류: $e');
    } finally {
      if (mounted) setState(() => _isShooting = false);
    }
  }
 
  // ── 레이아웃 미리보기 (다크모드 + 오버레이 모두 반영) ──────────────────────
  Widget _buildFrameLayoutPreview(bool isDark) {
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;
    final trioBg = isDark ? const Color(0xFF3D2040) : Colors.pink[100]!;
    final slotColor = isDark ? AppColors.darkSurface2 : Colors.grey.shade300;
    final borderColor = isDark ? AppColors.darkDivider : Colors.grey.shade300;
 
    return SizedBox(
      width: 180,
      height: 250,
      child: Stack(
        children: [
          // 기본 프레임: 커스텀 선택 시 숨김
          Visibility(
            visible: _pendingOverlayFileName == null,
            child: Container(
              width: 180,
              height: 250,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _selectedFrame == FrameType.trio ? trioBg : bgColor,
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.4)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _selectedFrame == FrameType.square
                  ? GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: 4,
                      itemBuilder: (_, __) => Container(color: slotColor),
                    )
                  : Column(
                      children: List.generate(
                        _selectedFrame.photoCount,
                        (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            color: slotColor,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
 
          // 커스텀 프레임: 선택 시에만 표시
          if (_pendingOverlayFileName != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Image.asset(
                'assets/images/$_pendingOverlayFileName',
                key: ValueKey(_pendingOverlayFileName),
                width: 180,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
 
  // ── 커스텀 프레임 가로 목록 ───────────────────────────────────────────────
  Widget _buildCustomFrameRow(bool isDark) {
    final frames = FrameService.availableFrames;
    final primaryColor = AppColors.primaryOf(context);
 
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: frames.length + 1, // +1 for "없음" slot
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          // 첫 번째 슬롯 = "없음"
          if (index == 0) {
            final isNone = _pendingOverlayFileName == null;
            return GestureDetector(
              onTap: () => setState(() => _pendingOverlayFileName = null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 56,
                decoration: BoxDecoration(
                  color: isNone
                      ? primaryColor.withOpacity(0.1)
                      : (isDark ? AppColors.darkSurface : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isNone
                        ? primaryColor
                        : (isDark ? AppColors.darkDivider : Colors.grey.shade300),
                    width: isNone ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.block,
                        size: 20,
                        color: isNone
                            ? primaryColor
                            : (isDark ? Colors.grey.shade600 : Colors.grey.shade400)),
                    const SizedBox(height: 4),
                    Text(
                      '없음',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isNone ? FontWeight.w700 : FontWeight.w400,
                        color: isNone
                            ? primaryColor
                            : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
 
          final fileName = frames[index - 1];
          final isSelected = _pendingOverlayFileName == fileName;
 
          return GestureDetector(
            onTap: () => setState(() => _pendingOverlayFileName = fileName),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? AppColors.darkDivider : Colors.grey.shade300),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.25),
                          blurRadius: 8,
                        )
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      'assets/images/$fileName',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: isDark ? AppColors.darkSurface2 : Colors.grey.shade100,
                        child: Icon(Icons.broken_image_outlined,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                            size: 20),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 3,
                      right: 3,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 10),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.bg(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
 
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── 헤더 ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textMain),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "pho's",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
 
                // ── 미리보기 ─────────────────────────────────────────────
                const SizedBox(height: 8),
                _buildFrameLayoutPreview(isDark),
                const SizedBox(height: 32),
 
                // ── 규격(FrameType) 선택 카드 ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: FrameType.values.map((frame) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.5),
                      child: FrameOptionCard(
                        frameType: frame,
                        isSelected: _selectedFrame == frame,
                        onTap: () => setState(() => _selectedFrame = frame),
                      ),
                    );
                  }).toList(),
                ),
 
                const SizedBox(height: 20),
 
                // ── 구분선 + 커스텀 프레임 라벨 ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '커스텀 프레임',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Divider(
                          color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 12),
 
                // ── 커스텀 프레임 가로 목록 ───────────────────────────────
                _buildCustomFrameRow(isDark),
 
                const SizedBox(height: 40),
 
                // ── 촬영 버튼 ────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 갤러리 버튼
                    GestureDetector(
                      onTap: _isShooting ? null : _pickFromGallery,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: Icon(Icons.photo_library, color: primaryColor, size: 24),
                      ),
                    ),
                    const SizedBox(width: 32),
 
                    // 카메라 버튼
                    GestureDetector(
                      onTap: _isShooting ? null : _launchInAppCamera,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 8,
                          ),
                        ),
                        child: _isShooting
                            ? const Padding(
                                padding: EdgeInsets.all(22),
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3),
                              )
                            : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 88),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
// ── FrameOptionCard (다크모드 대응) ──────────────────────────────────────────
class FrameOptionCard extends StatelessWidget {
  final FrameType frameType;
  final bool isSelected;
  final VoidCallback onTap;
 
  const FrameOptionCard({
    super.key,
    required this.frameType,
    required this.isSelected,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryOf(context);
    final textSub = AppColors.textSubOf(context);
 
    final normalBg = isDark ? AppColors.darkSurface : Colors.white;
    final trioBg = isDark ? const Color(0xFF3D2040) : Colors.pink[100]!;
    final boxColor = frameType == FrameType.trio ? trioBg : normalBg;
 
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: frameType.defaultHeight,
            decoration: BoxDecoration(
              color: boxColor,
              border: Border.all(
                color: isSelected ? primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            frameType.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? primaryColor : textSub,
            ),
          ),
        ],
      ),
    );
  }
}
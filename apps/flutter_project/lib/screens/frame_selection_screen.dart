import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';
import 'pose_camera_screen.dart';
import 'result_screen.dart';

class FrameSelectionScreen extends StatefulWidget {
  const FrameSelectionScreen({super.key});
  @override
  State<FrameSelectionScreen> createState() => _FrameSelectionScreenState();
}

class _FrameSelectionScreenState extends State<FrameSelectionScreen> {
  FrameType _selectedFrame = FrameType.classic;
  bool _isShooting = false;

  Future<void> _launchInAppCamera() async {
    setState(() => _isShooting = true);
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(
        builder: (_) => PoseCameraScreen(cameras: cameras, selectedFrame: _selectedFrame),
      ));
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

  Future<void> _pickFromGallery() async {
    setState(() => _isShooting = true);
    final pickedPhotos = <XFile>[];
    final targetCount = _selectedFrame.photoCount;
    try {
      for (int i = 0; i < targetCount; i++) {
        final XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (photo != null) pickedPhotos.add(photo); else break;
      }
      if (pickedPhotos.length == targetCount && mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(selectedFrame: _selectedFrame, photos: pickedPhotos),
        ));
      }
    } catch (e) {
      debugPrint('갤러리 오류: $e');
    } finally {
      if (mounted) setState(() => _isShooting = false);
    }
  }

  Widget _buildFramePreview(bool isDark) {
    // 다크모드 대응 색상
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;
    final trioBg = isDark ? const Color(0xFF3D2040) : Colors.pink[100]!;
    final slotColor = isDark ? AppColors.darkSurface2 : Colors.grey.shade300;
    final borderColor = isDark ? AppColors.darkDivider : Colors.grey.shade300;

    return Container(
      width: 180,
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _selectedFrame == FrameType.trio ? trioBg : bgColor,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: _selectedFrame == FrameType.square
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemCount: 4,
              itemBuilder: (_, __) => Container(color: slotColor),
            )
          : Column(
              children: List.generate(_selectedFrame.photoCount, (index) => Expanded(
                child: Container(margin: const EdgeInsets.only(bottom: 5), color: slotColor),
              )),
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
        child: Column(
          children: [
            // 앱바
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textMain),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("pho's",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 프레임 미리보기
            _buildFramePreview(isDark),
            const Spacer(),

            // 프레임 선택 카드
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
            const SizedBox(height: 50),

            // 촬영 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 갤러리 버튼
                GestureDetector(
                  onTap: _isShooting ? null : _pickFromGallery,
                  child: Container(
                    width: 56, height: 56,
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
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withOpacity(0.3), width: 8),
                    ),
                    child: _isShooting
                        ? const Padding(
                            padding: EdgeInsets.all(22),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 88),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// FrameOptionCard
class FrameOptionCard extends StatelessWidget {
  final FrameType frameType;
  final bool isSelected;
  final VoidCallback onTap;

  const FrameOptionCard({
    super.key, required this.frameType, required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryOf(context);
    final textSub = AppColors.textSubOf(context);

    // 다크모드 카드 색상
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
                color: isSelected ? primaryColor : Colors.transparent, width: 2),
            ),
          ),
          const SizedBox(height: 10),
          Text(frameType.label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primaryColor : textSub)),
        ],
      ),
    );
  }
}
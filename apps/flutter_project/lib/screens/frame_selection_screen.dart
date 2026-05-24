// lib/screens/frame_selection_screen.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';
import 'pose_camera_screen.dart'; // 💡 앱 내장 카메라 화면 import
import 'result_screen.dart';

class FrameSelectionScreen extends StatefulWidget {
  const FrameSelectionScreen({super.key});

  @override
  State<FrameSelectionScreen> createState() => _FrameSelectionScreenState();
}

class _FrameSelectionScreenState extends State<FrameSelectionScreen> {
  FrameType _selectedFrame = FrameType.classic;
  bool _isShooting = false;

  // ──────────────────────────────────────────────
  // 💡 [핵심 변경] 앱 내장 카메라(PoseCameraScreen) 실행
  //    → 시스템 카메라(ImagePicker) 대신 사용
  // ──────────────────────────────────────────────
  Future<void> _launchInAppCamera() async {
    setState(() => _isShooting = true);
    try {
      // 디바이스에서 사용 가능한 카메라 목록을 먼저 받아옴
      final cameras = await availableCameras();
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PoseCameraScreen(
            cameras: cameras,
            selectedFrame: _selectedFrame, // 💡 몇 장 찍을지 프레임 정보 전달
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

  // ──────────────────────────────────────────────
  // 갤러리에서 선택 (기존 ImagePicker 로직 유지)
  // ──────────────────────────────────────────────
  Future<void> _pickFromGallery() async {
    setState(() => _isShooting = true);
    List<XFile> pickedPhotos = [];
    int targetCount = _selectedFrame.photoCount;

    try {
      for (int i = 0; i < targetCount; i++) {
        final XFile? photo =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (photo != null) {
          pickedPhotos.add(photo);
        } else {
          break; // 사용자가 취소
        }
      }

      if (pickedPhotos.length == targetCount && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              selectedFrame: _selectedFrame,
              photos: pickedPhotos,
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

  // 프레임 모양 미리보기 위젯 (기존과 동일)
  Widget _buildFramePreview() {
    return Container(
      width: 180,
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _selectedFrame == FrameType.trio
            ? Colors.pink[100]
            : Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1), blurRadius: 10)
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
              itemBuilder: (_, __) =>
                  Container(color: Colors.grey.shade300),
            )
          : Column(
              children: List.generate(
                _selectedFrame.photoCount,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 앱바
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'pho\'s',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 프레임 미리보기
                _buildFramePreview(),

                const Spacer(),

                // 프레임 선택 카드 리스트
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: FrameType.values.map((frame) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7.5),
                      child: FrameOptionCard(
                        frameType: frame,
                        isSelected: _selectedFrame == frame,
                        onTap: () =>
                            setState(() => _selectedFrame = frame),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),

                // 촬영 버튼 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 갤러리 선택 버튼 (기존 유지)
                    GestureDetector(
                      onTap: _isShooting ? null : _pickFromGallery,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(Icons.photo_library,
                            color: AppColors.primary, size: 24),
                      ),
                    ),

                    const SizedBox(width: 32),

                    // 💡 [변경] 카메라 버튼 → 앱 내장 카메라 실행
                    GestureDetector(
                      onTap: _isShooting ? null : _launchInAppCamera,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 8,
                          ),
                        ),
                        child: _isShooting
                            ? const Padding(
                                padding: EdgeInsets.all(22),
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3),
                              )
                            : const Icon(Icons.camera_alt,
                                color: Colors.white, size: 30),
                      ),
                    ),

                    const SizedBox(width: 88), // 좌우 균형용
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// FrameOptionCard (기존과 동일, 다른 파일에서 import하므로 유지)
// ──────────────────────────────────────────────────────────
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
    final boxColor =
        frameType == FrameType.trio ? Colors.pink[100] : Colors.white;
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
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
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
              color: isSelected ? AppColors.primary : AppColors.textSub,
            ),
          ),
        ],
      ),
    );
  }
}
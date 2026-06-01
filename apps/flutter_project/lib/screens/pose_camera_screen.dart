// lib/screens/pose_camera_screen.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../core/constants.dart';
import 'cut_selection_screen.dart'; // 내 코드: CutSelectionScreen 연결

// ──────────────────────────────────────────────
// 폴더 구조
//   assets/poses/active/1_person/ ~ 4_person/  각 1.png~5.png
//   assets/poses/basic/1_person/  ~ 4_person/  각 1.png~5.png
//   assets/poses/couple/                        1.png~5.png
// ──────────────────────────────────────────────

enum PoseCategory {
  active('활동적', 'active', Icons.directions_run,          Color(0xFFFF6B6B), '역동적이고 활발한 포즈'),
  couple('연인',   'couple', Icons.favorite,                Color(0xFFFF9DC6), '다정하고 사랑스러운 포즈'),
  basic ('무난',   'basic',  Icons.sentiment_satisfied_alt, Color(0xFF74B9FF), '편안하고 자연스러운 포즈'),
  random('무작위', 'random', Icons.shuffle,                 Color(0xFF9D72FF), '모든 카테고리에서 랜덤 선택');

  final String label;
  final String folder;
  final IconData icon;
  final Color color;
  final String description;
  const PoseCategory(this.label, this.folder, this.icon, this.color, this.description);
}

class PoseCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FrameType selectedFrame;
  final String? overlayFrame; // 내 코드: 커스텀 프레임 경로 (없으면 null)

  const PoseCameraScreen({
    super.key,
    required this.cameras,
    required this.selectedFrame,
    this.overlayFrame,
  });

  @override
  State<PoseCameraScreen> createState() => _PoseCameraScreenState();
}

class _PoseCameraScreenState extends State<PoseCameraScreen>
    with TickerProviderStateMixin {

  // ── 카메라 ──────────────────────────────────
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;

  // ── 얼굴 인식 ────────────────────────────────
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
  );
  bool _isProcessing = false;
  int _detectedFaceCount = 0;

  // ── 포즈 추천 (동업자 코드) ───────────────────
  final Random _random = Random();
  static const int _imagesPerFolder = 5;

  PoseCategory? _selectedCategory;
  String?       _currentFolderPath;
  String?       _currentPoseImagePath;
  int           _currentImageIndex = -1;
  bool          _showPoseOverlay   = false;

  // ── 촬영 결과 ────────────────────────────────
  final List<XFile> _capturedPhotos = [];

  /// 내 코드: 여유분 2장 더 찍어 CutSelectionScreen에서 컷 선택
  static const int _extraShots = 2;
  int get _captureTarget => widget.selectedFrame.photoCount + _extraShots;

  // ── 애니메이션 (동업자 코드) ──────────────────
  late AnimationController _shutterAnim;
  late AnimationController _poseAnim;
  late Animation<double>   _poseScaleAnim;
  late Animation<double>   _poseFadeAnim;

  @override
  void initState() {
    super.initState();
    _shutterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.85, upperBound: 1.0,
    )..value = 1.0;

    _poseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _poseScaleAnim = CurvedAnimation(parent: _poseAnim, curve: Curves.easeOutBack);
    _poseFadeAnim  = CurvedAnimation(parent: _poseAnim, curve: Curves.easeIn);

    _initializeCamera();
  }

  // ── 카메라 초기화 ──────────────────────────────────────────────────────
  Future<void> _initializeCamera() async {
    final frontCamera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );
    _cameraController = CameraController(
      frontCamera, ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
    _cameraController.startImageStream(_processCameraImage);
  }

  // ── 얼굴 인식 ─────────────────────────────────────────────────────────
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || _isCapturing) return;
    _isProcessing = true;
    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;
      final faces = await _faceDetector.processImage(inputImage);
      final count = faces.length;
      if (mounted && count != _detectedFaceCount) {
        setState(() => _detectedFaceCount = count);
      }
    } catch (_) {
    } finally {
      _isProcessing = false;
    }
  }

  // ── 포즈 시트 열기 (동업자 코드) ─────────────────────────────────────
  void _openPoseSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PoseCategorySheet(onSelected: _applyCategory),
    );
  }

  // ── 카테고리 선택 → 포즈 표시 (동업자 코드) ──────────────────────────
  void _applyCategory(PoseCategory category) {
    Navigator.pop(context);

    PoseCategory actual = category;
    if (category == PoseCategory.random) {
      final pool = [PoseCategory.active, PoseCategory.couple, PoseCategory.basic];
      actual = pool[_random.nextInt(pool.length)];
    }

    final String folderPath;
    if (actual == PoseCategory.couple) {
      folderPath = 'assets/poses/couple';
    } else {
      final int personCount = _detectedFaceCount.clamp(1, 4);
      folderPath = 'assets/poses/${actual.folder}/${personCount}_person';
    }

    final int index = _random.nextInt(_imagesPerFolder) + 1;

    setState(() {
      _selectedCategory     = category;
      _currentFolderPath    = folderPath;
      _currentImageIndex    = index;
      _currentPoseImagePath = '$folderPath/$index.png';
      _showPoseOverlay      = true;
    });

    _poseAnim.reset();
    _poseAnim.forward();
  }

  // ── 포즈 변환 (동업자 코드) ───────────────────────────────────────────
  void _changeImage() {
    if (_currentFolderPath == null) return;
    int newIndex;
    do {
      newIndex = _random.nextInt(_imagesPerFolder) + 1;
    } while (newIndex == _currentImageIndex);

    _poseAnim.reset();
    setState(() {
      _currentImageIndex    = newIndex;
      _currentPoseImagePath = '$_currentFolderPath/$newIndex.png';
    });
    _poseAnim.forward();
  }

  // ── 셔터: 사진 촬영 ───────────────────────────────────────────────────
  Future<void> _capturePhoto() async {
    if (_isCapturing || !_isCameraInitialized) return;
    setState(() => _isCapturing = true);
    _shutterAnim.reverse().then((_) => _shutterAnim.forward());

    try {
      await _cameraController.stopImageStream();
      final photo = await _cameraController.takePicture();
      _capturedPhotos.add(photo);

      if (_capturedPhotos.length >= _captureTarget) {
        // 내 코드: 목표 장수 도달 → overlayFrame 포함해 CutSelectionScreen으로 이동
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CutSelectionScreen(
                selectedFrame: widget.selectedFrame,
                photos: _capturedPhotos,
                overlayFrame: widget.overlayFrame,
              ),
            ),
          );
        }
        return;
      }

      if (mounted && _cameraController.value.isInitialized) {
        setState(() {});
        await _cameraController.startImageStream(_processCameraImage);
      }
    } catch (e) {
      debugPrint('촬영 오류: $e');
      if (mounted &&
          _cameraController.value.isInitialized &&
          !_cameraController.value.isStreamingImages) {
        await _cameraController.startImageStream(_processCameraImage);
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _shutterAnim.dispose();
    _poseAnim.dispose();
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // ── BUILD ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final int total          = _captureTarget; // 내 코드: photoCount + 2
    final int taken          = _capturedPhotos.length;
    final bool showChangeBtn = _selectedCategory != null && _showPoseOverlay;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController),
          if (_showPoseOverlay && _currentPoseImagePath != null)
            _buildPoseOverlay(),
          SafeArea(child: _buildTopBar(taken, total)),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(child: _buildBottomBar(taken, total, showChangeBtn)),
          ),
        ],
      ),
    );
  }

  // ── 포즈 오버레이 (동업자 코드) ──────────────────────────────────────
  Widget _buildPoseOverlay() {
    return Positioned(
      top: 100, left: 0, right: 0,
      child: Center(
        child: FadeTransition(
          opacity: _poseFadeAnim,
          child: ScaleTransition(
            scale: _poseScaleAnim,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 190, height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 24, spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      _currentPoseImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black54,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                color: Colors.white54, size: 36),
                            SizedBox(height: 8),
                            Text('이미지 없음',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 닫기 버튼
                Positioned(
                  top: -8, right: -8,
                  child: GestureDetector(
                    onTap: () => setState(() => _showPoseOverlay = false),
                    child: Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ),
                // 카테고리 배지
                if (_selectedCategory != null)
                  Positioned(
                    bottom: -12, left: 0, right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _selectedCategory!.color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_selectedCategory!.icon,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              _selectedCategory == PoseCategory.couple
                                  ? _selectedCategory!.label
                                  : '${_selectedCategory!.label} · $_detectedFaceCount명',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 상단 바 ──────────────────────────────────────────────────────────
  Widget _buildTopBar(int taken, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _FaceBadge(count: _detectedFaceCount),
          _ProgressDots(taken: taken, total: total),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.black45, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ── 하단 바 ──────────────────────────────────────────────────────────
  Widget _buildBottomBar(int taken, int total, bool showChangeBtn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_capturedPhotos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  total,
                  (i) => i < taken
                      ? _CapturedThumb(path: _capturedPhotos[i].path)
                      : _EmptyThumb(index: i + 1),
                ),
              ),
            ),
          Text(
            '$taken / $total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 4),
          // 내 코드: 안내 텍스트
          Text(
            '여러 장 찍고 마음에 드는 ${widget.selectedFrame.photoCount}컷을 고르세요',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 변환 버튼 (동업자 코드)
              SizedBox(
                width: 90,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: showChangeBtn
                      ? _ChangeButton(
                          key: const ValueKey('change'),
                          onTap: _changeImage)
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ),
              const SizedBox(width: 16),

              // 셔터 버튼
              ScaleTransition(
                scale: _shutterAnim,
                child: GestureDetector(
                  onTap: _isCapturing ? null : _capturePhoto,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isCapturing ? Colors.white38 : Colors.white,
                      border: Border.all(color: AppColors.primary, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.45),
                          blurRadius: 18, spreadRadius: 2,
                        )
                      ],
                    ),
                    child: _isCapturing
                        ? const Padding(
                            padding: EdgeInsets.all(22),
                            child: CircularProgressIndicator(
                                color: AppColors.primary, strokeWidth: 3),
                          )
                        : const Icon(Icons.camera_alt,
                            color: AppColors.primary, size: 34),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 포즈 추천 버튼 (동업자 코드)
              SizedBox(
                width: 90,
                child: _PoseButton(
                  isActive: _selectedCategory != null && _showPoseOverlay,
                  category: _selectedCategory,
                  onTap: _openPoseSheet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── ML Kit 입력 이미지 변환 ────────────────────────────────────────────
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    } else if (Platform.isAndroid) {
      rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    if (Platform.isAndroid && format != InputImageFormat.nv21) return null;
    if (Platform.isIOS && format != InputImageFormat.bgra8888) return null;
    if (image.planes.isEmpty) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 포즈 카테고리 선택 바텀시트 (동업자 코드)
// ══════════════════════════════════════════════════════════════
class _PoseCategorySheet extends StatelessWidget {
  final void Function(PoseCategory) onSelected;
  const _PoseCategorySheet({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 22),
          const Text('어떤 포즈로 찍을까요?',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('카테고리를 선택하면 인원수에 맞는 포즈를 추천해드려요',
              style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 22),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
            children: PoseCategory.values
                .map((c) =>
                    _CategoryCard(category: c, onTap: () => onSelected(c)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final PoseCategory category;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: category.color.withOpacity(0.35), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: category.color.withOpacity(0.18),
                  shape: BoxShape.circle),
              child: Icon(category.icon, color: category.color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(category.description,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 서브 위젯
// ══════════════════════════════════════════════════════════════

class _ChangeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ChangeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white60),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text('변환',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _PoseButton extends StatelessWidget {
  final bool isActive;
  final PoseCategory? category;
  final VoidCallback onTap;
  const _PoseButton(
      {required this.isActive,
      required this.category,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isActive && category != null
        ? category!.color
        : Colors.white.withOpacity(0.18);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: isActive ? Colors.transparent : Colors.white60),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1)
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive && category != null
                  ? category!.icon
                  : Icons.style_rounded,
              color: Colors.white,
              size: 15,
            ),
            const SizedBox(width: 5),
            const Text('포즈',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _FaceBadge extends StatelessWidget {
  final int count;
  const _FaceBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.face, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(
            count == 0 ? '인식 중...' : '$count명 인식',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int taken;
  final int total;
  const _ProgressDots({required this.taken, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final filled = i < taken;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: filled ? 22 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: filled ? AppColors.primary : Colors.white38,
          ),
        );
      }),
    );
  }
}

class _CapturedThumb extends StatelessWidget {
  final String path;
  const _CapturedThumb({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(File(path), fit: BoxFit.cover),
      ),
    );
  }
}

class _EmptyThumb extends StatelessWidget {
  final int index;
  const _EmptyThumb({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30, width: 2),
        color: Colors.white12,
      ),
      child: Center(
        child: Text(
          '$index',
          style: const TextStyle(
              color: Colors.white38,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

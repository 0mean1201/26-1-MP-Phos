// lib/screens/pose_camera_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../core/constants.dart';
import 'cut_selection_screen.dart';

class PoseCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FrameType selectedFrame;
  final String? overlayFrame; // 커스텀 프레임 경로 (없으면 null)

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
  late CameraController _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableLandmarks: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isCapturing = false;

  // 얼굴 인식 상태
  int _detectedFaceCount = 0;
  bool _showPoseImage = false;
  String _currentPoseImagePath = '';
  Timer? _hideImageTimer;

  // 촬영 결과 누적 (CutSelectionScreen에 전달)
  final List<XFile> _capturedPhotos = [];

  /// 프레임 필요 장수보다 여유분을 더 찍어 컷 선택의 여지를 둔다.
  static const int _extraShots = 2;
  int get _captureTarget => widget.selectedFrame.photoCount + _extraShots;

  // 셔터 버튼 애니메이션 컨트롤러
  late AnimationController _shutterAnimController;

  @override
  void initState() {
    super.initState();
    _shutterAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.85,
      upperBound: 1.0,
    )..value = 1.0;
    _initializeCamera();
  }

  // ── 카메라 초기화 ──────────────────────────────────────────────────────
  Future<void> _initializeCamera() async {
    final frontCamera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
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

  // ── 실시간 얼굴 감지 ───────────────────────────────────────────────────
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || _isCapturing) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final List<Face> faces = await _faceDetector.processImage(inputImage);
      final int count = faces.length;

      if (!mounted) return;

      if (count > 0 && count != _detectedFaceCount) {
        setState(() => _detectedFaceCount = count);
        _triggerPoseRecommendation(count);
      } else if (count == 0 && _detectedFaceCount != 0) {
        setState(() => _detectedFaceCount = 0);
      }
    } catch (e) {
      debugPrint('얼굴 인식 오류: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // ── 포즈 추천 이미지 오버레이 ─────────────────────────────────────────
  void _triggerPoseRecommendation(int count) {
    final int clamped = count.clamp(1, 4);
    setState(() {
      _currentPoseImagePath = 'assets/poses/${clamped}_person.png';
      _showPoseImage = true;
    });

    _hideImageTimer?.cancel();
    _hideImageTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showPoseImage = false);
    });
  }

  // ── 셔터: 사진 한 장 촬영 ─────────────────────────────────────────────
  Future<void> _capturePhoto() async {
    if (_isCapturing || !_isCameraInitialized) return;

    setState(() => _isCapturing = true);
    _shutterAnimController.reverse().then((_) => _shutterAnimController.forward());

    try {
      await _cameraController.stopImageStream();
      final XFile photo = await _cameraController.takePicture();
      _capturedPhotos.add(photo);

      if (_capturedPhotos.length >= _captureTarget) {
        // 목표 장수 도달 → overlayFrame 포함해 CutSelectionScreen으로 이동
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CutSelectionScreen(
                selectedFrame: widget.selectedFrame,
                photos: _capturedPhotos,
                overlayFrame: widget.overlayFrame, // ← 커스텀 프레임 전달
              ),
            ),
          );
        }
        return;
      }

      // 아직 더 찍어야 하면 스트림 재시작
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
    _hideImageTimer?.cancel();
    _shutterAnimController.dispose();
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final int totalCount = _captureTarget;
    final int takenCount = _capturedPhotos.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 카메라 프리뷰
          CameraPreview(_cameraController),

          // 2. 포즈 추천 오버레이
          AnimatedOpacity(
            opacity: _showPoseImage ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: IgnorePointer(
              child: Align(
                alignment: const Alignment(0, -0.15),
                child: Container(
                  width: 230,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.55),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _showPoseImage
                        ? Image.asset(
                            _currentPoseImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.black54,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.emoji_people,
                                      color: Colors.white70, size: 56),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$_detectedFaceCount인 포즈',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),

          // 3. 상단 바 (얼굴 수 + 진행 도트 + 닫기)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FaceBadge(count: _detectedFaceCount),
                  _ProgressDots(taken: takenCount, total: totalCount),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. 하단 (썸네일 + 카운트 + 안내 + 셔터)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_capturedPhotos.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(totalCount, (i) {
                            if (i < _capturedPhotos.length) {
                              return _CapturedThumb(
                                  path: _capturedPhotos[i].path);
                            }
                            return _EmptyThumb(index: i + 1);
                          }),
                        ),
                      ),

                    Text(
                      '$takenCount / $totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '여러 장 찍고 마음에 드는 ${widget.selectedFrame.photoCount}컷을 고르세요',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 20),

                    ScaleTransition(
                      scale: _shutterAnimController,
                      child: GestureDetector(
                        onTap: _isCapturing ? null : _capturePhoto,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isCapturing ? Colors.white38 : Colors.white,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _isCapturing
                              ? const Padding(
                                  padding: EdgeInsets.all(22),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.camera_alt,
                                  color: AppColors.primary, size: 34),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

// ── 서브 위젯 ─────────────────────────────────────────────────────────────

class _FaceBadge extends StatelessWidget {
  final int count;
  const _FaceBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.face, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            count == 0 ? '인식 중...' : '$count명 인식',
            style: const TextStyle(color: Colors.white, fontSize: 13),
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
      width: 52,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
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
      width: 52,
      height: 52,
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

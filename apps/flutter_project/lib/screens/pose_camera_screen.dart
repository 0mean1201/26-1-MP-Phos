// lib/screens/pose_camera_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../core/constants.dart';
import 'result_screen.dart';

class PoseCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FrameType selectedFrame; // 💡 어떤 프레임인지 알아야 몇 장 찍을지 결정
  final String? overlayFrame; // 💡 선택된 프레임의 오버레이 이미지 경로 (선택 사항)

  const PoseCameraScreen({
    super.key,
    required this.cameras,
    required this.selectedFrame,
    this.overlayFrame, // 💡 선택된 프레임의 오버레이 이미지 경로 (선택 사항)
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
  bool _isProcessing = false; // 얼굴 인식 처리 중 중복 방지
  bool _isCapturing = false;  // 셔터 누름 중복 방지

  // 얼굴 인식 상태
  int _detectedFaceCount = 0;
  bool _showPoseImage = false;
  String _currentPoseImagePath = '';
  Timer? _hideImageTimer;

  // 💡 촬영 결과 누적 리스트 (ResultScreen에 전달)
  final List<XFile> _capturedPhotos = [];

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

  // ──────────────────────────────────────────────
  // 카메라 초기화
  // ──────────────────────────────────────────────
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

    // 실시간 얼굴 인식 스트림 시작
    _cameraController.startImageStream(_processCameraImage);
  }

  // ──────────────────────────────────────────────
  // 실시간 얼굴 감지 (스트림 프레임마다 호출)
  // ──────────────────────────────────────────────
  Future<void> _processCameraImage(CameraImage image) async {
    // 촬영 중이거나 이미 분석 중이면 건너뜀
    if (_isProcessing || _isCapturing) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final List<Face> faces = await _faceDetector.processImage(inputImage);
      final int count = faces.length;

      if (!mounted) return;

      if (count > 0 && count != _detectedFaceCount) {
        // 인원수가 바뀌었을 때만 포즈 추천 갱신
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

  // ──────────────────────────────────────────────
  // 포즈 추천 이미지 오버레이 트리거
  // ──────────────────────────────────────────────
  void _triggerPoseRecommendation(int count) {
    final int clamped = count.clamp(1, 4); // 최대 4인 포즈까지만 준비
    setState(() {
      _currentPoseImagePath = 'assets/poses/${clamped}_person.png';
      _showPoseImage = true;
    });

    _hideImageTimer?.cancel();
    // 💡 3초 뒤 포즈 이미지 사라짐
    _hideImageTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showPoseImage = false);
    });
  }

  // ──────────────────────────────────────────────
  // 셔터: 사진 한 장 촬영
  // ──────────────────────────────────────────────
  Future<void> _capturePhoto() async {
    if (_isCapturing || !_isCameraInitialized) return;

    setState(() => _isCapturing = true);

    // 셔터 버튼 눌림 애니메이션
    _shutterAnimController.reverse().then((_) => _shutterAnimController.forward());

    try {
      // 얼굴 인식 스트림을 잠시 멈추고 촬영 (동시 사용 불가)
      await _cameraController.stopImageStream();
      final XFile photo = await _cameraController.takePicture();

      _capturedPhotos.add(photo);

      final int needed = widget.selectedFrame.photoCount;

      if (_capturedPhotos.length >= needed) {
        // 💡 필요한 장수를 다 찍었으면 ResultScreen으로 이동
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                selectedFrame: widget.selectedFrame,
                photos: _capturedPhotos,
                overlayFrame: widget.overlayFrame, // 💡 프레임 선택 시 오버레이 이미지 전달
              ),
            ),
          );
        }
        return; // dispose에서 정리하므로 스트림 재시작 불필요
      }

      // 아직 더 찍어야 하면 스트림 재시작
      if (mounted && _cameraController.value.isInitialized) {
        setState(() {}); // 썸네일 갱신
        await _cameraController.startImageStream(_processCameraImage);
      }
    } catch (e) {
      debugPrint('촬영 오류: $e');
      // 오류 시 스트림 복구 시도
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

  // ──────────────────────────────────────────────
  // UI
  // ──────────────────────────────────────────────
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

    final int totalCount = widget.selectedFrame.photoCount;
    final int takenCount = _capturedPhotos.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. 카메라 프리뷰 ──────────────────────────
          CameraPreview(_cameraController),

          // ── 2. 포즈 추천 오버레이 (fade in/out) ───────
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
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _showPoseImage
                        ? Image.asset(
                            _currentPoseImagePath,
                            fit: BoxFit.cover,
                            // 💡 해당 에셋이 없을 때 폴백 UI
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

          // ── 3. 상단 바 (얼굴 수 + 진행 도트 + 닫기) ──
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 얼굴 인식 배지
                  _FaceBadge(count: _detectedFaceCount),

                  // 촬영 진행 도트
                  _ProgressDots(taken: takenCount, total: totalCount),

                  // 닫기
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
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

          // ── 4. 하단 (촬영 썸네일 + 카운트 + 셔터) ────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 찍은 사진 썸네일 미니 리스트
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

                    // "n / total" 텍스트
                    Text(
                      '$takenCount / $totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 셔터 버튼
                    ScaleTransition(
                      scale: _shutterAnimController,
                      child: GestureDetector(
                        onTap: _isCapturing ? null : _capturePhoto,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isCapturing
                                ? Colors.white38
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              )
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

  // ──────────────────────────────────────────────
  // ML Kit 입력 이미지 변환 유틸리티
  // ──────────────────────────────────────────────
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(
          camera.sensorOrientation);
    } else if (Platform.isAndroid) {
      rotation = InputImageRotationValue.fromRawValue(
          camera.sensorOrientation);
    }
    if (rotation == null) return null;

    final format =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    if (Platform.isAndroid && format != InputImageFormat.nv21) {
      return null;
    }
    if (Platform.isIOS && format != InputImageFormat.bgra8888) {
      return null;
    }
    if (image.planes.isEmpty) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(
            image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// 서브 위젯들 (파일 분리 없이 같은 파일에 두는 게 편합니다)
// ──────────────────────────────────────────────────────────

/// 얼굴 인식 배지
class _FaceBadge extends StatelessWidget {
  final int count;
  const _FaceBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
            style:
                const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// 촬영 진행 도트 인디케이터
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
            color:
                filled ? AppColors.primary : Colors.white38,
          ),
        );
      }),
    );
  }
}

/// 촬영된 사진 썸네일
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
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(File(path), fit: BoxFit.cover),
      ),
    );
  }
}

/// 빈 슬롯 (아직 안 찍은 자리)
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
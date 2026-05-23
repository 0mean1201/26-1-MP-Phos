import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart'; // XFile 타입 사용

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int photoCount; // FrameSelectionScreen에서 몇 장 찍을지 받음

  const CameraScreen({
    super.key,
    required this.cameras,
    required this.photoCount,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late FaceDetector _faceDetector;

  int _faceCount = 0;
  bool _isProcessing = false;

  String? _poseImagePath;
  bool _showPoseOverlay = false;
  Timer? _overlayTimer;
  int _lastShownFaceCount = 0;
  int _overlayFaceCount = 0;

  // 촬영된 사진 누적
  final List<XFile> _takenPhotos = [];

  final Map<int, List<String>> _poseImages = {
    1: ['assets/poses/1person/pose1.png', 'assets/poses/1person/pose2.png'],
    2: ['assets/poses/2person/pose1.png', 'assets/poses/2person/pose2.png'],
    3: ['assets/poses/3person/pose1.png', 'assets/poses/3person/pose2.png'],
    4: ['assets/poses/4person/pose1.png', 'assets/poses/4person/pose2.png'],
  };

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    final frontCamera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller.initialize();
    await _controller.startImageStream(_processFrame);
    if (mounted) setState(() {});
  }

  Future<void> _processFrame(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _toInputImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector.processImage(inputImage);
      final count = faces.length;

      if (!mounted) return;

      if (count != _faceCount) {
        setState(() => _faceCount = count);

        if (count > 0 && count != _lastShownFaceCount) {
          _triggerPoseOverlay(count);
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final rotation = InputImageRotationValue.fromRawValue(
      _controller.description.sensorOrientation,
    );
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void _triggerPoseOverlay(int count) {
    final key = count.clamp(1, 4);
    final poses = _poseImages[key];
    if (poses == null || poses.isEmpty) return;
    if (_showPoseOverlay) return;

    final selectedPose = poses[Random().nextInt(poses.length)];

    _overlayTimer?.cancel();
    setState(() {
      _poseImagePath = selectedPose;
      _showPoseOverlay = true;
      _lastShownFaceCount = count;
      _overlayFaceCount = count;
    });

    _overlayTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showPoseOverlay = false;
          _lastShownFaceCount = 0;
        });
      }
    });
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) return;

    try {
      await _controller.stopImageStream();
      final file = await _controller.takePicture();
      _takenPhotos.add(XFile(file.path));

      // 목표 매수 완료 → 사진 리스트를 FrameSelectionScreen으로 반환
      if (_takenPhotos.length == widget.photoCount) {
        if (mounted) Navigator.pop(context, _takenPhotos);
        return;
      }

      // 아직 남았으면 스트림 재개
      await _controller.startImageStream(_processFrame);
      setState(() {});
    } catch (e) {
      debugPrint('촬영 오류: $e');
      await _controller.startImageStream(_processFrame);
    }
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _controller.stopImageStream();
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ① 카메라 프리뷰
          Positioned.fill(child: CameraPreview(_controller)),

          // ② 상단: 얼굴 수 + 진행상황
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 8),
                _buildFaceCountBadge(),
              ],
            ),
          ),

          // ③ 포즈 추천 오버레이
          if (_poseImagePath != null)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: _buildPoseOverlay(),
            ),

          // ④ 촬영 버튼
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(child: _buildCaptureButton()),
          ),
        ],
      ),
    );
  }

  // 몇 장 찍었는지 표시 (● ● ○ ○)
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.photoCount, (i) {
        final done = i < _takenPhotos.length;
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? Colors.white : Colors.white38,
          ),
        );
      }),
    );
  }

  Widget _buildFaceCountBadge() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_faceCount),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          _faceCount == 0 ? '얼굴을 인식 중...' : '👥 $_faceCount명 인식됨',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPoseOverlay() {
    return AnimatedOpacity(
      opacity: _showPoseOverlay ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Colors.pink.withValues(alpha: 0.85),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '📸 $_overlayFaceCount인 추천 포즈!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Image.asset(
                _poseImagePath!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: Colors.white30,
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
      ),
    );
  }
}

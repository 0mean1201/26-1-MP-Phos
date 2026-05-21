import 'dart:math';
import 'dart:typed_data';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceRecognitionService {
  static final FaceRecognitionService _instance = FaceRecognitionService._internal();
  factory FaceRecognitionService() => _instance;
  FaceRecognitionService._internal();

  Interpreter? _interpreter;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableLandmarks: true,
    ),
  );

  static const String _modelPath = 'assets/ml/facenet_512.tflite';
  static const int _inputSize = 160;
  static const int _outputSize = 512;

  // FaceNet 160×160 기준 눈 위치 (좌우 대칭, 상단 40% 지점)
  static const double _refLeftEyeX = 55.0, _refLeftEyeY = 65.0;
  static const double _refRightEyeX = 105.0, _refRightEyeY = 65.0;

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
    } catch (e) {
      print('🚨 모델 로딩 실패: $e');
    }
  }

  Future<List<List<double>>> getEmbeddings(XFile imageFile) async {
    if (_interpreter == null) return [];

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) return [];

      final bytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return [];
      originalImage = img.bakeOrientation(originalImage);

      final List<List<double>> allEmbeddings = [];

      for (final face in faces) {
        // affine warp로 눈 위치를 기준점에 고정, 출력이 이미 160×160
        final warped = _warpFace(originalImage, face);
        final preprocessed = _preprocessImage(warped);

        final input = preprocessed.reshape([1, _inputSize, _inputSize, 3]);
        final output = List.filled(_outputSize, 0.0).reshape([1, _outputSize]);
        _interpreter!.run(input, output);

        allEmbeddings.add(_l2Normalize(List<double>.from(output[0])));
      }
      return allEmbeddings;
    } catch (e) {
      print('🚨 얼굴 특징 추출 중 오류: $e');
      return [];
    }
  }

  /// Similarity transform (복소수 나눗셈):
  /// 원본 이미지의 눈 좌표를 출력 160×160의 기준 좌표에 정확히 맞춰 warp.
  /// 중간 회전 이미지를 만들지 않으므로 보간 오류가 적고 정확도가 높다.
  img.Image _warpFace(img.Image src, Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    if (leftEye == null || rightEye == null) {
      return img.copyResize(_paddedCrop(src, face),
          width: _inputSize, height: _inputSize);
    }

    final lx = leftEye.position.x.toDouble();
    final ly = leftEye.position.y.toDouble();
    final rx = rightEye.position.x.toDouble();
    final ry = rightEye.position.y.toDouble();

    // a = (dst_right - dst_left) / (src_right - src_left)  (복소수)
    final srcDx = rx - lx;
    final srcDy = ry - ly;
    final dstDx = _refRightEyeX - _refLeftEyeX; // 50.0
    final dstDy = _refRightEyeY - _refLeftEyeY; // 0.0

    final denom = srcDx * srcDx + srcDy * srcDy;
    if (denom < 1.0) {
      return img.copyResize(_paddedCrop(src, face),
          width: _inputSize, height: _inputSize);
    }

    final aR = (dstDx * srcDx + dstDy * srcDy) / denom;
    final aI = (dstDy * srcDx - dstDx * srcDy) / denom;
    final bR = _refLeftEyeX - (aR * lx - aI * ly);
    final bI = _refLeftEyeY - (aI * lx + aR * ly);

    // 역변환 계수 (output pixel → input pixel)
    final det = aR * aR + aI * aI;
    final invAR = aR / det;
    final invAI = aI / det;

    final output = img.Image(width: _inputSize, height: _inputSize);

    for (int oy = 0; oy < _inputSize; oy++) {
      for (int ox = 0; ox < _inputSize; ox++) {
        final oxB = ox - bR;
        final oyB = oy - bI;

        final ix = invAR * oxB + invAI * oyB;
        final iy = invAR * oyB - invAI * oxB;

        final x0 = ix.floor();
        final y0 = iy.floor();

        // 범위 밖이면 회색으로 채움 (정규화 후 0.0이 됨)
        if (x0 < 0 || y0 < 0 || x0 + 1 >= src.width || y0 + 1 >= src.height) {
          output.setPixelRgb(ox, oy, 128, 128, 128);
          continue;
        }

        // 쌍선형 보간
        final fx = ix - x0;
        final fy = iy - y0;
        final p00 = src.getPixel(x0, y0);
        final p10 = src.getPixel(x0 + 1, y0);
        final p01 = src.getPixel(x0, y0 + 1);
        final p11 = src.getPixel(x0 + 1, y0 + 1);

        final r = (1 - fx) * (1 - fy) * p00.r + fx * (1 - fy) * p10.r +
            (1 - fx) * fy * p01.r + fx * fy * p11.r;
        final g = (1 - fx) * (1 - fy) * p00.g + fx * (1 - fy) * p10.g +
            (1 - fx) * fy * p01.g + fx * fy * p11.g;
        final b = (1 - fx) * (1 - fy) * p00.b + fx * (1 - fy) * p10.b +
            (1 - fx) * fy * p01.b + fx * fy * p11.b;

        output.setPixelRgb(
          ox, oy,
          r.round().clamp(0, 255),
          g.round().clamp(0, 255),
          b.round().clamp(0, 255),
        );
      }
    }

    return output;
  }

  img.Image _paddedCrop(img.Image image, Face face) {
    final rect = face.boundingBox;
    final padW = (rect.width * 0.3).toInt();
    final padH = (rect.height * 0.3).toInt();
    final x = (rect.left.toInt() - padW).clamp(0, image.width - 1);
    final y = (rect.top.toInt() - padH).clamp(0, image.height - 1);
    final w = (rect.width.toInt() + padW * 2).clamp(1, image.width - x);
    final h = (rect.height.toInt() + padH * 2).clamp(1, image.height - y);
    return img.copyCrop(image, x: x, y: y, width: w, height: h);
  }

  List<double> _l2Normalize(List<double> embedding) {
    final norm = sqrt(embedding.fold(0.0, (sum, e) => sum + e * e));
    if (norm == 0) return embedding;
    return embedding.map((e) => e / norm).toList();
  }

  Float32List _preprocessImage(img.Image image) {
    final buffer = Float32List(_inputSize * _inputSize * 3);
    int idx = 0;
    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final pixel = image.getPixel(x, y);
        buffer[idx++] = (pixel.r - 127.5) / 127.5;
        buffer[idx++] = (pixel.g - 127.5) / 127.5;
        buffer[idx++] = (pixel.b - 127.5) / 127.5;
      }
    }
    return buffer;
  }

  void dispose() {
    _faceDetector.close();
    _interpreter?.close();
  }
}

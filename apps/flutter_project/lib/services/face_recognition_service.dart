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
      enableLandmarks: true, // 눈 좌표로 얼굴 정렬
    ),
  );

  static const String _modelPath = 'assets/ml/facenet_512.tflite';
  static const int _inputSize = 160;
  static const int _outputSize = 512;

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
        final cropped = _cropAligned(originalImage, face);
        final resized = img.copyResize(cropped, width: _inputSize, height: _inputSize);
        final preprocessed = _preprocessImage(resized);

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

  /// 눈 랜드마크로 얼굴을 수평 정렬한 후 크롭.
  /// 랜드마크가 없으면 패딩 크롭으로 폴백.
  img.Image _cropAligned(img.Image image, Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    if (leftEye != null && rightEye != null) {
      final lx = leftEye.position.x.toDouble();
      final ly = leftEye.position.y.toDouble();
      final rx = rightEye.position.x.toDouble();
      final ry = rightEye.position.y.toDouble();

      // 눈 기울기 각도 계산
      final angle = atan2(ry - ly, rx - lx) * 180 / pi;

      // 이미지 중심 기준으로 회전
      final imgCx = image.width / 2.0;
      final imgCy = image.height / 2.0;
      final rotated = img.copyRotate(image, angle: -angle);

      // 회전 후 눈 중심 좌표 재계산
      final rad = -angle * pi / 180;
      final eyeCx = (lx + rx) / 2;
      final eyeCy = (ly + ry) / 2;
      final newEyeCx = cos(rad) * (eyeCx - imgCx) - sin(rad) * (eyeCy - imgCy) + imgCx;
      final newEyeCy = sin(rad) * (eyeCx - imgCx) + cos(rad) * (eyeCy - imgCy) + imgCy;

      // 눈 간격으로 얼굴 크기 추정 (눈 간격의 3.5배)
      final eyeDist = sqrt(pow(rx - lx, 2) + pow(ry - ly, 2));
      final halfSize = (eyeDist * 1.8).toInt();

      // 얼굴 중심 = 눈 중심보다 약간 아래
      final faceCy = newEyeCy + eyeDist * 0.3;

      final x = (newEyeCx - halfSize).toInt().clamp(0, rotated.width - 1);
      final y = (faceCy - halfSize).toInt().clamp(0, rotated.height - 1);
      final size = (halfSize * 2).clamp(1, min(rotated.width - x, rotated.height - y).toInt());

      return img.copyCrop(rotated, x: x, y: y, width: size, height: size);
    }

    // 랜드마크 없을 때 폴백: 30% 패딩 크롭
    return _paddedCrop(image, face);
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
        if (x < image.width && y < image.height) {
          final pixel = image.getPixel(x, y);
          buffer[idx++] = (pixel.r - 127.5) / 127.5;
          buffer[idx++] = (pixel.g - 127.5) / 127.5;
          buffer[idx++] = (pixel.b - 127.5) / 127.5;
        } else {
          buffer[idx++] = 0.0;
          buffer[idx++] = 0.0;
          buffer[idx++] = 0.0;
        }
      }
    }
    return buffer;
  }

  void dispose() {
    _faceDetector.close();
    _interpreter?.close();
  }
}

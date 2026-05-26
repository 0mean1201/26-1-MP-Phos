import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants.dart';
import '../services/face_recognition_service.dart';
import '../services/grouping_service.dart';
import '../services/photo_storage_service.dart';
import '../services/sync_service.dart';

class ResultScreen extends StatefulWidget {
  final FrameType selectedFrame;
  final List<XFile> photos;
  final String? overlayFrame; // ← 추가: FrameSelectionScreen에서 직접 전달받음

  const ResultScreen({
    super.key,
    required this.selectedFrame,
    required this.photos,
    this.overlayFrame, // nullable: 선택 안 하면 null
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveResultImage() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();

      // 캡처 전 한 프레임 대기 → asset 이미지가 완전히 렌더된 후 캡처
      await Future.delayed(const Duration(milliseconds: 300));

      // 1. 위젯 캡처 → 임시 파일 생성
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'phos_${widget.selectedFrame.name}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('${appDir.path}/$fileName').create();
      await file.writeAsBytes(pngBytes);

      // 2. 갤러리에 저장
      await Gal.putImage(file.path);

      // 3. 각 원본 사진에서 얼굴 임베딩 추출
      final allEmbeddings = <List<double>>[];
      for (final photo in widget.photos) {
        final embeddings = await FaceRecognitionService().getEmbeddings(photo);
        allEmbeddings.addAll(embeddings);
      }

      // 4. 클라이언트 사이드 그루핑
      final groupingResult = await GroupingService().assignGroups(allEmbeddings);

      // 5. 로컬 저장
      final localPhoto = LocalPhoto(
        path: file.path,
        frameType: widget.selectedFrame.name,
        title: 'Untitled',
        tag: 'my_moment',
        date: DateTime.now().toIso8601String(),
        groupIds: groupingResult.groupIds,
        pendingUpload: allEmbeddings.isNotEmpty,
        pendingVectors: allEmbeddings.isNotEmpty ? groupingResult.vectors : null,
      );
      await PhotoStorageService().addPhoto(localPhoto);

      // 6. 백그라운드 서버 업로드 시도
      if (allEmbeddings.isNotEmpty) {
        SyncService().enqueuePendingPhotos();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리에 저장되었습니다!')),
        );
      }
    } catch (e) {
      debugPrint('저장 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Result', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: _buildRenderedStrip(),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveResultImage,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.download),
                    label: Text(_isSaving ? '저장 중...' : 'Save to Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRenderedStrip() {
    if (widget.overlayFrame != null) {
      return _buildCustomFrameStrip();
    }
    return _buildDefaultStrip();
  }

  /// 기본 프레임 (오버레이 없음) ─ 기존 로직 그대로
  Widget _buildDefaultStrip() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.selectedFrame == FrameType.trio
            ? Colors.pink[100]
            : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectedFrame == FrameType.square)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.photos.length,
              itemBuilder: (context, index) => Image.file(
                File(widget.photos[index].path),
                fit: BoxFit.cover,
              ),
            )
          else
            Column(
              children: widget.photos
                  .map((photo) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Image.file(File(photo.path), fit: BoxFit.cover),
                        ),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 10),
          const Text(
            "pho's",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            DateTime.now().toString().substring(0, 10),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 파일명별 슬롯 좌표 맵 (픽셀 분석으로 자동 추출한 비율값)
  /// 각 항목: [left, top, right, bottom] 비율 (0.0 ~ 1.0)
  static const Map<String, List<List<double>>> _frameSlots = {
    // 1x3 베이지 프레임 (1080x1920)
    '1.png': [
      [0.1481, 0.0927, 0.8426, 0.3146],
      [0.1519, 0.3573, 0.8463, 0.5792],
      [0.1519, 0.6240, 0.8463, 0.8453],
    ],
    // 1x3 파랑 프레임 (1080x1920)
    '2.png': [
      [0.1491, 0.0938, 0.8407, 0.3135],
      [0.1537, 0.3578, 0.8444, 0.5781],
      [0.1537, 0.6245, 0.8444, 0.8448],
    ],
    // 1x3 학교 프레임 (1080x1920)
    '3.png': [
      [0.1481, 0.0932, 0.8426, 0.3146],
      [0.1528, 0.3573, 0.8454, 0.5786],
      [0.1528, 0.6240, 0.8463, 0.8453],
    ],
    // 2x2 빅변내컷 프레임 (891x1260)
    '4.png': [
      [0.0662, 0.0468, 0.4770, 0.4421],
      [0.5208, 0.0468, 0.9327, 0.4421],
      [0.0662, 0.4825, 0.4770, 0.8770],
      [0.5208, 0.4825, 0.9304, 0.8770],
    ],
  };

  /// 파일명별 원본 종횡비 (height / width)
  static const Map<String, double> _frameAspectRatio = {
    '1.png': 1920 / 1080,
    '2.png': 1920 / 1080,
    '3.png': 1920 / 1080,
    '4.png': 1260 / 891,
  };

  /// 커스텀 프레임 ─ 프레임 이미지 위에 사진을 정확한 좌표에 배치
  Widget _buildCustomFrameStrip() {
    final fileName = widget.overlayFrame!.split('/').last;
    final slots = _frameSlots[fileName];

    // 등록된 슬롯 정보가 없으면 단순 오버레이로 폴백
    if (slots == null) {
      return _buildDefaultStrip();
    }

    const double frameW = 300.0;
    final double aspectRatio = _frameAspectRatio[fileName] ?? (1920 / 1080);
    final double frameH = frameW * aspectRatio;

    // 사진 수에 맞게 슬롯 수 조정 (사진이 슬롯보다 적으면 앞에서부터 채움)
    final usedSlots = slots.take(widget.photos.length).toList();

    return SizedBox(
      width: frameW,
      height: frameH,
      child: Stack(
        children: [
          // 1) 각 슬롯에 사진 배치 (프레임 아래 레이어)
          for (int i = 0; i < usedSlots.length; i++)
            Positioned(
              left:   frameW * usedSlots[i][0],
              top:    frameH * usedSlots[i][1],
              width:  frameW * (usedSlots[i][2] - usedSlots[i][0]),
              height: frameH * (usedSlots[i][3] - usedSlots[i][1]),
              child: Image.file(
                File(widget.photos[i].path),
                fit: BoxFit.cover,
              ),
            ),

          // 2) 커스텀 프레임 이미지 (사진 위 레이어 → 프레임 장식이 사진을 자연스럽게 덮음)
          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset(
                widget.overlayFrame!,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

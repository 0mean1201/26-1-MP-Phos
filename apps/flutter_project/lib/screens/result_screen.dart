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

  const ResultScreen({super.key, required this.selectedFrame, required this.photos});

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

      // 3. 얼굴 임베딩 추출
      final allEmbeddings = <List<double>>[];
      for (final photo in widget.photos) {
        final embeddings = await FaceRecognitionService().getEmbeddings(photo);
        allEmbeddings.addAll(embeddings);
      }

      // 4. 그루핑
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

      // 6. 서버 업로드 시도
      if (allEmbeddings.isNotEmpty) SyncService().enqueuePendingPhotos();

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.bg(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);
    final surfaceColor = AppColors.surface(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
        title: Text('Result', style: TextStyle(color: textMain, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 프레임 렌더링 (저장용이므로 항상 흰 배경 유지)
              RepaintBoundary(
                key: _globalKey,
                child: _buildRenderedStrip(),
              ),
              const SizedBox(height: 40),

              // 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveResultImage,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.download),
                    label: Text(_isSaving ? '저장 중...' : 'Save to Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: Icon(Icons.home, color: primaryColor),
                    label: Text('Go Home', style: TextStyle(color: primaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 저장되는 이미지는 항상 흰 배경 유지 (인화지 느낌)
  Widget _buildRenderedStrip() {
    final isTrioFrame = widget.selectedFrame == FrameType.trio;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isTrioFrame ? Colors.pink[100] : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectedFrame == FrameType.square)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: widget.photos.length,
              itemBuilder: (context, index) =>
                  Image.file(File(widget.photos[index].path), fit: BoxFit.cover),
            )
          else
            Column(
              children: widget.photos.map((photo) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Image.file(File(photo.path), fit: BoxFit.cover),
                ),
              )).toList(),
            ),
          const SizedBox(height: 10),
          const Text("pho's",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(
            DateTime.now().toString().substring(0, 10),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
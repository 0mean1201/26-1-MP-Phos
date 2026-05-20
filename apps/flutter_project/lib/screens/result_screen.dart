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

      // 3. 각 원본 사진에서 얼굴 임베딩 추출
      final allEmbeddings = <List<double>>[];
      for (final photo in widget.photos) {
        final embeddings = await FaceRecognitionService().getEmbeddings(photo);
        allEmbeddings.addAll(embeddings);
      }

      // 4. 클라이언트 사이드 그루핑
      final groupingResult = await GroupingService().assignGroups(allEmbeddings);

      // 5. 로컬 저장 (pendingUpload = true, 임베딩은 업로드 전까지만 보관)
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

      // 6. 백그라운드에서 서버 업로드 시도 (실패해도 무시, 나중에 재시도)
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
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRenderedStrip() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.selectedFrame == FrameType.trio ? Colors.pink[100] : Colors.white,
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.photos.length,
              itemBuilder: (context, index) =>
                  Image.file(File(widget.photos[index].path), fit: BoxFit.cover),
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
          const Text('pho\'s',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(DateTime.now().toString().substring(0, 10),
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

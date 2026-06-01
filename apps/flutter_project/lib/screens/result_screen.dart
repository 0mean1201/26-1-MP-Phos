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
  final String? overlayFrame;

  const ResultScreen({
    super.key,
    required this.selectedFrame,
    required this.photos,
    this.overlayFrame,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _onSavePressed() async {
    final titleController = TextEditingController();
    final tagController = TextEditingController();
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        title: Text(
          '사진 정보 입력',
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: 'Untitled',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: '태그',
                hintText: 'my_moment',
                prefixText: '#',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final title = titleController.text.trim();
    var tag = tagController.text.trim();
    if (tag.startsWith('#')) tag = tag.substring(1).trim();

    await _saveResultImage(
      title: title.isEmpty ? 'Untitled' : title,
      tag: tag.isEmpty ? 'my_moment' : tag,
    );
  }

  Future<void> _saveResultImage({
    required String title,
    required String tag,
  }) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();

      await Future.delayed(const Duration(milliseconds: 300));

      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'phos_${widget.selectedFrame.name}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('${appDir.path}/$fileName').create();
      await file.writeAsBytes(pngBytes);

      await Gal.putImage(file.path);

      final allEmbeddings = <List<double>>[];
      for (final photo in widget.photos) {
        final embeddings = await FaceRecognitionService().getEmbeddings(photo);
        allEmbeddings.addAll(embeddings);
      }

      final groupingResult =
          await GroupingService().assignGroups(allEmbeddings);

      final localPhoto = LocalPhoto(
        path: file.path,
        frameType: widget.selectedFrame.name,
        title: title,
        tag: tag,
        date: DateTime.now().toIso8601String(),
        groupIds: groupingResult.groupIds,
        pendingUpload: allEmbeddings.isNotEmpty,
        pendingVectors:
            allEmbeddings.isNotEmpty ? groupingResult.vectors : null,
      );
      await PhotoStorageService().addPhoto(localPhoto);

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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
        title: Text('Result',
            style: TextStyle(color: textMain, fontWeight: FontWeight.bold)),
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
                    onPressed: _isSaving ? null : _onSavePressed,
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
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    icon: Icon(Icons.home, color: primaryColor),
                    label: Text('Go Home',
                        style: TextStyle(color: primaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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

  Widget _buildRenderedStrip() {
    if (widget.overlayFrame != null) {
      return _buildCustomFrameStrip();
    }
    return _buildDefaultStrip();
  }

  Widget _buildDefaultStrip() {
    final isTrioFrame = widget.selectedFrame == FrameType.trio;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isTrioFrame ? Colors.pink[100] : Colors.white,
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
                color: AppColors.primary),
          ),
          Text(
            DateTime.now().toString().substring(0, 10),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  static const Map<String, List<List<double>>> _frameSlots = {
    '1.png':  [[0.1481,0.0927,0.8426,0.3146],[0.1519,0.3573,0.8463,0.5792],[0.1519,0.6240,0.8463,0.8453]],
    '2.png':  [[0.1491,0.0938,0.8407,0.3135],[0.1537,0.3578,0.8444,0.5781],[0.1537,0.6245,0.8444,0.8448]],
    '3.png':  [[0.1481,0.0932,0.8426,0.3146],[0.1528,0.3573,0.8454,0.5786],[0.1528,0.6240,0.8463,0.8453]],
    '4.png':  [[0.0662,0.0468,0.4770,0.4421],[0.5208,0.0468,0.9327,0.4421],[0.0662,0.4825,0.4770,0.8770],[0.5208,0.4825,0.9304,0.8770]],
    '5.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6158,0.9225,0.7883]],
    '6.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6158,0.9225,0.7883]],
    '7.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '8.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2267,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '9.png':  [[0.0718,0.0683,0.477, 0.423],[0.5387,0.0683,0.9439,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9439,0.8429]],
    '10.png': [[0.0718,0.069, 0.477, 0.423],[0.5387,0.069, 0.9439,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9439,0.8429]],
    '11.png': [[0.0718,0.0683,0.477, 0.423],[0.5387,0.0683,0.9439,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9439,0.8429]],
    '12.png': [[0.1574,0.0667,0.8417,0.2927],[0.1574,0.3214,0.8417,0.5474],[0.1574,0.5760,0.8417,0.8021]],
    '13.png': [[0.1574,0.0667,0.8417,0.2922],[0.1574,0.3214,0.8417,0.5469],[0.1574,0.5760,0.8417,0.8021]],
    '14.png': [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '15.png': [[0.075,0.0317,0.9225,0.2033],[0.075,0.2267,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '16.png': [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '17.png': [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '18.png': [[0.0718,0.069, 0.477, 0.423],[0.5387,0.069, 0.9439,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9439,0.8429]],
    '19.png': [[0.0718,0.069, 0.477, 0.423],[0.5387,0.069, 0.9428,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9428,0.8429]],
    '20.png': [[0.073, 0.069, 0.477, 0.423],[0.5387,0.069, 0.9428,0.423],[0.073, 0.4889,0.477, 0.8429],[0.5387,0.4889,0.9428,0.8429]],
    '21.png': [[0.1574,0.0667,0.8417,0.2922],[0.1574,0.3214,0.8417,0.5469],[0.1574,0.576, 0.8417,0.8021]],
    '22.png': [[0.1574,0.0667,0.8417,0.2922],[0.1574,0.3214,0.8417,0.5469],[0.1574,0.576, 0.8417,0.8021]],
    '23.png': [[0.1574,0.0667,0.8417,0.2922],[0.1574,0.3214,0.8417,0.5474],[0.1574,0.576, 0.8417,0.8021]],
    '24.png': [[0.1574,0.0667,0.8417,0.2922],[0.1574,0.3214,0.8417,0.5469],[0.1574,0.576, 0.8417,0.8021]],
    '25.png': [[0.1574,0.0667,0.8417,0.2927],[0.1574,0.3214,0.8417,0.5474],[0.1574,0.576, 0.8417,0.8021]],
    '26.png': [[0.1574,0.0667,0.8417,0.2927],[0.1574,0.3214,0.8417,0.5474],[0.1574,0.576, 0.8417,0.8021]],
    '27.png': [[0.0718,0.0683,0.477, 0.423],[0.5387,0.0683,0.9439,0.423],[0.0718,0.4889,0.477, 0.8429],[0.5387,0.4889,0.9439,0.8429]],
    '28.png': [[0.0718,0.0683,0.4781,0.4238],[0.5376,0.0683,0.9439,0.4238],[0.0718,0.4881,0.4781,0.8437],[0.5376,0.4881,0.9439,0.8437]],
    '29.png': [[0.0725,0.0308,0.925, 0.2033],[0.0725,0.2258,0.9225,0.3992],[0.0725,0.4208,0.925, 0.5942],[0.075, 0.6158,0.9225,0.7883]],
    '30.png': [[0.075, 0.0308,0.9225,0.2033],[0.075, 0.2258,0.9225,0.3983],[0.075, 0.4208,0.9225,0.5933],[0.075, 0.6158,0.9225,0.7692]],
  };

  static const Map<String, double> _frameAspectRatio = {
    '1.png':  1920/1080, '2.png':  1920/1080, '3.png':  1920/1080,
    '4.png':  1260/891,  '5.png':  1200/400,  '6.png':  1200/400,
    '7.png':  1200/400,  '8.png':  1200/400,  '9.png':  1260/891,
    '10.png': 1260/891,  '11.png': 1260/891,  '12.png': 1920/1080,
    '13.png': 1920/1080, '14.png': 1200/400,  '15.png': 1200/400,
    '16.png': 1200/400,  '17.png': 1200/400,  '18.png': 1260/891,
    '19.png': 1260/891,  '20.png': 1260/891,  '21.png': 1920/1080,
    '22.png': 1920/1080, '23.png': 1920/1080, '24.png': 1920/1080,
    '25.png': 1920/1080, '26.png': 1920/1080, '27.png': 1260/891,
    '28.png': 1260/891,  '29.png': 1200/400,  '30.png': 1200/400,
  };

  Widget _buildCustomFrameStrip() {
    final fileName = widget.overlayFrame!.split('/').last;
    final slots = _frameSlots[fileName];

    if (slots == null) return _buildDefaultStrip();

    const double frameW = 300.0;
    final double aspectRatio = _frameAspectRatio[fileName] ?? (1920 / 1080);
    final double frameH = frameW * aspectRatio;
    final usedSlots = slots.take(widget.photos.length).toList();

    return SizedBox(
      width: frameW,
      height: frameH,
      child: Stack(
        children: [
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

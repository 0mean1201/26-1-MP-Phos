import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants.dart';
import 'result_screen.dart';

class CutSelectionScreen extends StatefulWidget {
  final FrameType selectedFrame;
  final List<XFile> photos;
  final String? overlayFrame;

  const CutSelectionScreen({
    super.key,
    required this.selectedFrame,
    required this.photos,
    this.overlayFrame,
  });

  @override
  State<CutSelectionScreen> createState() => _CutSelectionScreenState();
}

class _CutSelectionScreenState extends State<CutSelectionScreen> {
  late List<XFile> _pool;
  final List<int> _selectedOrder = [];

  int get _required => widget.selectedFrame.photoCount;
  bool get _isComplete => _selectedOrder.length == _required;

  // ── 프레임 슬롯 좌표 맵 (result_screen과 동일) ─────────────────────────
  static const Map<String, List<List<double>>> _frameSlots = {
    '1.png':  [[0.1481,0.0927,0.8426,0.3146],[0.1519,0.3573,0.8463,0.5792],[0.1519,0.6240,0.8463,0.8453]],
    '2.png':  [[0.1491,0.0938,0.8407,0.3135],[0.1537,0.3578,0.8444,0.5781],[0.1537,0.6245,0.8444,0.8448]],
    '3.png':  [[0.1481,0.0932,0.8426,0.3146],[0.1528,0.3573,0.8454,0.5786],[0.1528,0.6240,0.8463,0.8453]],
    '4.png':  [[0.0662,0.0468,0.4770,0.4421],[0.5208,0.0468,0.9327,0.4421],[0.0662,0.4825,0.4770,0.8770],[0.5208,0.4825,0.9304,0.8770]],
    '5.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6158,0.9225,0.7883]],
    '6.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6158,0.9225,0.7883]],
    '7.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '8.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2267,0.9225,0.3983],[0.075,0.4217,0.9225,0.5933],[0.075,0.6167,0.9225,0.7883]],
    '9.png':  [[0.075,0.0308,0.9225,0.2033],[0.075,0.2258,0.9225,0.3983],[0.075,0.4208,0.9225,0.5933],[0.075,0.6158,0.9225,0.7883]],
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
    '7.png':  1200/400,  '8.png':  1200/400,  '9.png':  1200/400,
    '10.png': 1260/891,  '11.png': 1260/891,  '12.png': 1920/1080,
    '13.png': 1920/1080, '14.png': 1200/400,  '15.png': 1200/400,
    '16.png': 1200/400,  '17.png': 1200/400,  '18.png': 1260/891,
    '19.png': 1260/891,  '20.png': 1260/891,  '21.png': 1920/1080,
    '22.png': 1920/1080, '23.png': 1920/1080, '24.png': 1920/1080,
    '25.png': 1920/1080, '26.png': 1920/1080, '27.png': 1260/891,
    '28.png': 1260/891,  '29.png': 1200/400,  '30.png': 1200/400,
  };

  @override
  void initState() {
    super.initState();
    _pool = List<XFile>.from(widget.photos);
    for (int i = 0; i < _pool.length && _selectedOrder.length < _required; i++) {
      _selectedOrder.add(i);
    }
  }

  Future<void> _addFromGallery() async {
    try {
      final picked = await ImagePicker().pickMultiImage();
      if (picked.isEmpty) return;
      setState(() => _pool.addAll(picked));
    } catch (e) {
      debugPrint('갤러리 불러오기 오류: $e');
    }
  }

  void _toggle(int photoIndex) {
    setState(() {
      if (_selectedOrder.contains(photoIndex)) {
        _selectedOrder.remove(photoIndex);
        return;
      }
      if (_selectedOrder.length >= _required) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('최대 $_required장까지 선택할 수 있어요. 먼저 컷을 해제해 주세요.'),
            duration: const Duration(seconds: 2),
          ));
        return;
      }
      _selectedOrder.add(photoIndex);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _selectedOrder.removeAt(oldIndex);
      _selectedOrder.insert(newIndex, item);
    });
  }

  void _confirm() {
    if (!_isComplete) return;
    final ordered = _selectedOrder.map((i) => _pool[i]).toList();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          selectedFrame: widget.selectedFrame,
          photos: ordered,
          overlayFrame: widget.overlayFrame,
        ),
      ),
    );
  }

  // ── 커스텀 프레임 미리보기 ──────────────────────────────────────────────
  // 선택된 컷들이 프레임 슬롯에 실시간으로 채워지는 위젯
  Widget _buildFramePreview() {
    final overlay = widget.overlayFrame;

    // 커스텀 프레임이 없으면 기존 가로 썸네일 목록으로 폴백
    if (overlay == null) return _buildDefaultThumbRow();

    final fileName = overlay.split('/').last;
    final slots = _frameSlots[fileName];

    // 슬롯 정보가 없으면 폴백
    if (slots == null) return _buildDefaultThumbRow();

    // 미리보기 높이 고정 후 너비를 비율로 계산
    const double previewH = 200.0;
    final double aspectRatio = _frameAspectRatio[fileName] ?? (1920 / 1080);
    final double previewW = previewH / aspectRatio;

    return SizedBox(
      height: previewH,
      child: Center(
        child: SizedBox(
          width: previewW,
          height: previewH,
          child: Stack(
            children: [
              // 1) 선택된 사진을 슬롯 위치에 배치 (빈 슬롯은 회색 박스)
              for (int i = 0; i < slots.length; i++)
                Positioned(
                  left:   previewW * slots[i][0],
                  top:    previewH * slots[i][1],
                  width:  previewW * (slots[i][2] - slots[i][0]),
                  height: previewH * (slots[i][3] - slots[i][1]),
                  child: i < _selectedOrder.length
                      ? Image.file(
                          File(_pool[_selectedOrder[i]].path),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),

              // 2) 커스텀 프레임 이미지 (위 레이어)
              Positioned.fill(
                child: IgnorePointer(
                  child: Image.asset(
                    overlay,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 커스텀 프레임 없을 때 기존 가로 썸네일 목록
  Widget _buildDefaultThumbRow() {
    final primaryColor = AppColors.primaryOf(context);
    return SizedBox(
      height: 120,
      child: _selectedOrder.isEmpty
          ? Center(
              child: Text(
                '아래에서 사진을 선택해 주세요',
                style: TextStyle(
                  color: AppColors.textSubOf(context),
                  fontSize: 13,
                ),
              ),
            )
          : ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              buildDefaultDragHandles: true,
              itemCount: _selectedOrder.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final photoIndex = _selectedOrder[index];
                return _SelectedThumb(
                  key: ValueKey('selected_$photoIndex'),
                  path: _pool[photoIndex].path,
                  order: index + 1,
                  primaryColor: primaryColor,
                  onRemove: () => _toggle(photoIndex),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bg(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);

    // 커스텀 프레임 사용 여부
    final hasOverlay = widget.overlayFrame != null &&
        _frameSlots.containsKey(widget.overlayFrame!.split('/').last);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          '컷 선택',
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_selectedOrder.length} / $_required',
                style: TextStyle(
                  color: _isComplete ? primaryColor : textSub,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 상단: 프레임 미리보기 or 선택 순서 썸네일 ──────────────────
          if (hasOverlay) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  Text(
                    '프레임 미리보기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '컷을 선택하면 슬롯에 채워져요',
                    style: TextStyle(fontSize: 11, color: textSub),
                  ),
                ],
              ),
            ),
            _buildFramePreview(),
            const SizedBox(height: 4),
          ] else ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  Text(
                    '선택한 순서',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '길게 눌러 드래그하면 순서를 바꿀 수 있어요',
                    style: TextStyle(fontSize: 11, color: textSub),
                  ),
                ],
              ),
            ),
            _buildDefaultThumbRow(),
          ],

          Divider(color: AppColors.dividerOf(context), height: 24),

          // ── 전체 컷 ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '전체 컷 (${_pool.length}장)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textMain,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addFromGallery,
                  icon: Icon(Icons.add_photo_alternate_outlined,
                      size: 18, color: primaryColor),
                  label: Text(
                    '갤러리에서 추가',
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _pool.length,
              itemBuilder: (context, index) {
                final order = _selectedOrder.indexOf(index);
                return _GridCut(
                  path: _pool[index].path,
                  order: order >= 0 ? order + 1 : null,
                  primaryColor: primaryColor,
                  onTap: () => _toggle(index),
                );
              },
            ),
          ),

          // ── 하단 완료 버튼 ──────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isComplete ? _confirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: textSub.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _isComplete
                        ? '이 컷으로 만들기'
                        : '${_required - _selectedOrder.length}장 더 선택해 주세요',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedThumb extends StatelessWidget {
  final String path;
  final int order;
  final Color primaryColor;
  final VoidCallback onRemove;

  const _SelectedThumb({
    super.key,
    required this.path,
    required this.order,
    required this.primaryColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 88,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 4, left: 4,
            child: Container(
              width: 22, height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              child: Text('$order',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            top: -6, right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24, height: 24,
                decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCut extends StatelessWidget {
  final String path;
  final int? order;
  final Color primaryColor;
  final VoidCallback onTap;

  const _GridCut({
    required this.path,
    required this.order,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = order != null;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
          if (selected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor, width: 3),
                  color: primaryColor.withOpacity(0.18),
                ),
              ),
            ),
          Positioned(
            top: 6, left: 6,
            child: Container(
              width: 24, height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? primaryColor : Colors.black45,
                shape: BoxShape.circle,
              ),
              child: selected
                  ? Text('$order',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))
                  : const Icon(Icons.circle_outlined, color: Colors.white70, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants.dart';
import 'result_screen.dart';

/// 촬영이 끝난 뒤, 찍은 컷 중 프레임에 들어갈 사진을 고르고
/// 순서를 재배치하는 화면.
class CutSelectionScreen extends StatefulWidget {
  final FrameType selectedFrame;
  final List<XFile> photos; // 촬영된 전체 컷

  const CutSelectionScreen({
    super.key,
    required this.selectedFrame,
    required this.photos,
  });

  @override
  State<CutSelectionScreen> createState() => _CutSelectionScreenState();
}

class _CutSelectionScreenState extends State<CutSelectionScreen> {
  /// 후보 컷 풀 (카메라 촬영분 + 갤러리에서 추가한 사진).
  late List<XFile> _pool;

  /// 선택된 컷의 순서. _pool에 대한 인덱스를 순서대로 보관.
  final List<int> _selectedOrder = [];

  int get _required => widget.selectedFrame.photoCount;
  bool get _isComplete => _selectedOrder.length == _required;

  @override
  void initState() {
    super.initState();
    _pool = List<XFile>.from(widget.photos);
    // 기본값: 앞에서부터 필요한 장수만큼 자동 선택
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
          ..showSnackBar(
            SnackBar(
              content: Text('최대 $_required장까지 선택할 수 있어요. 먼저 컷을 해제해 주세요.'),
              duration: const Duration(seconds: 2),
            ),
          );
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bg(context);
    final primaryColor = AppColors.primaryOf(context);
    final textMain = AppColors.textMainOf(context);
    final textSub = AppColors.textSubOf(context);

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
          // ── 선택한 순서 (드래그로 재배치) ─────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                Text('선택한 순서',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textMain)),
                const SizedBox(width: 6),
                Text('길게 눌러 드래그하면 순서를 바꿀 수 있어요',
                    style: TextStyle(fontSize: 11, color: textSub)),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: _selectedOrder.isEmpty
                ? Center(
                    child: Text('아래에서 사진을 선택해 주세요',
                        style: TextStyle(color: textSub, fontSize: 13)),
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
          ),

          Divider(color: AppColors.dividerOf(context), height: 24),

          // ── 전체 컷 (탭하여 선택/해제) ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('전체 컷 (${_pool.length}장)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textMain)),
                TextButton.icon(
                  onPressed: _addFromGallery,
                  icon: Icon(Icons.add_photo_alternate_outlined,
                      size: 18, color: primaryColor),
                  label: Text('갤러리에서 추가',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600)),
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

          // ── 하단 완료 버튼 ───────────────────────────
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

/// 상단 "선택한 순서" 영역의 썸네일 (순서 번호 + 제거 버튼)
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
          // 순서 번호 배지
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text('$order',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          // 제거 버튼
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 하단 "전체 컷" 그리드 셀
class _GridCut extends StatelessWidget {
  final String path;
  final int? order; // null = 미선택
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
          // 선택 시 강조 테두리 + 반투명 오버레이
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
          // 순서 번호 배지
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? primaryColor : Colors.black45,
                shape: BoxShape.circle,
              ),
              child: selected
                  ? Text('$order',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold))
                  : const Icon(Icons.circle_outlined,
                      color: Colors.white70, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

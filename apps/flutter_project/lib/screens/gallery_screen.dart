import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants.dart';
import '../services/face_recognition_service.dart';
import '../services/grouping_service.dart';
import '../services/photo_storage_service.dart';
import 'frame_conversion_screen.dart';
import 'search_result_screen.dart';

/// 갤러리에서 사진 한 장을 표현하는 경량 DTO (UI 전용)
class SavedPhoto {
  final String path;
  final FrameType frameType;
  final String title;
  final String tag;
  final List<List<double>> embeddings;

  SavedPhoto({
    required this.path,
    required this.frameType,
    required this.title,
    required this.tag,
    this.embeddings = const [],
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  FrameType _selectedFilter = FrameType.classic;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<SavedPhoto> _myGallery = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPhotos();
  }

  Future<void> _loadSavedPhotos() async {
    final photos = await PhotoStorageService().loadAll();
    final loaded = photos.map((p) {
      FrameType frameType;
      try {
        frameType = FrameType.values.byName(p.frameType);
      } catch (_) {
        frameType = FrameType.classic;
      }
      return SavedPhoto(
        path: p.path,
        frameType: frameType,
        title: p.title,
        tag: p.tag,
        embeddings: p.pendingVectors ?? [],
      );
    }).toList();

    if (mounted) {
      setState(() {
        _myGallery = loaded;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchByFace() async {
    final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    final targetEmbeddings = await FaceRecognitionService().getEmbeddings(imageFile);
    if (targetEmbeddings.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('선택한 사진에서 얼굴을 인식할 수 없습니다.')),
      );
      return;
    }

    final targetEmbedding = targetEmbeddings.first;
    final similarPhotos = _findSimilarPhotos(targetEmbedding);

    if (!mounted) return;
    if (similarPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('동일 인물 사진을 찾지 못했습니다.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResultScreen(foundPhotos: similarPhotos)),
    );
  }

  List<SavedPhoto> _findSimilarPhotos(List<double> targetEmbedding) {
    const double threshold = 0.6;
    return _myGallery.where((photo) {
      return photo.embeddings.any((embedding) {
        return GroupingService.cosineSimilarity(targetEmbedding, embedding) > threshold;
      });
    }).toList();
  }

  Future<void> _updatePhotoMeta(
      String targetPath, String newTitle, String newTag) async {
    final all = await PhotoStorageService().loadAll();
    final target = all.firstWhere((p) => p.path == targetPath, orElse: () => all.first);
    await PhotoStorageService()
        .updatePhoto(targetPath, target.copyWith(title: newTitle, tag: newTag));
    await _loadSavedPhotos();
  }

  void _showEditDialog(SavedPhoto photo) {
    final titleController = TextEditingController(text: photo.title);
    final tagController = TextEditingController(text: photo.tag);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사진 정보 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: '제목을 입력하세요',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: '태그',
                hintText: '태그를 입력하세요',
                prefixText: '#',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim().isEmpty
                  ? photo.title
                  : titleController.text.trim();
              var newTag = tagController.text.trim();
              if (newTag.startsWith('#')) newTag = newTag.substring(1).trim();
              if (newTag.isEmpty) newTag = photo.tag;
              _updatePhotoMeta(photo.path, newTitle, newTag);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getFrameLabel(FrameType type) {
    switch (type) {
      case FrameType.classic: return '4x1';
      case FrameType.square: return '2x2';
      case FrameType.trio: return '3x1';
      case FrameType.solo: return '1x1';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredGallery = _myGallery.where((photo) {
      final matchesFilter = photo.frameType == _selectedFilter;
      final matchesSearch = photo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          photo.tag.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.face_retouching_natural, color: AppColors.primary),
                  onPressed: _searchByFace,
                ),
                const Text('pho\'s',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primary),
                  onPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) {
                        _searchController.clear();
                        _searchQuery = '';
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 15),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '사진 이름이나 태그로 검색...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Gallery',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FrameConversionScreen()),
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('프레임 변환하기',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: FrameType.values.map((frame) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = frame),
                    child: _buildFilterChip(_getFrameLabel(frame), _selectedFilter == frame),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredGallery.isEmpty
                    ? const Center(
                        child: Text('해당하는 사진이 없습니다.',
                            style: TextStyle(color: Colors.grey)))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredGallery.length,
                        itemBuilder: (context, index) {
                          final photo = filteredGallery[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(photo.path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image)),
                                ),
                                Positioned(
                                  bottom: 0, left: 0, right: 0,
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      '${photo.title}\n#${photo.tag}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5, right: 5,
                                  child: GestureDetector(
                                    onTap: () => _showEditDialog(photo),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.edit,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
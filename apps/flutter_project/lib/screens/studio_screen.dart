import 'dart:io';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  List<IntimacyDto> _intimacyList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadIntimacy();
  }

  Future<void> _loadIntimacy() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final appInstanceId = ApiService().appInstanceId;
    if (appInstanceId == null || appInstanceId == -1) {
      setState(() {
        _errorMessage = '서버에 연결되지 않았습니다.\n인터넷 연결 후 앱을 재시작해 주세요.';
        _isLoading = false;
      });
      return;
    }

    try {
      final data = await ApiService().getIntimacy(appInstanceId);
      setState(() {
        _intimacyList = data;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = '친밀도 데이터를 불러올 수 없습니다.\n서버 연결을 확인해 주세요.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'pho\'s',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const Text(
                  'Studio',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '자주 함께한 인물들',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadIntimacy,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_intimacyList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('아직 사진이 없습니다.\n사진을 찍으면 인물이 자동으로 분류됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], height: 1.5)),
          ],
        ),
      );
    }

    final maxCount = _intimacyList.map((e) => e.photoCount).reduce((a, b) => a > b ? a : b);

    return RefreshIndicator(
      onRefresh: _loadIntimacy,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _intimacyList.length,
        itemBuilder: (context, index) {
          final entry = _intimacyList[index];
          final ratio = maxCount > 0 ? entry.photoCount / maxCount : 0.0;
          return _buildIntimacyCard(entry, ratio, index + 1);
        },
      ),
    );
  }

  void _showRenameDialog(IntimacyDto entry) {
    final controller = TextEditingController(text: entry.groupName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('인물 이름 수정'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '이름을 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              Navigator.pop(dialogContext);
              try {
                await ApiService().renameGroup(entry.groupId, newName);
                await _loadIntimacy();
              } catch (_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이름 수정에 실패했습니다.')),
                );
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(int rank) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.12),
      child: Center(
        child: Text(
          '#$rank',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildIntimacyCard(IntimacyDto entry, double ratio, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // 대표 사진 아바타
          ClipOval(
            child: SizedBox(
              width: 56,
              height: 56,
              child: entry.representativeImagePath != null
                  ? Image.file(
                      File(entry.representativeImagePath!),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stack) => _defaultAvatar(rank),
                    )
                  : _defaultAvatar(rank),
            ),
          ),
          const SizedBox(width: 14),
          // 이름 + 친밀도 바
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showRenameDialog(entry),
                  child: Row(
                    children: [
                      Text(
                        entry.groupName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '함께한 사진 ${entry.photoCount}장',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

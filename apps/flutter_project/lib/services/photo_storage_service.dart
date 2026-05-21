import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class LocalPhoto {
  final String path;
  final String frameType;
  final String title;
  final String tag;
  final String date;
  final int? serverPhotoId;
  final List<int> groupIds;
  final bool pendingUpload;
  final List<List<double>>? pendingVectors;

  const LocalPhoto({
    required this.path,
    required this.frameType,
    required this.title,
    required this.tag,
    required this.date,
    this.serverPhotoId,
    this.groupIds = const [],
    this.pendingUpload = false,
    this.pendingVectors,
  });

  LocalPhoto copyWith({
    String? path,
    String? frameType,
    String? title,
    String? tag,
    String? date,
    int? serverPhotoId,
    List<int>? groupIds,
    bool? pendingUpload,
    List<List<double>>? pendingVectors,
    bool clearPendingVectors = false,
  }) {
    return LocalPhoto(
      path: path ?? this.path,
      frameType: frameType ?? this.frameType,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      date: date ?? this.date,
      serverPhotoId: serverPhotoId ?? this.serverPhotoId,
      groupIds: groupIds ?? this.groupIds,
      pendingUpload: pendingUpload ?? this.pendingUpload,
      pendingVectors: clearPendingVectors ? null : (pendingVectors ?? this.pendingVectors),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'path': path,
      'frameType': frameType,
      'title': title,
      'tag': tag,
      'date': date,
      'serverPhotoId': serverPhotoId,
      'groupIds': groupIds,
      'pendingUpload': pendingUpload,
    };
    if (pendingVectors != null) {
      map['pendingVectors'] = pendingVectors!.map((v) => v).toList();
    }
    return map;
  }

  factory LocalPhoto.fromJson(Map<String, dynamic> json) {
    FrameType frameTypeEnum;
    try {
      frameTypeEnum = FrameType.values.byName(json['frameType'] as String? ?? 'classic');
    } catch (_) {
      frameTypeEnum = FrameType.classic;
    }

    List<List<double>>? vectors;
    final rawVectors = json['pendingVectors'];
    if (rawVectors is List) {
      vectors = rawVectors.map((v) {
        if (v is List) return v.map((e) => (e as num).toDouble()).toList();
        return <double>[];
      }).toList();
    }

    return LocalPhoto(
      path: json['path'] as String? ?? '',
      frameType: frameTypeEnum.name,
      title: json['title'] as String? ?? 'Untitled',
      tag: json['tag'] as String? ?? 'my_moment',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      serverPhotoId: json['serverPhotoId'] as int?,
      groupIds: (json['groupIds'] as List?)?.map((e) => (e as num).toInt()).toList() ?? [],
      pendingUpload: json['pendingUpload'] as bool? ?? false,
      pendingVectors: vectors,
    );
  }
}

class PhotoStorageService {
  static const String _key = 'phos_gallery_data';

  static final PhotoStorageService _instance = PhotoStorageService._internal();
  factory PhotoStorageService() => _instance;
  PhotoStorageService._internal();

  Future<List<LocalPhoto>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final strings = prefs.getStringList(_key) ?? [];
    final result = <LocalPhoto>[];
    for (final s in strings) {
      try {
        result.add(LocalPhoto.fromJson(jsonDecode(s) as Map<String, dynamic>));
      } catch (_) {}
    }
    return result.reversed.toList();
  }

  Future<void> saveAll(List<LocalPhoto> photos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, photos.reversed.map((p) => jsonEncode(p.toJson())).toList());
  }

  Future<void> addPhoto(LocalPhoto photo) async {
    final prefs = await SharedPreferences.getInstance();
    final strings = prefs.getStringList(_key) ?? [];
    strings.add(jsonEncode(photo.toJson()));
    await prefs.setStringList(_key, strings);
  }

  Future<void> updatePhoto(String path, LocalPhoto updated) async {
    final prefs = await SharedPreferences.getInstance();
    final strings = prefs.getStringList(_key) ?? [];
    for (int i = 0; i < strings.length; i++) {
      try {
        final data = jsonDecode(strings[i]) as Map<String, dynamic>;
        if (data['path'] == path) {
          strings[i] = jsonEncode(updated.toJson());
          break;
        }
      } catch (_) {}
    }
    await prefs.setStringList(_key, strings);
  }

  Future<List<LocalPhoto>> getPendingUploads() async {
    final all = await loadAll();
    return all.where((p) => p.pendingUpload).toList();
  }
}

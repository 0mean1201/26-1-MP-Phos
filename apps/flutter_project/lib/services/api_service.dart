import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class RepresentativeDto {
  final int groupId;
  final String groupName;
  final int representativeFaceId;
  final List<double> vector;

  RepresentativeDto({
    required this.groupId,
    required this.groupName,
    required this.representativeFaceId,
    required this.vector,
  });

  factory RepresentativeDto.fromJson(Map<String, dynamic> json) {
    return RepresentativeDto(
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      representativeFaceId: json['representativeFaceId'] as int,
      vector: (json['vector'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }
}

class IntimacyDto {
  final int groupId;
  final String groupName;
  final int photoCount;
  final List<double> representativeVector;
  final String? representativeImagePath;

  IntimacyDto({
    required this.groupId,
    required this.groupName,
    required this.photoCount,
    required this.representativeVector,
    this.representativeImagePath,
  });

  factory IntimacyDto.fromJson(Map<String, dynamic> json) {
    return IntimacyDto(
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      photoCount: json['photoCount'] as int,
      representativeVector: (json['representativeVector'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      representativeImagePath: json['representativeImagePath'] as String?,
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://port-0-phos-mpiml6p754ac32d4.sel3.cloudtype.app';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  int? _appInstanceId;

  int? get appInstanceId => _appInstanceId;

  void setAppInstanceId(int id) {
    _appInstanceId = id;
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl$path'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw ApiException(json['message'] ?? 'Unknown error', statusCode: response.statusCode);
    }
    return json;
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await http
        .get(Uri.parse('$baseUrl$path'))
        .timeout(const Duration(seconds: 30));

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw ApiException(json['message'] ?? 'Unknown error', statusCode: response.statusCode);
    }
    return json;
  }

  /// 앱 인스턴스를 서버에 등록하고 ID를 반환
  Future<int> registerAppInstance(String deviceId) async {
    final json = await _post('/api/app-instances', {'deviceId': deviceId});
    return (json['data']['appInstanceId'] as int);
  }

  /// 특정 앱 인스턴스의 그룹별 대표 얼굴 벡터 조회
  Future<List<RepresentativeDto>> getRepresentatives(int appInstanceId) async {
    final json = await _get('/api/groups/representatives/$appInstanceId');
    final data = json['data'] as List;
    return data.map((e) => RepresentativeDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 새 그룹 생성 후 groupId 반환
  Future<int> createGroup(int appInstanceId, String name) async {
    final json = await _post('/api/groups', {
      'appInstanceId': appInstanceId,
      'name': name,
    });
    return (json['data']['groupId'] as int);
  }

  /// 사진 + 얼굴 벡터 업로드 후 서버 photoId 반환
  Future<int> uploadPhoto({
    required int appInstanceId,
    required String imagePath,
    required List<Map<String, dynamic>> vectors,
  }) async {
    final json = await _post('/api/photos', {
      'appInstanceId': appInstanceId,
      'imagePath': imagePath,
      'vectors': vectors,
    });
    return (json['data']['id'] as int);
  }

  /// 그룹 이름 수정
  Future<void> renameGroup(int groupId, String name) async {
    final response = await http
        .patch(
          Uri.parse('$baseUrl/api/groups/$groupId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name}),
        )
        .timeout(const Duration(seconds: 10));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw ApiException(json['message'] ?? 'Unknown error', statusCode: response.statusCode);
    }
  }

  /// 친밀도(그룹별 사진 수) 조회
  Future<List<IntimacyDto>> getIntimacy(int appInstanceId) async {
    final json = await _get('/api/groups/intimacy/$appInstanceId');
    final data = json['data'] as List;
    return data.map((e) => IntimacyDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../core/auth_state.dart';

export '../core/auth_state.dart' show AuthUser;

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'phos_jwt_token';
  static const _userKey = 'phos_auth_user';

  // serverClientId = Web OAuth 2.0 클라이언트 ID (Google Cloud Console에서 발급)
  static final _googleSignIn = GoogleSignIn(
    serverClientId:
        '321849376169-9vmeajm40uo4uni76559jsr1ppcq8sab.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  String? get token => _token;
  bool get isSignedIn => _token != null;

  /// 앱 시작 시 저장된 세션 복원
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
    final userJson = await _storage.read(key: _userKey);
    if (_token != null && userJson != null) {
      try {
        authNotifier.value =
            AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        await _clearStorage();
      }
    }
  }

  /// Google 로그인 → 서버에 idToken 전달 → JWT 수령
  Future<bool> signInWithGoogle(int? appInstanceId) async {
    final account = await _googleSignIn.signIn();
    if (account == null) return false;

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) throw Exception('Google ID 토큰 발급 실패');

    final response = await http
        .post(
          Uri.parse('${ApiService.baseUrl}/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idToken': idToken,
            'appInstanceId': appInstanceId,
          }),
        )
        .timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? '로그인 실패');
    }

    final payload = data['data'] as Map<String, dynamic>;
    _token = payload['token'] as String;
    final user = AuthUser.fromJson(payload['user'] as Map<String, dynamic>);

    await _storage.write(key: _tokenKey, value: _token);
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));

    authNotifier.value = user;
    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _clearStorage();
    authNotifier.value = null;
    _token = null;
  }

  Future<void> _clearStorage() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}

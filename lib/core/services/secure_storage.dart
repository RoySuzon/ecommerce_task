import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenServices {
  Future saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class SecureStorageService extends TokenServices {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  // Save token
  @override
  Future saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete token
  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

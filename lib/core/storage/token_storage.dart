import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  TokenStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> saveUserId(int userId) async {
    await _storage.write(
      key: _userIdKey,
      value: userId.toString(),
    );
  }

  Future<int?> getUserId() async {
    final id = await _storage.read(
      key: _userIdKey,
    );

    if (id == null) return null;

    return int.tryParse(id);
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: _tokenKey,
    );

    await _storage.delete(
      key: _userIdKey,
    );
  }
}
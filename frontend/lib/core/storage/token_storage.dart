import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kToken = 'access_token';
  final _storage = const FlutterSecureStorage();

  Future<void> save(String token) => _storage.write(key: _kToken, value: token);
  Future<String?> read() => _storage.read(key: _kToken);
  Future<void> clear() => _storage.delete(key: _kToken);
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyEmail = "email";
  static const _keyToken = "token";

  static setEmail(String email) async =>
    await _storage.write(key: _keyEmail, value: email);
  
  static Future<String> getEmail() async =>
    await _storage.read(key: _keyEmail);
  
  static setToken(String token) async =>
    await _storage.write(key: _keyToken, value: token);
  
  static Future<String> getToken() async =>
    await _storage.read(key: _keyToken);
}
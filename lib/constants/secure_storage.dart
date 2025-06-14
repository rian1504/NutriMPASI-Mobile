import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _userDatakey = 'user_data';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Simpan Data User (dalam bentuk JSON string)
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userDatakey, value: json.encode(userData));
  }

  // Dapatkan Data User
  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _userDatakey);
    return data != null ? json.decode(data) : null;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

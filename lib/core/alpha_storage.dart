import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AlphaStorage {
  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const _androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  static const _storage = FlutterSecureStorage(aOptions: _androidOptions, iOptions: _iosOptions);

  static Future<bool> saveJson({key, value}) async {
    try {
      if (value != null) {
        String data = json.encode(value);

        await _storage.write(key: key, value: data);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> save({key, value}) async {
    try {
      if (value != null) {
        await _storage.write(key: key, value: value.toString());
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<String?> read(key) async {
    return await _storage.read(key: key);
  }

  static Future<int?> readInt(key) async {
    final String? value = await read(key);
    try {
      if (value != null) {
        return int.parse(value);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> readJson(key) async {
    try {
      String? data = await AlphaStorage.read(key);
      if (data != null) {
        return json.decode(data);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> delete(key) async {
    await _storage.delete(key: key);
  }
}

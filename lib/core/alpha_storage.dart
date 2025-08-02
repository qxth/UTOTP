import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'enums/storage_enum.dart';

class AlphaStorage {
  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const _androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  static const _storage = FlutterSecureStorage(aOptions: _androidOptions, iOptions: _iosOptions);

  static Future<bool> saveJson({required EnumAlphaStorage key, required value}) async {
    try {
      if (value != null) {
        String data = json.encode(value);

        await _storage.write(key: key.name, value: data);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> save({required EnumAlphaStorage key, required value}) async {
    try {
      if (value != null) {
        await _storage.write(key: key.name, value: value?.toString());
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<String?> read(EnumAlphaStorage key) async {
    return await _storage.read(key: key.name);
  }

  static Future<int?> readInt(EnumAlphaStorage key) async {
    final String? value = await read(key);
    return int.tryParse(value ?? '');
  }

  static Future<dynamic> readJson(EnumAlphaStorage key) async {
    try {
      String? data = await AlphaStorage.read(key);
      if (data != null) {
        return json.decode(data);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> delete(EnumAlphaStorage key) async {
    await _storage.delete(key: key.name);
  }
}

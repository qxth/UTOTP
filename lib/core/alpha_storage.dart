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
      return false;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  static Future<bool> save({key, value}) async {
    try {
      if (value != null) {
        await _storage.write(key: key, value: value.toString());
        return true;
      }
      return false;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  static Future<String?> read(key) async {
    return await _storage.read(key: key);
  }

  static Future<String?> readJson(key) async {
    try {
      String? data = await AlphaStorage.read(key);
      if (data != null) {
        return json.decode(data);
      }
      return null;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  static Future<void> delete(key) async {
    await _storage.delete(key: key);
  }
}

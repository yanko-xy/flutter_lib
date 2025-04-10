library flutter_xy_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XYStoreage {
  static late FlutterSecureStorage? _storage;
  static late SharedPreferences _syncBox; // 提前打开的 Hive box

  XYStoreage._();

  static write({required String key, required String value}) async {
    if (_storage == null) {
      throw "storage is null, init() first";
    }
    await _storage!.write(key: key, value: value);
  }

  static writeSync({required String key, required String value}) async {
    if (_storage == null) {
      throw "storage is null, init() first";
    }
    await _storage!.write(key: key, value: value);
  }

  static read({required String key}) async {
    if (_storage == null) {
      throw "storage is null, init() first";
    }
    return await _storage!.read(key: key);
  }

  static Future<void> writeSecure(
      {required String key, required String value}) async {
    if (_storage == null) {
      throw "storage is null, init() first";
    }
    await _storage!.write(key: key, value: value);
  }

  static Future<dynamic> readSecure({required String key}) async {
    if (_storage == null) {
      throw "storage is null, init() first";
    }
    return await _storage!.read(key: key);
  }

  static Future<void> init() async {
    _storage = const FlutterSecureStorage();
    _syncBox = await SharedPreferences.getInstance();
  }
}

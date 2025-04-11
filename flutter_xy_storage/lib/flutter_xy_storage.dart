library flutter_xy_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class XYStoreage {
  static FlutterSecureStorage? storage;

  XYStoreage._internal() {
    if (storage == null) {
      storage = const FlutterSecureStorage();
    }
  }

  static write({required String key, required String value}) async {
    if (storage == null) {
      throw "storage is null, init() first";
    }
    await storage!.write(key: key, value: value);
  }

  static read({required String key}) async {
    if (storage == null) {
      throw "storage is null, init() first";
    }
    return await storage!.read(key: key);
  }

  static delete({required String key}) async {
    if (storage == null) {
      throw "storage is null, init() first";
    }
    return await storage!.delete(key: key);
  }

  static init() {
    XYStoreage._internal();
  }
}

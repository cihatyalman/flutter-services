/* Documents and Integration
https://pub.dev/packages/hive
https://pub.dev/packages/hive_flutter
*/

import 'package:hive_flutter/hive_flutter.dart';

enum HiveKeys {
  count("count"),
  isFirst("is_first"),
  token("token");

  final String title;
  const HiveKeys(this.title);
}

class HiveService {
  static final HiveService instance = HiveService._internal();
  HiveService._internal();

  final String _boxName = "project_box";
  late Box _box;

  Box<dynamic> get box => _box;

  Future init() async {
    await Hive.initFlutter();
    _box = await _openBox();
  }

  Future deleteBox() async {
    try {
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await _openBox();
    } catch (e) {
      return false;
    }
  }

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  dynamic get(HiveKeys key, [dynamic defaultValue]) =>
      _box.get(key.title, defaultValue: defaultValue);

  dynamic put(HiveKeys key, dynamic value) => _box.put(key.title, value);

  dynamic delete(HiveKeys key) => _box.delete(key.title);
}

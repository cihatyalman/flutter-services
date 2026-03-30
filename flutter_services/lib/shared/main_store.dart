import 'package:flutter/material.dart';

import '../services/state_tools/store/exports.dart';
import 'models/user_model.dart';

final mainStore = MainStore.instance;

class MainStore {
  static final MainStore instance = MainStore._internal();
  MainStore._internal();

  Size screenSize = Size.infinite;

  final user = StoreData<UserModel?>.create(null);

  /// pop olmayan bir ekran(until) açıldığında kullan
  void lazyClear() {}

  /// Hesaptan çıkış yapınca kullan
  void clear() {
    user.data = null;

    lazyClear();
  }
}

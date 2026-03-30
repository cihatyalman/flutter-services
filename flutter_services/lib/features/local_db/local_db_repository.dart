import 'package:flutter/foundation.dart';

import '../../services/storage/sqflite.dart';
import 'local_db_store.dart';
import 'local_db_user_model.dart';

class LocalDbRepository {
  static final LocalDbRepository instance = LocalDbRepository._internal();
  LocalDbRepository._internal();

  final _store = LocalDbStore.instance;
  LocalDbStore get store => _store;

  final _dbService = SqfliteService("MockDB");

  final tableName = "user";

  Future<void> init() async {
    _dbService.createTable(
      "CREATE TABLE IF NOT EXISTS $tableName (id integer primary key, username text, age integer)",
    );

    final dbData = await _dbService.getTable(tableName) ?? [];
    final dataList = dbData
        .map((e) => LocalDbUserModel.fromMap(e as Map<String, dynamic>))
        .toList();

    _store.userList.data = dataList;
  }

  Future<void> insertUser(LocalDbUserModel data) async {
    final dbId = await _insertUser(data);
    if (dbId == null) return;
    data.id = dbId;
    _store.userList.add(data);
  }

  Future<void> deleteUser(int id) async {
    final dbId = await _deleteUser(id);
    if (dbId == null) return;
    _store.userList.data.removeWhere((e) => e.id == dbId);
    _store.userList.updateWidget;
  }

  Future<int?> _insertUser(LocalDbUserModel data) async {
    try {
      final id = await _dbService.insert(
        "INSERT INTO $tableName (username, age) VALUES('${data.username}' , ${data.age})",
      );
      return id;
    } catch (e) {
      debugPrint("[C_error]: $e");
      return null;
    }
  }

  Future<int?> _deleteUser(int id) async {
    try {
      await _dbService.delete("DELETE FROM $tableName WHERE id = $id");
      return id;
    } catch (e) {
      debugPrint("[C_error]: $e");
      return null;
    }
  }
}

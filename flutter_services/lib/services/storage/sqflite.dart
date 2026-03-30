/* Documents and Integration
https://pub.dev/packages/sqflite
*/

import 'package:sqflite/sqflite.dart';

class SqfliteService {
  Database? _db;
  final String _dbName;
  SqfliteService(this._dbName);

  Future<Database> get db async => _db ??= await initializeDb(_dbName);

  Future<Database> initializeDb(String dbName) async {
    String dbPath = "${await getDatabasesPath()}/$dbName";
    return await openDatabase(dbPath, version: 1);
  }

  Future<bool?> deleteDb(Database db) async {
    try {
      await deleteDatabase(db.path);
      return true;
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// createTable( "CREATE TABLE IF NOT EXISTS tableName (value1 integer primary key, value2 text, value3 integer)" );
  /// ```
  Future<bool?> createTable(String code) async {
    try {
      await db.then((value) async => await value.execute(code));
      return true;
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// getTable( "tableName" );
  /// ```
  Future<List<Map>?> getTable(String tableName) async {
    try {
      return await db.then((value) async => await value.query(tableName));
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// getFromQuery( "SELECT * FROM tableName" );
  /// ```
  Future<List<Map>?> getFromQuery(String code) async {
    try {
      return await db.then((value) async => await value.rawQuery(code));
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// insert( "INSERT INTO tableName (key1, key2, key3) VALUES(value1 , 'value2', value3)" );
  /// ```
  Future<int?> insert(String code) async {
    try {
      return await db.then((value) async => await value.rawInsert(code));
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// update( "UPDATE tableName SET value2 = 'value22', value3 = value33 WHERE value1 = 1" );
  /// ```
  Future<int?> update(String code) async {
    try {
      return await db.then((value) async => await value.rawUpdate(code));
    } catch (e) {
      return null;
    }
  }

  /// Example Usage :
  /// ```
  /// delete( "DELETE FROM tableName WHERE value1 = 1" );
  /// ```
  Future<int?> delete(String code) async {
    try {
      return await db.then((value) async => await value.rawDelete(code));
    } catch (e) {
      return null;
    }
  }
}

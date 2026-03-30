/* Documents and Integration
https://pub.dev/packages/firebase_core
https://pub.dev/packages/firebase_database
*/

import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService({DatabaseReference? ref}) {
    _baseRef = ref ?? FirebaseDatabase.instance.ref();
  }

  late DatabaseReference _baseRef;

  DatabaseReference get ref => _baseRef;

  Future<bool?> add({
    required String childPath,
    required Map<String, dynamic> json,
  }) async {
    try {
      await _baseRef.child(childPath).set(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> push({
    required String childPath,
    required Map<String, dynamic> json,
  }) async {
    try {
      final r = _baseRef.child(childPath).push();
      await r.update(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> update({
    required String childPath,
    required Map<String, dynamic> json,
  }) async {
    try {
      await _baseRef.child(childPath).update(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<DataSnapshot?> get([String childPath = "/"]) async {
    try {
      return await _baseRef.child(childPath).get();
    } catch (e) {
      return null;
    }
  }

  Future<bool?> delete([String childPath = "/"]) async {
    try {
      await _baseRef.child(childPath).remove();
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> hasChild([String childPath = "/"]) async {
    try {
      var result = await get(childPath);
      return result?.value == null ? false : true;
    } catch (e) {
      return null;
    }
  }
}

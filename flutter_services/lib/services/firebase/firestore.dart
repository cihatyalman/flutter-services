/* Documents and Integration
https://pub.dev/packages/firebase_core
https://pub.dev/packages/cloud_firestore
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  static final instance = FirebaseFirestoreService._internal();
  FirebaseFirestoreService._internal();

  final db = FirebaseFirestore.instance;

  Future<String?> add({
    required String collectionName,
    required Map<String, dynamic> json,
  }) async {
    try {
      var docRef = await db.collection(collectionName).add(json);
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<String?> addToSubCollection({
    required String collectionName,
    required String id,
    required String subCollectionName,
    required Map<String, dynamic> json,
  }) async {
    try {
      var docRef = await db
          .collection(collectionName)
          .doc(id)
          .collection(subCollectionName)
          .add(json);
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> addWithId({
    required String collectionName,
    required String id,
    required Map<String, dynamic> json,
  }) async {
    try {
      await db.collection(collectionName).doc(id).set(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> addWithIdToSubCollection({
    required String collectionName,
    required String id,
    required String subCollectionName,
    required String subId,
    required Map<String, dynamic> json,
  }) async {
    try {
      await db
          .collection(collectionName)
          .doc(id)
          .collection(subCollectionName)
          .doc(subId)
          .set(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<List<DataModel>?> get({required String collectionName}) async {
    try {
      var snapshot = await db.collection(collectionName).get();
      return snapshot.docs
          .map((e) => DataModel(id: e.id, data: e.data()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<DataModel>?> getFromSubCollection({
    required String collectionName,
    required String id,
    required String subCollectionName,
  }) async {
    try {
      var snapshot = await db
          .collection(collectionName)
          .doc(id)
          .collection(subCollectionName)
          .get();
      return snapshot.docs
          .map((e) => DataModel(id: e.id, data: e.data()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<DataModel?> getWithId({
    required String collectionName,
    required String id,
  }) async {
    try {
      var snapshot = await db.collection(collectionName).doc(id).get();
      if (snapshot.data() != null) return null;
      return DataModel(id: snapshot.id, data: snapshot.data()!);
    } catch (e) {
      return null;
    }
  }

  Future<DataModel?> getWithIdFromSubCollection({
    required String collectionName,
    required String id,
    required String subColletionName,
    required String subId,
  }) async {
    try {
      var snapshot = await db
          .collection(collectionName)
          .doc(id)
          .collection(subColletionName)
          .doc(subId)
          .get();
      if (snapshot.data() != null) return null;
      return DataModel(id: snapshot.id, data: snapshot.data()!);
    } catch (e) {
      return null;
    }
  }

  Future<bool?> update({
    required String collectionName,
    required String id,
    required Map<String, dynamic> json,
  }) async {
    try {
      await db.collection(collectionName).doc(id).update(json);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> delete({
    required String collectionName,
    required String id,
  }) async {
    try {
      await db.collection(collectionName).doc(id).delete();
      return true;
    } catch (e) {
      return null;
    }
  }
}

class DataModel {
  final String id;
  final Map<String, dynamic> data;

  DataModel({required this.id, required this.data});

  Map<String, dynamic> toMap({bool withId = false}) =>
      withId ? {"id": id, "data": data} : {"data": data};
}

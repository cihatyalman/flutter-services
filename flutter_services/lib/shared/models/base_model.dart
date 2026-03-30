import 'dart:convert';

import '../../services/toolkit/extensions.dart';

abstract class BaseModel {
  String? id;
  DateTime? createdDatetime;
  DateTime? updatedDatetime;

  BaseModel({this.id, this.createdDatetime, this.updatedDatetime});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (createdDatetime != null) {
      result.addAll({'created_datetime': createdDatetime!.toISOStringUtc});
    }
    if (updatedDatetime != null) {
      result.addAll({'updated_datetime': updatedDatetime!.toISOStringUtc});
    }

    return result;
  }

  // factory BaseModel.fromMap(Map<String, dynamic> map) {
  //   return BaseModel(
  //     id: map['id'],
  //     createdDatetime: (map['created_datetime'] as String?)?.toDateLocal,
  //     updatedDatetime: (map['updated_datetime'] as String?)?.toDateLocal,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory BaseModel.fromJson(String source) =>
  //     BaseModel.fromMap(json.decode(source));
}

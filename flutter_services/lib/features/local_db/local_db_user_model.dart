import 'dart:convert';

class LocalDbUserModel {
  int? id;
  String? username;
  int? age;

  LocalDbUserModel({this.id, this.username, this.age});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (username != null) {
      result.addAll({'username': username});
    }
    if (age != null) {
      result.addAll({'age': age});
    }

    return result;
  }

  factory LocalDbUserModel.fromMap(Map<String, dynamic> map) {
    return LocalDbUserModel(
      id: map['id']?.toInt(),
      username: map['username'],
      age: map['age']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalDbUserModel.fromJson(String source) =>
      LocalDbUserModel.fromMap(json.decode(source));
}

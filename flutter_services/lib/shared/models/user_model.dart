import 'dart:convert';

import '../../services/toolkit/extensions.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  int role;
  String? username;
  String? fullname;
  String? profileImageUrl;
  DateTime? lastLoginDate;

  UserModel({
    super.id,
    super.createdDatetime,
    super.updatedDatetime,
    this.role = 1,
    this.username,
    this.fullname,
    this.profileImageUrl,
    this.lastLoginDate,
  });

  @override
  Map<String, dynamic> toMap() {
    final result = super.toMap();

    result.addAll({'role': role});
    if (username != null) {
      result.addAll({'username': username});
    }
    if (fullname != null) {
      result.addAll({'fullname': fullname});
    }
    if (profileImageUrl != null) {
      result.addAll({'profile_image_url': profileImageUrl});
    }
    if (lastLoginDate != null) {
      result.addAll({'last_login_date': lastLoginDate?.toISOStringUtc});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      createdDatetime: (map['CreatedDatetime'] as String?)?.toDateLocal,
      updatedDatetime: (map['UpdatedDatetime'] as String?)?.toDateLocal,
      role: map['role']?.toInt() ?? 1,
      username: map['username'],
      fullname: map['fullname'],
      profileImageUrl: map['profile_image_url'],
      lastLoginDate: (map['last_login_date'] as String?)?.toDateLocal,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

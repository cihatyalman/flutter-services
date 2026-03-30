import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/firebase/auth.dart';
import '../services/firebase/database.dart';
import '../services/firebase/firestore.dart';
import '../services/firebase/auth_google.dart';
import '../shared/constants/text_constant.dart';
import '../utils/helpers/widget_helper.dart';
import '../widgets/custom/cached_image.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';

class FirebaseScreen extends StatelessWidget {
  static const route = 'FirebaseScreen';

  FirebaseScreen({super.key});

  final space = SizedBox(height: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "Firebase").build(context),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(12).copyWith(bottom: 56),
        children: [
          realtimeDatabaseWidget(),
          space,
          firestoreWidget(),
          space,
          firebaseAuthWidget(),
          space,
          googleAuthWidget(),
        ],
      ),
    );
  }

  Widget titleWidget(String title) {
    return CText(title, isBold: true, size: 16);
  }

  Widget realtimeDatabaseWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Realtime Database"), RealtimeDatabaseDemo()],
      ),
    );
  }

  Widget firestoreWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Firestore"), FirestoreDemo()],
      ),
    );
  }

  Widget firebaseAuthWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Firebase Auth"), FirebaseAuthDemo()],
      ),
    );
  }

  Widget googleAuthWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Google Auth"), GoogleAuthDemo()],
      ),
    );
  }
}

class RealtimeDatabaseDemo extends StatelessWidget {
  RealtimeDatabaseDemo({super.key});

  final databaseService = FirebaseDatabaseService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: databaseService.ref.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return hw.circleLoading();
                if (snapshot.data == null) return hw.emptyWidget();
                final data = snapshot.data!;

                return Column(
                  children: data.snapshot.child("users").children.map((e) {
                    return CText(e.value.toString());
                  }).toList(),
                );
              },
            ),
          ),
          Wrap(
            spacing: 8,
            children: [addButton(), updateButton(), deleteButton()],
          ),
        ],
      ),
    );
  }

  Widget addButton() {
    return CustomButton(
      title: "Ekle",
      onPressed: () async {
        final data = UserModel(id: "user3", username: "User3", age: 23);
        await databaseService.add(
          childPath: "users/${data.id}",
          json: data.toMap(),
        );
      },
    );
  }

  Widget updateButton() {
    return CustomButton(
      title: "Güncelle",
      onPressed: () async {
        final data = UserModel(id: "user3", username: "User3", age: 33);
        await databaseService.update(
          childPath: "users/${data.id}",
          json: data.toMap(),
        );
      },
    );
  }

  Widget deleteButton() {
    return CustomButton(
      title: "Sil",
      onPressed: () async {
        await databaseService.delete("users/user3");
      },
    );
  }
}

class FirestoreDemo extends StatelessWidget {
  FirestoreDemo({super.key});

  final firestoreService = FirebaseFirestoreService.instance;

  final dataListNotifier = ValueNotifier<List<UserModel>>([]);
  final collectionName = "user";

  void init() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: dataListNotifier,
              builder: (_, dataList, _) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: dataList.map((e) {
                    return Center(child: CText(e.toMap().toString()));
                  }).toList(),
                );
              },
            ),
          ),
          Wrap(
            spacing: 8,
            children: [addButton(), updateButton(), deleteButton()],
          ),
        ],
      ),
    );
  }

  void getData() async {
    final r = await firestoreService.get(collectionName: collectionName);
    if (r == null) return;
    dataListNotifier.value = r.map((e) {
      final data = UserModel.fromMap(e.data);
      data.id = e.id;
      return data;
    }).toList();
  }

  int get getRandom => Random().nextInt(9000) + 1000;

  Widget addButton() {
    return CustomButton(
      title: "Ekle",
      onPressed: () async {
        final r = getRandom;
        final data = UserModel(id: "id-$r", username: "User-$r", age: r);
        final id = await firestoreService.addWithId(
          id: data.id!,
          collectionName: collectionName,
          json: data.toMap(),
        );
        if (id == null) return;
        getData();
      },
    );
  }

  Widget updateButton() {
    return CustomButton(
      title: "Güncelle",
      onPressed: () async {
        final length = dataListNotifier.value.length;
        if (length == 0) return;
        final item = dataListNotifier.value[Random().nextInt(length)];
        item.username = "Update-${item.age}";
        final r = await firestoreService.update(
          collectionName: collectionName,
          id: item.id!,
          json: item.toMap(),
        );
        if (r == true) {
          getData();
        }
      },
    );
  }

  Widget deleteButton() {
    return CustomButton(
      title: "Sil",
      onPressed: () async {
        final length = dataListNotifier.value.length;
        if (length == 0) return;
        final item = dataListNotifier.value[Random().nextInt(length)];
        final r = await firestoreService.delete(
          collectionName: collectionName,
          id: item.id!,
        );
        if (r == true) {
          getData();
        }
      },
    );
  }
}

class FirebaseAuthDemo extends StatelessWidget {
  FirebaseAuthDemo({super.key});

  final authService = FirebaseAuthService.instance;
  final userNotifier = ValueNotifier<User?>(null);

  final displayName = "TestUser";
  final photoUrl = TextConstants.randomImageUrl;

  final email = "testuser@gmail.com";
  final newEmail = "testuser+new@gmail.com";
  final password = "sifre123";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(child: userInfoWidget()),
          Wrap(
            spacing: 8,
            children: [
              registerButton(),
              loginButton(),
              logoutButton(),
              deleteButton(),
              verificationButton(),
              changeEmailButton(),
              resetPasswordButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget userInfoWidget() {
    userNotifier.value = authService.currentUser;

    return ValueListenableBuilder<User?>(
      valueListenable: userNotifier,
      builder: (_, user, _) {
        if (user == null) return CText("Giriş Yapılmadı");
        return Row(
          spacing: 8,
          children: [
            SizedBox.square(
              dimension: 56,
              child: CachedImage(imageData: user.photoURL, radius: 100),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText("uid: ${user.uid}"),
                    CText("Email: ${user.email}"),
                    CText("EmailVerified: ${user.emailVerified}"),
                    CText("DisplayName: ${user.displayName}"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget registerButton() {
    return CustomButton(
      title: "Kayıt Ol",
      onPressed: () async {
        final user = await authService.register(
          email: email,
          password: password,
          displayName: displayName,
          photoUrl: photoUrl,
        );
        if (user != null) userNotifier.value = user;
      },
    );
  }

  Widget loginButton() {
    return CustomButton(
      title: "Giriş Yap",
      onPressed: () async {
        final user = await authService.signIn(email: email, password: password);
        if (user != null) userNotifier.value = user;
      },
    );
  }

  Widget logoutButton() {
    return CustomButton(
      title: "Çıkış Yap",
      onPressed: () async {
        final r = await authService.signOut();
        if (r) userNotifier.value = null;
      },
    );
  }

  Widget deleteButton() {
    return CustomButton(
      title: "Hesabı Sil",
      onPressed: () async {
        final r = await authService.delete();
        if (r) userNotifier.value = null;
      },
    );
  }

  Widget verificationButton() {
    return CustomButton(
      title: "E-posta Doğrula*",
      onPressed: () async {
        await authService.sendEmailVerification();
      },
    );
  }

  Widget changeEmailButton() {
    return CustomButton(
      title: "E-posta Değiştir*",
      onPressed: () async {
        await authService.verifyBeforeUpdateEmail(newEmail);
      },
    );
  }

  Widget resetPasswordButton() {
    return CustomButton(
      title: "Şifreyi Sıfırla*",
      onPressed: () async {
        await authService.sendPasswordResetEmail(email);
      },
    );
  }
}

class GoogleAuthDemo extends StatelessWidget {
  GoogleAuthDemo({super.key});

  final authService = GoogleAuthService.instance;
  final userNotifier = ValueNotifier<GoogleSignInAccount?>(null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Expanded(child: userInfoWidget()),
          Wrap(spacing: 8, children: [loginButton(), logoutButton()]),
        ],
      ),
    );
  }

  Widget userInfoWidget() {
    userNotifier.value = authService.currentUser;

    return ValueListenableBuilder<GoogleSignInAccount?>(
      valueListenable: userNotifier,
      builder: (_, user, _) {
        if (user == null) return CText("Giriş Yapılmadı");
        return Row(
          spacing: 8,
          children: [
            SizedBox.square(
              dimension: 56,
              child: CachedImage(imageData: user.photoUrl, radius: 100),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText("Id: ${user.id}"),
                  CText("Email: ${user.email}"),
                  CText("DisplayName: ${user.displayName}"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget loginButton() {
    return CustomButton(
      title: "Giriş Yap",
      onPressed: () async {
        final account = await authService.signIn();
        if (account != null) userNotifier.value = account;
      },
    );
  }

  Widget logoutButton() {
    return CustomButton(
      title: "Çıkış Yap",
      onPressed: () async {
        final r = await authService.signOut();
        if (r) userNotifier.value = null;
      },
    );
  }
}

// #region Model

class BaseModel {
  String? id;

  BaseModel({this.id});

  Map<String, dynamic> toMap() => id != null ? {"id": id} : {};

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    return BaseModel(id: map['id']);
  }

  String toJson() => json.encode(toMap());

  factory BaseModel.fromJson(String source) =>
      BaseModel.fromMap(json.decode(source));
}

class UserModel extends BaseModel {
  String? username;
  int? age;

  UserModel({super.id, this.username, this.age});

  @override
  Map<String, dynamic> toMap({bool withId = false}) {
    final result = withId ? super.toMap() : <String, dynamic>{};

    if (username != null) {
      result.addAll({'username': username});
    }
    if (age != null) {
      result.addAll({'age': age});
    }
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      age: map['age']?.toInt(),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

// #endregion

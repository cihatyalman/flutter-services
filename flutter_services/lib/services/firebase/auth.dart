/* Documents and Integration
https://pub.dev/packages/firebase_core
https://pub.dev/packages/firebase_auth
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  static final FirebaseAuthService instance = FirebaseAuthService._internal();
  FirebaseAuthService._internal() {
    _instance.setLanguageCode("tr");
  }

  final _instance = FirebaseAuth.instance;

  Stream<User?> get stream => _instance.authStateChanges();
  User? get currentUser => _instance.currentUser;

  Future<User?> register({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _instance.currentUser?.updateProfile(
        displayName: displayName,
        photoURL: photoUrl,
      );
      return _instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        debugPrint("[C_firebase_register]: Bu e-posta için hesap zaten var.");
      }
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
    }
    return null;
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        debugPrint(
          "[C_firebase_signin]: Kullanıcı hesabı bir yönetici tarafından devre dışı bırakıldı.",
        );
      }
      if (e.code == 'invalid-credential') {
        debugPrint("[C_firebase_signin]: Geçersiz kimlik bilgisi.");
      } else if (e.code == 'user-not-found') {
        debugPrint(
          "[C_firebase_signin]: Bu e-posta için kullanıcı bulunamadı.",
        );
      } else if (e.code == 'wrong-password') {
        debugPrint(
          "[C_firebase_signin]: Bu kullanıcı için yanlış şifre sağlandı.",
        );
      }
    }
    return null;
  }

  Future<bool> signOut() async {
    try {
      await _instance.signOut();
      return true;
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await _instance.currentUser?.delete();
      return true;
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      await _instance.currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return false;
    }
  }

  Future<bool> verifyBeforeUpdateEmail(String newEmail) async {
    try {
      await _instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
      return true;
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return false;
    }
  }
}

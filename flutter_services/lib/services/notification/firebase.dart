/* Documents and Integration
https://pub.dev/packages/firebase_messaging
https://firebase.flutter.dev/docs/messaging/overview/
https://firebase.flutter.dev/docs/messaging/usage/
*/

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';

class FirebasePushService {
  static final instance = FirebasePushService._internal();
  FirebasePushService._internal();

  Future<String?> init() async {
    final instance = FirebaseMessaging.instance;

    await instance.requestPermission();
    final token = await instance.getToken();
    instance.subscribeToTopic("all");
    debugPrint("[C_Instance_Token]: $token");
    onMessage();
    onMessageOpenedApp();
    onMessageBackground();
    return token;
  }

  // Uygulama açıkken tetiklenir
  void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Edit
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).showSnackBar(_snackBar(message));
    });
  }

  // Uygulama bildirime tıklanarak açıldığında tetiklenir
  void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Edit
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).showSnackBar(_snackBar(message));
    });
  }

  // Uygulama kapalıyken tetiklenir
  void onMessageBackground() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Edit
  }

  SnackBar _snackBar(RemoteMessage data) {
    return SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      content: SizedBox(
        height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              data.data["title"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data.data["body"]),
          ],
        ),
      ),
    );
  }
}

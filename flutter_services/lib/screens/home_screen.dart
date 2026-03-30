import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';
import 'firebase_screen.dart';
import 'location_screen.dart';
import 'media_screen.dart';
import 'notification_screen.dart';
import 'qr_screen.dart';
import 'storage_screen.dart';

class HomeScreen extends StatelessWidget {
  static const route = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "Anasayfa").build(context),
      body: GridView(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.all(12).copyWith(bottom: 56),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 4 / 3,
        ),
        children: [
          itemWidget("Kalıcı Depolama", StorageScreen.route),
          itemWidget("QR", QRScreen.route),
          itemWidget("Konum", LocationScreen.route),
          itemWidget("Medya", MediaScreen.route),
          itemWidget("Firebase", FirebaseScreen.route),
          itemWidget("Local Bildirim", NotificationScreen.route),
        ],
      ),
    );
  }

  Widget itemWidget(String title, String screenName) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => navigatorKey.currentState?.pushNamed(screenName),
      child: Ink(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(blurRadius: 4, offset: Offset(-2, 2), color: Colors.grey),
          ],
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: CText(title.split(" ").join("\n"), isBold: true, size: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../services/notification/local.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';

class NotificationScreen extends StatelessWidget {
  static const route = 'NotificationScreen';

  NotificationScreen({super.key});

  final space = SizedBox(height: 8);

  final notiService = LocalNotificationService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "Local Bildirim").build(context),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(12).copyWith(bottom: 56),
        children: [
          Center(
            child: CText("Aşağıda bir kaç örnek bildirim oluşturulmuştur."),
          ),
          space,
          Divider(),
          space,
          defaultButton(),
          space,
          titleButton(),
          space,
          dateButton(),
          space,
          imageButton(),
          space,
          actionButton(),
        ],
      ),
    );
  }

  Widget titleWidget(String title) {
    return CText(title, isBold: true, size: 16);
  }

  Widget defaultButton() {
    return CustomButton(
      title: "Varsayılan",
      onPressed: () async {
        final r = await notiService.create(
          body: "Sadece açıklama kısmı olan bildirim",
        );
        debugPrint("[C_r]: $r");
      },
    );
  }

  Widget titleButton() {
    return CustomButton(
      title: "Başlık",
      onPressed: () async {
        final r = await notiService.create(
          body: "Başlığı olan bildirim",
          title: "Başlık",
        );
        debugPrint("[C_r]: $r");
      },
    );
  }

  Widget dateButton() {
    return CustomButton(
      title: "Zaman (3sn bekleyin)",
      onPressed: () async {
        final r = await notiService.create(
          body: "3 saniye sonra gönderilen bildirim",
          showDate: DateTime.now().add(Duration(seconds: 3)),
        );
        debugPrint("[C_r]: $r");
      },
    );
  }

  Widget imageButton() {
    return CustomButton(
      title: "Resim",
      onPressed: () async {
        final r = await notiService.create(
          title: "Resimli Bildirim",
          body: "Bildirime basılı tutarak genişlet",
          bigPicture:
              "https://tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg",
        );
        debugPrint("[C_r]: $r");
      },
    );
  }

  Widget actionButton() {
    return CustomButton(
      title: "Buton",
      onPressed: () async {
        final r = await notiService.create(
          title: "Butonlu Bildirim",
          body: "Bildirime basılı tutarak genişlet",
          buttons: [
            NotificationActionButton(key: "btn1", label: "Buton 1"),
            NotificationActionButton(key: "btn2", label: "Buton 2"),
            NotificationActionButton(key: "btn3", label: "Buton 3"),
          ],
        );
        debugPrint("[C_r]: $r");
      },
    );
  }
}

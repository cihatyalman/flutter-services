/* Documents and Integration
https://pub.dev/packages/awesome_notifications

Android:
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>

*/

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotificationService {
  static final instance = LocalNotificationService._internal();
  LocalNotificationService._internal();

  final _noti = AwesomeNotifications();

  AwesomeNotifications get noti => _noti;

  Future<void> init() async {
    await _noti.initialize(null, [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification Channel',
        groupKey: "basic_group",
        defaultColor: Colors.indigo, // primaryColor
        // ledColor: Colors.white,
        // importance: NotificationImportance.Default,
      ),
    ]);

    final isAllowed = await _noti.isNotificationAllowed();
    if (!isAllowed) {
      await _noti.requestPermissionToSendNotifications();
    }
    await listen();
  }

  Future<void> listen() async {
    await _noti.setListeners(
      onActionReceivedMethod:
          AwesomeNotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          AwesomeNotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          AwesomeNotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          AwesomeNotificationController.onDismissActionReceivedMethod,
    );
  }

  Future<int> create({
    int? id,
    String? title,
    required String? body,
    Map<String, String?>? payload,
    String? groupKey,
    NotificationLayout layout = NotificationLayout.Default,
    String? largeIcon,
    String? bigPicture,
    Color? color,
    List<NotificationActionButton>? buttons,
    DateTime? showDate,
    NotificationCategory? category,
  }) async {
    id ??= DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await _noti.createNotification(
      content: NotificationContent(
        channelKey: 'basic_channel',
        id: id,
        title: title,
        body: body,
        payload: payload,
        groupKey: groupKey,
        color: color,
        largeIcon: largeIcon,
        bigPicture: bigPicture,
        category: category,
        notificationLayout: bigPicture != null
            ? NotificationLayout.BigPicture
            : layout,
      ),
      actionButtons: buttons,
      schedule: showDate == null
          ? null
          : NotificationCalendar.fromDate(date: showDate),
    );
    return id;
  }
}

class AwesomeNotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint("[C_notiListenAction]: $receivedAction");
    // if (receivedAction.buttonKeyPressed == "btn1") {
    //   debugPrint("[C_btn1]: Button 1 Clicked");
    // } else if (receivedAction.buttonKeyPressed == "btn2") {
    //   debugPrint("[C_btn2]: Button 2 Clicked");
    // }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // debugPrint("Bildirim oluşturuldu.");
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // debugPrint("Bildirim gösterildi.");
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // debugPrint("Bildirim kapatıldı.");
  }
}

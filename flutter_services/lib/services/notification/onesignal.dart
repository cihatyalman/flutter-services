/* Documents and Integration
https://pub.dev/packages/onesignal_flutter
https://documentation.onesignal.com/docs/flutter-sdk-setup
*/

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static final instance = OneSignalService._internal();
  OneSignalService._internal();

  final onesignalId = "YOUR_ONESIGNAL_ID";

  Future<void> init() async {
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    await OneSignal.consentRequired(false);
    OneSignal.initialize(onesignalId);

    OneSignal.Notifications.clearAll();

    final accepted = await OneSignal.Notifications.requestPermission(true);
    debugPrint("[C_OneSignal_Accepted]: $accepted");
    if (!accepted) return;
    await OneSignal.consentGiven(true);

    OneSignal.User.pushSubscription.addObserver((stateChanges) {
      debugPrint("[C_PlayerId]: ${OneSignal.User.pushSubscription.id}");
    });

    // Foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("[C_OneSignal_Foreground_Title]: ${event.notification.title}");
      debugPrint("[C_OneSignal_Foreground_Body]: ${event.notification.body}");
      debugPrint(
        "[C_OneSignal_Foreground_Data]: ${event.notification.additionalData}",
      );

      event.preventDefault();
    });

    // Opened
    OneSignal.Notifications.addClickListener((openedResult) {
      debugPrint(
        "[C_OneSignal_Opened_Title]: ${openedResult.notification.title}",
      );
      debugPrint(
        "[C_OneSignal_Opened_Body]: ${openedResult.notification.body}",
      );
      debugPrint(
        "[C_OneSignal_Opened_Data]: ${openedResult.notification.additionalData}",
      );

      // final notiData = openedResult.notification.additionalData;
    });
  }

  Future<void> setExternalUserId(String externalUserId) async {
    await removeExternalUserId();
    await OneSignal.login(externalUserId);
  }

  Future<void> removeExternalUserId() async {
    await OneSignal.logout();
  }
}

/* Documents and Integration
https://pub.dev/packages/firebase_core
https://pub.dev/packages/firebase_analytics
*/

import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final instance = FirebaseAnalyticsService._internal();
  FirebaseAnalyticsService._internal();

  /// Tüm ekran görüntülenmelerini loglar
  void screenView({required String screenName}) {
    FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }

  // Example
  // void contentView(String contentName, int? role) {
  //   FirebaseAnalytics.instance.logEvent(
  //     name: contentName,
  //     parameters: {"role": role},
  //   );
  // }
}

import 'dart:io';

import 'package:flutter/material.dart';

import '../services/firebase/analytics.dart';
import '../screens/firebase_screen.dart';
import '../screens/home_screen.dart';
import '../screens/app/splash_screen.dart';
import '../screens/app/main_screen.dart';
import '../screens/location_screen.dart';
import '../screens/media_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/qr_screen.dart';
import '../screens/storage_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    FirebaseAnalyticsService.instance.screenView(
      screenName: settings.name ?? "default",
    );

    switch (settings.name) {
      // #region App Screens
      case SplashScreen.route:
        return _getPageRouteBuilderZero(SplashScreen());
      case MainScreen.route:
        return _getPageRouteBuilderZero(MainScreen(settings: settings));
      // #endregion
      // #region BottomBar Screens
      case HomeScreen.route:
        return _getPageRouteBuilderZero(HomeScreen());
      case ProfileScreen.route:
        return _getPageRouteBuilderZero(ProfileScreen(settings: settings));
      // #endregion
      case StorageScreen.route:
        return _customPageRouteBuilder(StorageScreen());
      case QRScreen.route:
        return _customPageRouteBuilder(QRScreen());
      case LocationScreen.route:
        return _customPageRouteBuilder(LocationScreen());
      case MediaScreen.route:
        return _customPageRouteBuilder(MediaScreen());
      case FirebaseScreen.route:
        return _customPageRouteBuilder(FirebaseScreen());
      case NotificationScreen.route:
        return _customPageRouteBuilder(NotificationScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text("ERROR")),
          ),
        );
    }
  }

  static PageRoute<dynamic> _customPageRouteBuilder(Widget screen) {
    return Platform.isIOS
        ? _getPageRouteBuilder(screen)
        : _getPageRouteBuilderRight(screen);
  }

  static MaterialPageRoute _getPageRouteBuilder(Widget screen) =>
      MaterialPageRoute(builder: (context) => screen);

  static PageRouteBuilder _getPageRouteBuilderZero(Widget screen) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
      );

  static PageRouteBuilder _getPageRouteBuilderRight(Widget screen) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: screen,
          );
        },
      );

  // static PageRouteBuilder _getPageRouteBuilderBottom(Widget screen) =>
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         const begin = Offset(0, 1);
  //         const end = Offset.zero;
  //         const curve = Curves.ease;

  //         final tween =
  //             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //         return SlideTransition(
  //           position: animation.drive(tween),
  //           child: screen,
  //         );
  //       },
  //     );
}

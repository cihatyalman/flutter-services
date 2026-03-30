import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/api/dio.dart';
import 'services/firebase/auth_google.dart';
import 'services/notification/local.dart';
import 'services/storage/hive.dart';
import 'screens/app/splash_screen.dart';
import 'shared/constants/text_constant.dart';
import 'shared/custom_interceptor.dart';
import 'shared/route_generator.dart';
import 'utils/helpers/theme_helper.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final apiService = DioService(
  apiUrl: TextConstants.apiUrl,
  headers: {"Accept": "application/json", "X-Platform": "mobile"},
);

void main() async {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  apiService.setInterceptor((dio) => CustomInterceptor(dio));
  await HiveService.instance.init();
  await Firebase.initializeApp();
  await GoogleAuthService.instance.init();
  await LocalNotificationService.instance.init();
  // ...
  lifecycleInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Services',
        themeMode: ThemeMode.light,
        theme: ht.theme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('tr')],
        locale: const Locale('tr'),
        navigatorKey: navigatorKey,
        initialRoute: SplashScreen.route,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// #region Lifecycle
typedef FutureVoidCallback = Future<void> Function();

class LifecycleEventHandler extends WidgetsBindingObserver {
  final FutureVoidCallback? resumedCallBack;
  final FutureVoidCallback? pausedCallBack;
  final FutureVoidCallback? killedCallBack;

  LifecycleEventHandler({
    this.resumedCallBack,
    this.pausedCallBack,
    this.killedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumedCallBack?.call();
        break;
      case AppLifecycleState.paused:
        await pausedCallBack?.call();
        break;
      case AppLifecycleState.detached:
        await killedCallBack?.call();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}

void lifecycleInit() {
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      resumedCallBack: () async {
        debugPrint("[C_app]: Resume");
      },
      pausedCallBack: () async {
        debugPrint("[C_app]: Pause");
      },
      killedCallBack: () async {
        debugPrint("[C_app]: Kill");
      },
    ),
  );
}

// #endregion

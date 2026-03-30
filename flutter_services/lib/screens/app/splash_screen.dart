import 'package:flutter/material.dart';

import '../../shared/main_store.dart';
import '../../widgets/project/c_text.dart';
import 'main_screen.dart';

class SplashScreen extends StatelessWidget {
  static const route = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mainStore.screenSize = MediaQuery.of(context).size;

    final vm = SplashViewModel();

    vm.startFunction(context);

    return Scaffold(
      body: ValueListenableBuilder<SplashStatusType>(
        valueListenable: vm.statusNotifier,
        builder: (_, value, _) {
          vm.redirect(context, value);
          return body();
        },
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        FlutterLogo(size: 100),
        Center(child: CText("Flutter Services", isBold: true, size: 18)),
      ],
    );
  }
}

enum SplashStatusType { idle, loading, isNotLogin, isLogin }

class SplashViewModel {
  final statusNotifier = ValueNotifier(SplashStatusType.idle);

  void startFunction(BuildContext context) async {
    statusNotifier.value = SplashStatusType.loading;

    await Future.delayed(Duration(seconds: 1));
    statusNotifier.value = SplashStatusType.isLogin;
  }

  void redirect(BuildContext context, SplashStatusType data) {
    if (![SplashStatusType.idle, SplashStatusType.loading].contains(data)) {
      int screenIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.pushReplacementNamed(
          context,
          <SplashStatusType, String>{
            SplashStatusType.isNotLogin: MainScreen.route,
            SplashStatusType.isLogin: MainScreen.route,
          }[data]!,
          arguments: SplashStatusType.isLogin == data
              ? screenIndex
              : SplashStatusType.isNotLogin == data
              ? null
              : data,
        ),
      );
    }
  }
}

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/color_constants.dart';
import '../../shared/route_generator.dart';
import '../home_screen.dart';
import '../profile/profile_screen.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class MainScreen extends StatefulWidget {
  static const route = 'MainScreen';

  final RouteSettings settings;
  const MainScreen({super.key, required this.settings});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // NOT: Ana ekranlarin context degerini ...(BuildContext context) bu sekilde fonsiyonlara gonderme.
  // Navigator.... islemleri hangi contenxt degerini kullanirsa ona gore sayfa route agaci degisir.
  int _currentIndex = 0;

  // #region Edit
  final iconList = [
    Icons.home_rounded,
    Icons.circle_rounded,
    Icons.account_circle_rounded,
  ];
  final screenList = [HomeScreen.route, HomeScreen.route, ProfileScreen.route];
  // #endregion

  @override
  void initState() {
    super.initState();
    setState(() => _currentIndex = (widget.settings.arguments as int?) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: screenList[_currentIndex],
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: ColorConstants.background,
        borderColor: Colors.grey.shade400,
        borderWidth: 1,
        height: 52,
        itemCount: iconList.length,
        tabBuilder: (index, isActive) {
          final color = isActive
              ? ColorConstants.primary.shade800
              : ColorConstants.primary.shade300;
          return Center(child: Icon(iconList[index], color: color));
        },
        gapLocation: GapLocation.none,
        activeIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() => _currentIndex = index);
            _navigatorKey.currentState?.pushReplacementNamed(screenList[index]);
          }
        },
      ),
    );
  }
}

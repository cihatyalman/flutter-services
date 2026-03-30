import 'package:flutter/material.dart';

import '../../shared/constants/color_constants.dart';
import '../../widgets/custom/custom_input.dart';
import 'widget_helper.dart';

final ht = ThemeHelper();

class ThemeHelper {
  final _base = ThemeData.light();

  ThemeData get theme => _base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.primary),
    scaffoldBackgroundColor: ColorConstants.background,
    primaryColor: ColorConstants.primary,
    primaryColorLight: ColorConstants.primary.shade300,
    primaryColorDark: ColorConstants.primary.shade900,
    textTheme: _base.textTheme.apply(fontFamily: "Quicksand"),
    inputDecorationTheme: CustomInput.theme,
    appBarTheme: _base.appBarTheme.copyWith(
      // centerTitle: false,
      titleSpacing: hw.edgePadding,
      actionsPadding: EdgeInsets.only(right: hw.edgePadding * .33),
      shadowColor: Colors.black,
      backgroundColor: ColorConstants.background,
      surfaceTintColor: ColorConstants.background,
      elevation: .5,
      scrolledUnderElevation: 2,
    ),
    floatingActionButtonTheme: _base.floatingActionButtonTheme.copyWith(
      elevation: 2,
      highlightElevation: 2,
      shape: StadiumBorder(),
      backgroundColor: ColorConstants.primary.shade500,
      foregroundColor: Colors.white,
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: Colors.grey.shade400,
    ),
  );
}

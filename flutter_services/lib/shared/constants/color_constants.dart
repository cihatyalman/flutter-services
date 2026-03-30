import 'package:flutter/material.dart';

/// https://uicolors.app/generate/6750a4
class ColorConstants {
  static const background = Colors.white;

  static const _primary = 0xFF6750a4;
  static const primary = MaterialColor(_primary, {
    50: Color(0xFFf1f1fc),
    100: Color(0xFFe6e7f9),
    200: Color(0xFFd2d2f3),
    300: Color(0xFFb8b7ea),
    400: Color(0xFFa199e0),
    500: Color(0xFF8f80d4),
    600: Color(0xFF7e66c5),
    700: Color(_primary),
    800: Color(0xFF59478c),
    900: Color(0xFF4a3f70),
  });

  static const black = MaterialColor(0xFF000000, {
    50: Color(0xFFffffff),
    100: Color(0xFFfafafa),
    200: Color(0xFFf5f5f5),
    300: Color(0xFFe0e0e0),
    400: Color(0xFFbdbdbd),
    500: Color(0xFF9e9e9e),
    600: Color(0xFF757575),
    700: Color(0xFF424242),
    800: Color(0xFF1e1e1e),
    900: Color(0xFF121212),
  });
}

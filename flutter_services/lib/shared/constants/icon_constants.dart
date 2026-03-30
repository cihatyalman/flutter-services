import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconConstants {
  // static const appIconPng = "assets/app/app-icon.png";
}

extension SvgIconExtension on String {
  SvgPicture toSvgIcon({Color? color, double size = 20}) => SvgPicture.asset(
        this,
        width: size,
        height: size,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcATop) : null,
        fit: BoxFit.contain,
      );
}

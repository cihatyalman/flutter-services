import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageConstants {
  // static const logo = "assets/images/logo.svg";
}

extension SvgIconExtension on String {
  SvgPicture toSvgImage({Color? color, double size = 200}) => SvgPicture.asset(
        this,
        width: double.infinity,
        height: size,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcATop) : null,
        fit: BoxFit.contain,
      );
}

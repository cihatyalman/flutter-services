import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  final String? data;
  final double? size;
  final Color? color;
  final bool isBold;
  final TextAlign? textAlign;
  final TextStyle? style;
  final int? maxLines;
  final bool isOverflow;
  final bool isUnderLine;

  const CText(
    this.data, {
    super.key,
    this.size,
    this.color,
    this.isBold = false,
    this.textAlign,
    this.style,
    this.maxLines,
    this.isOverflow = false,
    this.isUnderLine = false,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;

    baseStyle = baseStyle.copyWith(
      color: color,
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : null,
      decoration: isUnderLine ? TextDecoration.underline : null,
      overflow: isOverflow ? TextOverflow.ellipsis : null,
    );

    return AutoSizeText(
      data ?? "",
      textScaleFactor: 1,
      minFontSize: 11,
      textAlign: textAlign,
      maxLines: maxLines,
      style: baseStyle,
    );
  }
}

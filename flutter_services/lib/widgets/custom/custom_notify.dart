import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '../project/c_text.dart';

enum NotifyType { success, warning, error }

class CustomNotify {
  final String? title;
  final String? message;
  final NotifyType? type;
  final TextStyle? style;
  final Function()? onPressed;
  final int durationSeconds;

  CustomNotify({
    this.title,
    required this.message,
    this.type = NotifyType.error,
    this.style,
    this.onPressed,
    this.durationSeconds = 3,
  });

  Future<dynamic> show(BuildContext context) => _build(context).show(context);

  Flushbar _build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.white);

    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      backgroundColor: _getColor(type),
      duration: Duration(seconds: durationSeconds),
      isDismissible: true,
      titleText: title != null
          ? Text(
              title!,
              style: style ?? textStyle!.copyWith(fontWeight: FontWeight.bold),
            )
          : null,
      messageText: CText(message ?? "ERROR", style: style ?? textStyle),
      onTap: (flushbar) {
        onPressed?.call();
      },
    );
  }

  Color _getColor(NotifyType? type) {
    switch (type) {
      case NotifyType.success:
        return Colors.green;
      case NotifyType.warning:
        return Colors.orange;
      case NotifyType.error:
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}

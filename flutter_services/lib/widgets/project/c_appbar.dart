import 'package:flutter/material.dart';

import 'c_text.dart';

class CAppBar {
  String? title;
  Widget? titleWidget;
  bool? centerTitle;
  List<Widget>? actions;

  CAppBar({this.title, this.titleWidget, this.centerTitle, this.actions});

  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? CText(title, isBold: true, size: 22),
      actions: actions,
      centerTitle: centerTitle,
      titleSpacing: Navigator.canPop(context) ? 0 : 12,
    );
  }
}

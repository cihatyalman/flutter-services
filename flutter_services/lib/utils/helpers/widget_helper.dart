import 'package:flutter/material.dart';

import '../../widgets/project/c_text.dart';
import '../mixins/design_mixin.dart';

final hw = WidgetHelper();

class WidgetHelper with DesignMixin {
  final edgePadding = 12.0;
  final bottomPadding = 56.0;

  Widget logoWidget({double size = 140}) {
    return Center(
      child: ClipRRect(
        borderRadius: radius(24),
        child: FlutterLogo(size: size),
      ),
    );
  }

  Widget circleLoading({Color? color, double size = 24, double stroke = 4}) {
    return Center(
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(color: color, strokeWidth: stroke),
      ),
    );
  }

  Widget emptyWidget() {
    return Center(child: Transform.scale(scale: 1.5, child: CText("Empty")));
  }

  Widget divider() => const Divider(height: 8, thickness: .5);

  Widget dividerVertical([double height = 36]) =>
      SizedBox(height: height, child: const VerticalDivider());
}

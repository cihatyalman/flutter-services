import 'package:flutter/material.dart';

/// children or oneWidget
class CustomBottomSheet {
  List<Widget> Function(StateSetter setState)? children;
  Widget Function(StateSetter setState)? oneWidget;
  Widget? titleWidget;
  Color? color;
  double radius;
  bool isDismissible;
  EdgeInsets padding;
  EdgeInsets scrollPadding;
  double maxHeight;
  double dividerSize;
  Color? dividerColor;
  bool isExpanded;

  CustomBottomSheet({
    this.children,
    this.oneWidget,
    this.titleWidget,
    this.color,
    this.radius = 16,
    this.isDismissible = true,
    this.padding = EdgeInsets.zero,
    this.scrollPadding = EdgeInsets.zero,
    this.maxHeight = 300,
    this.dividerSize = 48,
    this.dividerColor,
    this.isExpanded = true,
  }) : assert(!(children == null && oneWidget == null));

  Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: isDismissible,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minWidth: double.infinity,
      ),
      backgroundColor: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dividerSize != 0)
                      Container(
                        width: dividerSize,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8, top: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: dividerColor ?? Colors.black,
                        ),
                      ),
                    if (titleWidget != null) ...[
                      titleWidget!,
                      const Divider(thickness: 1),
                    ],
                    if (oneWidget != null)
                      isExpanded
                          ? Expanded(child: oneWidget!.call(setState))
                          : oneWidget!.call(setState),
                    if (oneWidget == null)
                      isExpanded
                          ? Expanded(
                              child: SingleChildScrollView(
                                padding: scrollPadding,
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: children?.call(setState) ?? [],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: scrollPadding,
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: children?.call(setState) ?? [],
                              ),
                            ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

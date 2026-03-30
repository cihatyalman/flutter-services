import 'package:flutter/material.dart';

import '../custom/custom_bottom_sheet.dart';
import 'c_text.dart';

class CBottomSheet {
  List<CBottomSheetItem> itemList;
  double maxHeight;
  bool isExpanded;

  CBottomSheet({
    required this.itemList,
    this.maxHeight = 300,
    this.isExpanded = false,
  });

  Future show(BuildContext context) {
    return CustomBottomSheet(
      children: (setState) => itemList
          .map(
            (e) => InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 48,
                padding: EdgeInsets.symmetric(vertical: 2),
                child:
                    e.titleWidget ??
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        spacing: 8,
                        children: [e.icon!, CText(e.title, isBold: true)],
                      ),
                    ),
              ),
              onTap: () => e.onTap?.call(),
            ),
          )
          .toList(),
      padding: EdgeInsets.all(12).copyWith(top: 4, bottom: 28),
      dividerColor: Colors.black54,
      color: Colors.white,
      maxHeight: maxHeight,
      isExpanded: isExpanded,
    ).show(context);
  }
}

class CBottomSheetItem {
  Widget? icon;
  String? title;
  Widget? titleWidget;
  void Function()? onTap;

  CBottomSheetItem({this.icon, this.title, this.titleWidget, this.onTap});
}

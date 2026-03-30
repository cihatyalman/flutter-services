import 'package:flutter/material.dart';

import '../services/other/qr.dart';
import '../widgets/custom/custom_bottom_sheet.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';

class QRScreen extends StatelessWidget {
  static const route = 'QRScreen';

  QRScreen({super.key});

  final qrService = QRService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "QR").build(context),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [createQR(), readQRButton(context)],
        ),
      ),
    );
  }

  Widget createQR() {
    final text = "https://github.com/cihatyalman";
    return qrService.createQR(text);
  }

  Widget readQRButton(BuildContext context) {
    return CustomButton(
      title: "QR okut",
      onPressed: () {
        CustomBottomSheet(
          maxHeight: 400,
          titleWidget: CText("QR okut"),
          oneWidget: (setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox.square(
                dimension: 300,
                child: qrService.readQR((barcode) {
                  debugPrint("[C_barcode]: $barcode");
                }),
              ),
            );
          },
        ).show(context);
      },
    );
  }
}

/* Documents and Integration
https://pub.dev/packages/qr_flutter
*https://pub.dev/packages/mobile_scanner

Android:
/android/gradle.properties (Opsiyanel, boyut düşürmek için)
dev.steenbakker.mobile_scanner.useUnbundled=true

IOS:
<key>NSCameraUsageDescription</key>
<string>Bu uygulama, QR kodlarını taramak için kamera erişimine ihtiyaç duyar</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Bu uygulama, fotoğraf kitaplığından QR kodunu almak için fotoğraf erişimine ihtiyaç duyar</string>
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRService {
  Timer? _timer;

  QrImageView createQR(
    String data, {
    QrErrorBuilder? errorStateBuilder,
    double size = 200,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      // gapless: false,
      errorStateBuilder:
          errorStateBuilder ??
          (context, error) {
            return Container(
              alignment: Alignment.center,
              width: size,
              height: size,
              child: Text(
                "[QR_ERROR]\n${error.toString()}",
                textAlign: TextAlign.center,
              ),
            );
          },
    );
  }

  MobileScannerController? controller;
  Widget readQR(void Function(String? barcode) callback) {
    String? barcode;
    String? oldBarcode;
    controller = MobileScannerController();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MobileScanner(
        key: GlobalKey(debugLabel: "QR"),
        overlayBuilder: (context, constraints) => Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        controller: controller,
        onDetect: (barcodes) {
          final tempCode = barcodes.barcodes.last.rawValue;
          if (tempCode != null) {
            barcode = tempCode;
            if (barcode != oldBarcode) {
              callback.call(barcode);
              oldBarcode = barcode;
            }
            barcode = null;
            _timer ??= Timer(const Duration(seconds: 3), () {
              oldBarcode = null;
              _timer = null;
            });
          }
        },
      ),
    );
  }
}

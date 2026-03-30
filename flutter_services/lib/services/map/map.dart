/* Documents and Integration
https://pub.dev/packages/screenshot (Özel marker oluşturmak için gerekli)
*https://pub.dev/packages/google_maps_flutter

Android:
android/app/src/main/AndroidManifest.xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR KEY HERE"/>

IOS:
ios/Runner/AppDelegate.swift
GMSServices.provideAPIKey("YOUR KEY HERE")
*/

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

class MapService extends ChangeNotifier {
  GoogleMapController? _controller;
  final markerListNotifier = ValueNotifier(List<Marker>.empty(growable: true));
  final centerPosNotifier = ValueNotifier<CameraPosition?>(null);

  Widget build({
    required LatLng initialLatLng,
    double initialZoom = 14,
    List<Marker>? markerList,
    void Function(LatLng latLng)? onTap,
    void Function(GoogleMapController controller)? onMapCreated,
    void Function()? onCameraIdle,
    void Function()? onCameraMoveStarted,
    void Function(CameraPosition position)? onCameraMove,
  }) {
    if (markerList != null) {
      markerListNotifier.value = markerList;
    }
    return ValueListenableBuilder<List<Marker>>(
      valueListenable: markerListNotifier,
      builder: (_, value, _) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialLatLng,
            zoom: initialZoom,
          ),
          onMapCreated: (controller) {
            _controller = controller;
            onMapCreated?.call(controller);
          },
          onCameraIdle: onCameraIdle,
          onCameraMoveStarted: onCameraMoveStarted,
          onCameraMove: (position) {
            centerPosNotifier.value = position;
            onCameraMove?.call(position);
          },
          buildingsEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          mapToolbarEnabled: false,
          markers: value.toSet(),
          onTap: onTap,
        );
      },
    );
  }

  void addMarker(Marker marker) {
    markerListNotifier.value.add(marker);
    markerListNotifier.notifyListeners();
  }

  void removeMarker(String markerId) {
    markerListNotifier.value.removeWhere(
      (element) => element.markerId == MarkerId(markerId),
    );
    markerListNotifier.notifyListeners();
  }

  void clearMarkers({String? markerId}) {
    if (markerId != null) {
      markerListNotifier.value.removeWhere(
        (e) => e.markerId.value.startsWith(markerId),
      );
    } else {
      markerListNotifier.value.clear();
    }
    markerListNotifier.notifyListeners();
  }

  void goLocation({required LatLng latLng, double zoom = 14}) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom, tilt: 45),
      ),
    );
  }

  Future<BitmapDescriptor> createMarkerIcon(Widget widget) async {
    try {
      return BitmapDescriptor.bytes(
        await ScreenshotController().captureFromWidget(
          widget,
          delay: Duration.zero,
        ),
      );
    } catch (e) {
      debugPrint("[C_MapError]: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<BitmapDescriptor> createMarkerIconFromAsset(
    String assetName,
  ) async {
    try {
      return BitmapDescriptor.asset(
        ImageConfiguration(
          devicePixelRatio: MediaQuery.of(
            navigatorKey.currentContext!,
          ).devicePixelRatio,
        ),
        assetName,
      );
    } catch (e) {
      debugPrint("[C_MapError]: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  // #region Marker size
  static Future<BitmapDescriptor> createMarkerIconFromAssetWithUI(
    String path, {
    int width = 140,
  }) async {
    try {
      final Uint8List imageData = await _getBytesFromAsset(path, width);
      return BitmapDescriptor.bytes(imageData);
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  // #endregion
}

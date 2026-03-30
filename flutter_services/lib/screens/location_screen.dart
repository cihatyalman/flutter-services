import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../services/map/location.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_input.dart';
import '../widgets/project/c_text.dart';

class LocationScreen extends StatelessWidget {
  static const route = 'LocationScreen';

  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "Konum").build(context),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(12).copyWith(bottom: 56),
        child: SelectionArea(
          child: Column(
            spacing: 12,
            children: [
              getLocationButton(),
              getAddressButton(),
              getLatLngButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLocationButton() {
    final notifier = ValueNotifier<Position?>(null);

    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Position?>(
              valueListenable: notifier,
              builder: (_, value, _) {
                return Center(child: CText(value?.toString() ?? "Konum Yok"));
              },
            ),
          ),
          CustomButton(
            title: "Konum Al",
            onPressed: () async {
              notifier.value = await LocationService.instance.getLocation();
            },
          ),
        ],
      ),
    );
  }

  Widget getAddressButton() {
    final notifier = ValueNotifier<Placemark?>(null);
    final inputCtrl = TextEditingController();

    return Container(
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Placemark?>(
              valueListenable: notifier,
              builder: (_, value, _) {
                return Center(child: CText(value?.toString() ?? "Konum Ara"));
              },
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: CInput(
                    controller: inputCtrl,
                    hintText: "41.0272569, 29.014983299",
                    initialValue: "41.0272569, 29.014983299",
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                  ),
                ),
              ),
              CustomButton(
                minWidth: 40,
                padding: 8,
                titleWidget: Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () async {
                  final ll = inputCtrl.text.trim().split(',');
                  final ll2 = ll.map((e) => double.parse(e)).toList();
                  final l = await LocationService.instance.getAddressFromLatLng(
                    ll2[0],
                    ll2[1],
                  );
                  notifier.value = l?.first;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getLatLngButton() {
    final notifier = ValueNotifier<Location?>(null);
    final inputCtrl = TextEditingController();

    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Location?>(
              valueListenable: notifier,
              builder: (_, value, _) {
                return Center(child: CText(value?.toString() ?? "Adres Ara"));
              },
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: CInput(
                    controller: inputCtrl,
                    hintText: "Üsküdar Eminönü İskelesi",
                    initialValue: "Üsküdar Eminönü İskelesi",
                  ),
                ),
              ),
              CustomButton(
                minWidth: 40,
                padding: 8,
                titleWidget: Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () async {
                  final l = await LocationService.instance.getLatLngFromAddress(
                    inputCtrl.text,
                  );
                  notifier.value = l?.first;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

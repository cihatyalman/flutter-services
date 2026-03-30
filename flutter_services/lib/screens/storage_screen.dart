import 'package:flutter/material.dart';

import '../features/cache/exports.dart';
import '../features/local_db/exports.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';

class StorageScreen extends StatelessWidget {
  static const route = 'StorageScreen';

  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(height: 8);

    return Scaffold(
      appBar: CAppBar(title: "Kalıcı Depolama").build(context),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(12).copyWith(bottom: 56),
        children: [cacheWidget(), space, localDBWidget()],
      ),
    );
  }

  Widget titleWidget(String title) {
    return CText(title, isBold: true, size: 16);
  }

  Widget cacheWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Cache"), CacheDemo()],
      ),
    );
  }

  Widget localDBWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [titleWidget("Local Database"), LocalDatabaseDemo()],
      ),
    );
  }
}

class LocalDatabaseDemo extends StatelessWidget {
  LocalDatabaseDemo({super.key});

  final vm = LocalDbViewModel(repo: LocalDbRepository.instance);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        ListWidget(vm: vm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [addButton(), deleteButton()],
        ),
      ],
    );
  }

  Widget addButton() {
    return CustomButton(
      title: "User Ekle",
      onPressed: () async => await vm.insert(),
    );
  }

  Widget deleteButton() {
    return CustomButton(
      title: "User Sil",
      onPressed: () async => await vm.delete(),
    );
  }
}

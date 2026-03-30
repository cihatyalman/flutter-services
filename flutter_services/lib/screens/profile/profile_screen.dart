import 'package:flutter/material.dart';

import '../../widgets/project/c_appbar.dart';

class ProfileScreen extends StatelessWidget {
  static const route = 'ProfileScreen';

  final RouteSettings settings;
  const ProfileScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "Profil").build(context),
      body: Column(),
    );
  }
}

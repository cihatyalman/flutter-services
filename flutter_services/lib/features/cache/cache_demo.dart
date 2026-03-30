import 'package:flutter/material.dart';

import '../../widgets/custom/custom_button.dart';
import '../../widgets/project/c_text.dart';
import 'cache_repository.dart';
import 'cache_view_model.dart';

class CacheDemo extends StatelessWidget {
  CacheDemo({super.key});

  final vm = CacheViewModel(repo: CacheRepository.instance);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [decrementButton(), countWidget(), incrementButton()],
    );
  }

  Widget countWidget() {
    return SizedBox(
      width: 24,
      child: Center(
        child: vm.store.counter.listen((data, _) {
          return CText(data.toString(), isBold: true, size: 18);
        }),
      ),
    );
  }

  Widget decrementButton() {
    return CustomButton(
      minWidth: 1,
      padding: 8,
      titleWidget: Icon(Icons.remove_rounded, color: Colors.white),
      onPressed: () => vm.decrement(),
    );
  }

  Widget incrementButton() {
    return CustomButton(
      minWidth: 1,
      padding: 8,
      titleWidget: Icon(Icons.add_rounded, color: Colors.white),
      onPressed: () => vm.increment(),
    );
  }
}

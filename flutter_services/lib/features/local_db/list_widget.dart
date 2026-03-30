import 'package:flutter/material.dart';

import '../../utils/helpers/widget_helper.dart';
import '../../widgets/project/c_text.dart';
import 'local_db_user_model.dart';
import 'local_db_view_model.dart';

class ListWidget extends StatelessWidget {
  final LocalDbViewModel vm;
  const ListWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: vm.store.userList.listen((dataList, _) {
        if (dataList.isEmpty) return hw.emptyWidget();
        dataList = dataList.reversed.toList();
        return ListView.separated(
          padding: EdgeInsets.all(8),
          itemCount: dataList.length,
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final data = dataList[index];
            return itemWidget(data);
          },
        );
      }),
    );
  }

  Widget itemWidget(LocalDbUserModel data) {
    return CText(data.toMap().toString());
  }
}

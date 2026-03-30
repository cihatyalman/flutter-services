import 'dart:math';

import 'local_db_repository.dart';
import 'local_db_store.dart';
import 'local_db_user_model.dart';

class LocalDbViewModel {
  final LocalDbRepository repo;
  LocalDbViewModel({required this.repo}) {
    repo.init();
  }

  LocalDbStore get store => repo.store;

  Future<void> insert() async {
    final random = Random().nextInt(900) + 100;
    await repo.insertUser(
      LocalDbUserModel(username: "User$random", age: random),
    );
  }

  Future<void> delete() async {
    final length = repo.store.userList.data.length;
    if (length == 0) return;
    final index = Random().nextInt(length);
    final id = repo.store.userList.getAt(index)?.id;
    if (id != null) await repo.deleteUser(id);
  }
}

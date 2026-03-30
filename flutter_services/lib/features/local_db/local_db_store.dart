import '../../services/state_tools/store/exports.dart';
import 'local_db_user_model.dart';

class LocalDbStore {
  static final LocalDbStore instance = LocalDbStore._internal();
  LocalDbStore._internal();

  final userList = StoreDataList<LocalDbUserModel>([]);
}

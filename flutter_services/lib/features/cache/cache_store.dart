import '../../services/state_tools/store/exports.dart';
import '../../services/storage/hive.dart';

class CacheStore {
  static final CacheStore instance = CacheStore._internal();
  CacheStore._internal();

  final counter = StoreData.create(HiveService.instance.get(HiveKeys.count, 0));
}

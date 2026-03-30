import '../../services/storage/hive.dart';
import 'cache_store.dart';

class CacheRepository {
  static final CacheRepository instance = CacheRepository._internal();
  CacheRepository._internal();

  final _store = CacheStore.instance;
  CacheStore get store => _store;

  void increment() {
    _store.counter.data += 1;
    _updateCache();
  }

  void decrement() {
    _store.counter.data -= 1;
    _updateCache();
  }

  void _updateCache() {
    HiveService.instance.put(HiveKeys.count, _store.counter.data);
  }
}

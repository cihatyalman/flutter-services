import 'cache_repository.dart';
import 'cache_store.dart';

class CacheViewModel {
  final CacheRepository repo;
  CacheViewModel({required this.repo});

  CacheStore get store => repo.store;

  void increment() {
    repo.increment();
  }

  void decrement() {
    repo.decrement();
  }
}

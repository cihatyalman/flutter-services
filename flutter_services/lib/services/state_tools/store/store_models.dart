import 'store_base.dart';

class StoreData<T extends dynamic> extends StoreBase<T> {
  StoreData(super.initialData);

  factory StoreData.create(T initialData) => StoreData<T>(initialData);
}

class StoreList<T extends dynamic> extends StoreBase<List<T>> {
  StoreList(super.initialData);

  factory StoreList.create([List<T>? initialData]) =>
      StoreList<T>(initialData ?? List<T>.empty(growable: true));

  int getIndex(T value) => _getIndex(value);

  T? getAt(int index) {
    try {
      return super.data[index];
    } catch (e) {
      return null;
    }
  }

  void add(T value) {
    super.data.add(value);
    updateWidget;
  }

  void addAll(List<T> value) {
    super.data.addAll(value);
    updateWidget;
  }

  void insert(int index, T value) {
    super.data.insert(index, value);
    updateWidget;
  }

  bool delete(T value) {
    if (value == null) return false;

    final index = _getIndex(value);
    if (index == -1) return false;
    return deleteAt(index);
  }

  bool deleteAt(int index) {
    try {
      super.data.removeAt(index);
      updateWidget;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool updateAt(int index, T value) {
    try {
      super.data[index] = value;
      updateWidget;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool isExist(T value) {
    return _getIndex(value) != -1;
  }

  int _getIndex(T value) {
    final index = super.data.indexWhere((element) => element == value);
    return index;
  }

  void clear() => super.data.clear();

  bool get isEmpty => super.data.isEmpty;
}

class StoreDataList<T extends dynamic> extends StoreBase<List<T>> {
  StoreDataList(super.initialData);

  factory StoreDataList.create([List<T>? initialData]) =>
      StoreDataList<T>(initialData ?? List<T>.empty(growable: true));

  int getIndex(String id) => _getIndex(id);

  T? get(String? id) {
    if (id == null) return null;

    final index = _getIndex(id);
    if (index == -1) return null;
    return getAt(index);
  }

  T? getAt(int index) {
    try {
      return super.data[index];
    } catch (e) {
      return null;
    }
  }

  void add(T value) {
    super.data.add(value);
    updateWidget;
  }

  void addAll(List<T> value) {
    super.data.addAll(value);
    updateWidget;
  }

  void insert(int index, T value) {
    super.data.insert(index, value);
    updateWidget;
  }

  bool delete(String? id) {
    if (id == null) return false;

    final index = _getIndex(id);
    if (index == -1) return false;
    return deleteAt(index);
  }

  bool deleteAt(int index) {
    try {
      super.data.removeAt(index);
      updateWidget;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool update(T value) {
    if (value == null) return false;
    int index = -1;
    try {
      index = _getIndex(value.id);
    } catch (e) {
      index = -1;
    }
    if (index == -1) return false;
    return updateAt(index, value);
  }

  bool updateAt(int index, T value) {
    try {
      super.data[index] = value;
      updateWidget;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool isExist(String id) {
    return _getIndex(id) != -1;
  }

  int _getIndex(String id) {
    int index = -1;
    try {
      index = super.data.indexWhere((element) => element.id == id);
    } catch (e) {
      index = -1;
    }
    return index;
  }

  void clear() => super.data.clear();

  bool get isEmpty => super.data.isEmpty;
}

class StoreDataRef<T> {
  final _data = <String, StoreData<T?>>{};

  void set(String id, StoreData<T> store) {
    _data[id] = store;
  }

  StoreData<T?> get(String? id) {
    if (id == null) return StoreData<T?>(null);
    final tempStore = _data[id];
    if (tempStore != null) return tempStore;
    _data[id] = StoreData<T?>(null);
    return _data[id]!;
  }

  void delete(String id) {
    _data[id]?.dispose();
    _data.remove(id);
  }

  void dispose() {
    for (var store in _data.values) {
      store.dispose();
    }
    _data.clear();
  }
}

class StoreListRef<T> {
  final _data = <String, StoreList<T>>{};

  void set(String id, StoreList<T> store) {
    _data[id] = store;
  }

  StoreList<T> get(String? id) {
    if (id == null) return StoreList(List<T>.empty(growable: true));
    final tempStore = _data[id];
    if (tempStore != null) return tempStore;
    _data[id] = StoreList(List<T>.empty(growable: true));
    return _data[id]!;
  }

  void delete(String id) {
    _data[id]?.dispose();
    _data.remove(id);
  }

  void dispose() {
    for (var store in _data.values) {
      store.dispose();
    }
    _data.clear();
  }
}

class StoreDataListRef<T> {
  final _data = <String, StoreDataList<T>>{};

  void set(String id, StoreDataList<T> store) {
    _data[id] = store;
  }

  StoreDataList<T> get(String? id) {
    if (id == null) return StoreDataList(List<T>.empty(growable: true));
    final tempStore = _data[id];
    if (tempStore != null) return tempStore;
    _data[id] = StoreDataList(List<T>.empty(growable: true));
    return _data[id]!;
  }

  void delete(String id) {
    _data[id]?.dispose();
    _data.remove(id);
  }

  void dispose() {
    for (var store in _data.values) {
      store.dispose();
    }
    _data.clear();
  }
}

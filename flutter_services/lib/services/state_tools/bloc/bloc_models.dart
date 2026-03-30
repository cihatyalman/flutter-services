import 'bloc_base.dart';

class BlocData<T> extends BlocBase<T> {
  BlocData(super.initialData);
}

class BlocList<T extends dynamic> extends BlocBase<List<T>> {
  BlocList(super.initialData);

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
    } catch (e) {
      return false;
    }
    return true;
  }

  bool updateAt(int index, T value) {
    try {
      super.data[index] = value;
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
}

class BlocDataList<T extends dynamic> extends BlocBase<List<T>> {
  BlocDataList(super.initialData);

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
}

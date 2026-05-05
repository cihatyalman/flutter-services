import 'package:flutter/material.dart';

abstract class StoreBase<T> with ChangeNotifier {
  late ValueNotifier<T> _dataListener;
  StoreBase(T initialValue) {
    _dataListener = ValueNotifier<T>(initialValue);
  }

  bool _isLoading = false;

  void get activateLoading {
    _isLoading = true;
    updateWidget;
  }

  void get deactivateLoading {
    if (_isLoading) {
      _isLoading = false;
      updateWidget;
    }
  }

  T get data => _dataListener.value;
  set data(T value) => _dataListener.value = value;

  bool isChanged = false;

  Widget listen(Widget Function(T data, bool isLoading) customWidget) =>
      ValueListenableBuilder<T>(
        valueListenable: _dataListener,
        builder: (_, value, _) => customWidget.call(value, _isLoading),
      );

  void get updateWidget => _dataListener.notifyListeners();

  @override
  void dispose() {
    _dataListener.dispose();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

abstract class BlocBase<T> {
  late T _data;
  BlocBase(T initialData) {
    _data = initialData;
  }

  final _streamController = StreamController<T>.broadcast();
  bool _isLoading = false;

  void get activateLoading {
    _isLoading = true;
    updateWidget;
  }

  void get deactivateLoading {
    _isLoading = false;
    updateWidget;
  }

  T get data => _data;
  set data(T value) {
    _data = value;
    updateWidget;
  }

  Widget listen(
    Widget Function(
      BuildContext context,
      AsyncSnapshot<T> snapshot,
      bool isLoading,
    ) builder,
  ) {
    return StreamBuilder<T>(
      stream: _streamController.stream,
      initialData: _data,
      builder: (context, snapshot) {
        return builder.call(context, snapshot, _isLoading);
      },
    );
  }

  void get updateWidget => _streamController.sink.add(_data);

  Future dispose() async {
    return await _streamController.close();
  }
}

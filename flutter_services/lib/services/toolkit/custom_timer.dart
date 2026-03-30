import 'dart:async';

typedef DurationCallback = void Function(Duration duration);

class CustomTimer {
  Duration totalDuration;
  int periotDuration;

  /// 'periodDuration' is type milliseconds
  CustomTimer({
    this.totalDuration = const Duration(seconds: 10),
    this.periotDuration = 10,
  });

  Timer? _timer;
  var _duration = Duration.zero;
  var _pauseDuration = Duration.zero;
  final _streamController = StreamController<Duration>.broadcast();

  Stream<Duration> get stream => _streamController.stream;
  Duration get currentDuration => _duration;
  bool get isActive => _timer?.isActive ?? false;

  void _reset() {
    _timer?.cancel();
    // _timer = null;
    _duration = Duration.zero;
    _pauseDuration = _duration;
  }

  Future<void> start({
    Duration startDuration = Duration.zero,
    Duration? totalDuration,
  }) async {
    _reset();
    this.totalDuration = totalDuration ?? this.totalDuration;

    _duration = startDuration;
    _timer = Timer.periodic(Duration(milliseconds: periotDuration), (_) {
      _duration += Duration(milliseconds: periotDuration);
      if (_duration.inMilliseconds >= this.totalDuration.inMilliseconds) {
        stop();
        _streamController.sink.add(this.totalDuration);
        return;
      }
      _streamController.sink.add(_duration);
    });
  }

  void pause() {
    _timer?.cancel();
    _pauseDuration = _duration;
    _streamController.sink.add(_pauseDuration);
  }

  void play() {
    start(startDuration: _pauseDuration);
    _pauseDuration = Duration.zero;
  }

  void stop() {
    _reset();
    _streamController.sink.add(_duration);
  }

  void playOrPause({bool? isPlay, Duration? startDuration}) {
    if (startDuration != null && isPlay == true) {
      _pauseDuration = startDuration;
    }
    if (isPlay != null) {
      if (isPlay) {
        play();
      } else {
        pause();
      }
    } else {
      if (_timer?.isActive == true) {
        pause();
      } else {
        play();
      }
    }
  }

  void sinkPosition(bool isComplate) {
    _reset();
    _streamController.sink.add(isComplate ? totalDuration : Duration.zero);
  }

  StreamSubscription<Duration> listen(DurationCallback onData) =>
      _streamController.stream.listen(onData);
}

/* Documents and Integration
https://pub.dev/packages/just_audio
https://pub.dev/packages/record

Android:
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />  (Optional)

IOS:
<key>NSMicrophoneUsageDescription</key>
<string>Bu uygulama ses kaydı yapmak için mikrofon erişimine ihtiyaç duyar.</string>

*/

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class AudioRecordService {
  AudioRecordService({AudioRecorder? controller}) {
    _controller = controller ?? AudioRecorder();
  }

  late AudioRecorder _controller;

  Directory? dir;
  String? recordPath;
  Timer? timer;

  Future<bool> checkPermission() async {
    bool isPermission = false;
    try {
      isPermission = await _controller.hasPermission();
    } catch (e) {
      isPermission = false;
    }
    return isPermission;
  }

  Future<bool> start({
    Duration maxDuration = const Duration(seconds: 30),
    String fileName = "audio.m4a",
    void Function(String? path)? finishCallback,
  }) async {
    dir ??= await getTemporaryDirectory();
    clear();
    final isPermission = await checkPermission();
    if (isPermission) {
      _controller.start(const RecordConfig(), path: "${dir!.path}/$fileName");
      Duration duration = Duration.zero;
      timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
        duration += Duration(milliseconds: 100);
        if (duration.inMilliseconds >= maxDuration.inMilliseconds) {
          recordPath = await stop();
          finishCallback?.call(recordPath);
        }
      });
      return true;
    }
    return false;
  }

  Future<String?> stop() async {
    timer?.cancel();
    timer = null;
    recordPath = await _controller.stop();
    return recordPath;
  }

  Future<void> clear() async {
    await stop();
    recordPath = null;
  }
}

class AudioPlayerService {
  AudioPlayerService({AudioPlayer? controller}) {
    _controller = controller ?? AudioPlayer();
  }

  late AudioPlayer _controller;

  // type: 0:path / 1:url
  Future<Duration?> prepare({
    int type = 0,
    required String path,
    int noOfSamples = 100,
  }) async {
    switch (type) {
      case 0:
        await _controller.setFilePath(path, initialPosition: Duration.zero);
        break;
      case 1:
        await _controller.setUrl(path, initialPosition: Duration.zero);
        break;
    }
    return await _controller.load();
  }

  // type: 0:path / 1:url
  Future<void> play({
    int type = 0,
    required String path,
    Function()? playCallback,
    Function()? finishCallback,
  }) async {
    await stop();

    _controller.play();
    playCallback?.call();
    _controller.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        stop();
        finishCallback?.call();
      }
    });
  }

  Future<void> stop() async {
    await _controller.pause();
    await _controller.seek(Duration.zero);
  }

  Future<void> pause() => _controller.pause();

  Future<void> resume() => _controller.play();

  void dispose() {
    _controller.dispose();
  }

  // type: 0:path / 1:url
  Future<Duration?> getDuration({int type = 0, required String path}) async {
    Duration? duration;
    final tempPlayer = AudioPlayer();
    try {
      switch (type) {
        case 0:
          duration = await tempPlayer.setFilePath(
            path,
            initialPosition: const Duration(days: 1000),
          );
          break;
        case 1:
          duration = await tempPlayer.setUrl(
            path,
            initialPosition: const Duration(days: 1000),
          );
          break;
      }
      duration = await tempPlayer.load();
      tempPlayer.dispose();
    } catch (e) {
      return null;
    }

    return duration;
  }
}

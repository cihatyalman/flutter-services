/* Documents and Integration
https://pub.dev/packages/audio_waveforms

Android:
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />  (Optional)

IOS:
<key>NSMicrophoneUsageDescription</key>
<string>Bu uygulama ses kaydı yapmak için mikrofon erişimine ihtiyaç duyar.</string>

*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioWaveRecordService {
  AudioWaveRecordService({RecorderController? controller}) {
    _controller = controller ?? RecorderController();
  }

  late RecorderController _controller;

  Directory? dir;
  String? recordPath;
  Timer? timer;

  Future<bool> checkPermission() async {
    bool isPermission = false;
    try {
      isPermission = await _controller.checkPermission();
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
      await _controller.record(path: "${dir!.path}/$fileName");
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

  Widget widget({
    Size size = const Size(300, 50),
    double scaleFactor = 100,
    int noOfSamples = 100,
    BoxDecoration? decoration,
  }) {
    if (size.width < 100) size = Size(100, size.height);

    final spacing = (size.width - 6) / noOfSamples;
    final double waveThickness = spacing > 2 ? 2 : spacing - .5;

    return AudioWaveforms(
      recorderController: _controller,
      size: size,
      waveStyle: WaveStyle(
        spacing: spacing,
        waveThickness: waveThickness,
        waveColor: Colors.black,
        showMiddleLine: false,
        extendWaveform: true,
        scaleFactor: scaleFactor,
      ),
      decoration: decoration,
    );
  }
}

class AudioWavePlayerService {
  AudioWavePlayerService({PlayerController? controller}) {
    _controller = controller ?? PlayerController();
  }

  late PlayerController _controller;

  Future<void> prepare({
    // 0:path - 1:url
    int type = 0,
    required String path,
    int noOfSamples = 100,
  }) async {
    if (type == 1) {
      final tempDir = await getTemporaryDirectory();
      http.Response soundRes = await http.get(Uri.parse(path));
      final fileName = path.split('/').last;
      final tempFile = File("${tempDir.path}/$fileName");

      if (soundRes.statusCode == 200) {
        var file = await tempFile.writeAsBytes(soundRes.bodyBytes);
        path = file.path;
      }
    }
    await _controller.preparePlayer(path: path, noOfSamples: noOfSamples);
  }

  Future<void> play({
    // 0:path - 1:url
    int type = 0,
    required String path,
    Function()? finishCallback,
    Function()? playCallback,
  }) async {
    await stop();

    await _controller.setFinishMode(finishMode: FinishMode.pause);
    await _controller.startPlayer();
    playCallback?.call();
    _controller.onCompletion.listen((_) => finishCallback?.call());
  }

  Future<void> stop() async {
    await _controller.pausePlayer();
    await _controller.seekTo(0);
  }

  Future<int> pause() async {
    _controller.pausePlayer();
    return await _getDuration(durationType: 0);
  }

  Future<int> resume() async {
    _controller.startPlayer();
    return await _getDuration(durationType: 0);
  }

  void dispose() {
    _controller.stopPlayer();
    _controller.stopAllPlayers();
    _controller.dispose();
  }

  // 0:current - 1:max
  Future<int> _getDuration({int durationType = 1}) async {
    return await _controller.getDuration(DurationType.values[durationType]);
  }

  Widget widget({
    Size size = const Size(300, 50),
    double scaleFactor = 100,
    int noOfSamples = 100,
    BoxDecoration? decoration,
  }) {
    if (size.width < 100) size = Size(100, size.height);

    final spacing = (size.width - 6) / noOfSamples;
    final double waveThickness = spacing > 2 ? 2 : spacing - .5;

    return AudioFileWaveforms(
      playerController: _controller,
      size: size,
      playerWaveStyle: PlayerWaveStyle(
        spacing: spacing,
        waveThickness: waveThickness,
        showSeekLine: false,
        liveWaveColor: Colors.black,
        fixedWaveColor: Colors.grey,
        scaleFactor: scaleFactor,
      ),
      decoration: decoration,
      waveformType: WaveformType.fitWidth,
    );
  }
}

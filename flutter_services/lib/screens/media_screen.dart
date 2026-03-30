import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

import '../services/media/audio.dart';
import '../services/media/audio_wave.dart';
import '../services/media/file.dart';
import '../services/media/video.dart';
import '../services/toolkit/custom_timer.dart';
import '../utils/helpers/widget_helper.dart';
import '../widgets/custom/cached_image.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/project/c_appbar.dart';
import '../widgets/project/c_text.dart';
import '../widgets/project/camera_bs.dart';

class MediaScreen extends StatelessWidget {
  static const route = 'MediaScreen';

  MediaScreen({super.key});

  final audioWaveDemo = AudioWaveDemo();
  final audioDemo = AudioDemo();

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(height: 12);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        VideoService.instance.stopAllVideo(isBegin: true);
        audioWaveDemo.dispose();
        audioDemo.dispose();
      },
      child: Scaffold(
        appBar: CAppBar(title: "Medya").build(context),
        body: ListView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(12).copyWith(bottom: 56),

          children: [
            CameraDemo(),
            space,
            VideoDemo(),
            space,
            FileDemo(),
            space,
            audioWaveDemo,
            space,
            audioDemo,
          ],
        ),
      ),
    );
  }
}

class CameraDemo extends StatelessWidget {
  CameraDemo({super.key});

  final notifier = ValueNotifier<File?>(null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 8,
        children: [
          CText("Resim", isBold: true, size: 18),
          Expanded(
            child: ValueListenableBuilder<File?>(
              valueListenable: notifier,
              builder: (_, value, _) {
                return CachedImage(isInfinity: true, imageData: value);
              },
            ),
          ),
          CustomButton(
            title: "Resim Yükle",
            onPressed: () {
              CameraBS(
                activeVideo: true,
                callback: (file) {
                  if (file == null) return;
                  notifier.value = file;
                },
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}

class VideoDemo extends StatelessWidget {
  VideoDemo({super.key});

  final videoService = VideoService.instance;

  final urlList = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
  ];

  ChewieController? videoController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 8,
        children: [
          CText("Video", isBold: true, size: 18),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: videoService.videoPreview(sourceData: urlList[0]),
              ),
              CText("Preview"),
            ],
          ),
          Divider(height: 1),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: videoService.videoBuild(
                  sourceData: urlList[1],
                  callback: (controller) {
                    videoController = controller.copyWith(showControls: true);
                    return videoController!;
                  },
                ),
              ),
              CText("Video Player (Chewie)"),
            ],
          ),
        ],
      ),
    );
  }
}

class FileDemo extends StatelessWidget {
  FileDemo({super.key});

  final notifier = ValueNotifier<File?>(null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          CText("Dosya", isBold: true, size: 18),
          Expanded(
            child: ValueListenableBuilder<File?>(
              valueListenable: notifier,
              builder: (_, value, _) {
                return CText(value?.toString() ?? "Dosya yok");
              },
            ),
          ),
          CustomButton(
            title: "Dosya Yükle",
            onPressed: () async {
              final file = await FileService.instance.getFile();
              if (file != null) notifier.value = file;
            },
          ),
        ],
      ),
    );
  }
}

class AudioWaveDemo extends StatelessWidget {
  AudioWaveDemo({super.key});

  final pathNotifier = ValueNotifier<String?>(null);

  final recorder = AudioWaveRecordService();
  final player = AudioWavePlayerService();
  final remotePlayer = AudioWavePlayerService();

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(height: 8);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CText("Ses (Wave)", isBold: true, size: 18),
          space,
          ValueListenableBuilder<String?>(
            valueListenable: pathNotifier,
            builder: (_, path, _) {
              if (path == null) return recordWidget();
              player.prepare(path: path);
              return playerWidget(path);
            },
          ),
          CText("Butona basılı tutarak ses kaydet, sonra dinle"),
          space,
          Divider(),
          space,
          remotePlayerWidget(
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
          ),
          CText("Url üzerinden otomatik indir ve dinle"),
        ],
      ),
    );
  }

  Widget recordWidget() {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return recorder.widget(
                size: Size(constraints.minWidth, 50),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTapDown: (_) async {
            recorder.start(
              finishCallback: (path) {
                if (path != null) pathNotifier.value = path;
              },
            );
          },
          onLongPressEnd: (_) async {
            final path = await recorder.stop();
            if (path != null) pathNotifier.value = path;
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo,
            ),
            child: Icon(Icons.mic_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget playerWidget(String path) {
    final statusNotifier = ValueNotifier<int>(-1);

    return ValueListenableBuilder<int>(
      valueListenable: statusNotifier,
      builder: (_, status, _) {
        final icon = status == 1
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded;

        return Row(
          spacing: 8,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return player.widget(
                    size: Size(constraints.minWidth, 50),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                if (status == -1) {
                  player.play(
                    path: path,
                    finishCallback: () {
                      statusNotifier.value = -1;
                    },
                  );
                  statusNotifier.value = 1;
                } else if (status == 1) {
                  player.pause();
                  statusNotifier.value = 0;
                } else {
                  player.resume();
                  statusNotifier.value = 1;
                }
              },
              onLongPress: () {
                player.stop();
                statusNotifier.value = -1;
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo,
                ),
                child: Icon(icon, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget remotePlayerWidget(String path) {
    final statusNotifier = ValueNotifier(-10);

    return ValueListenableBuilder<int>(
      valueListenable: statusNotifier,
      builder: (_, status, _) {
        final icon = status == -10
            ? Icons.download_rounded
            : status == 1
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded;

        return Row(
          spacing: 8,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return remotePlayer.widget(
                    size: Size(constraints.minWidth, 50),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (status == -10) {
                  statusNotifier.value = -11;
                  await remotePlayer.prepare(path: path, type: 1);
                  statusNotifier.value = -1;
                } else if (status == -1) {
                  remotePlayer.play(
                    path: path,
                    finishCallback: () {
                      statusNotifier.value = -1;
                    },
                  );
                  statusNotifier.value = 1;
                } else if (status == 1) {
                  remotePlayer.pause();
                  statusNotifier.value = 0;
                } else {
                  remotePlayer.resume();
                  statusNotifier.value = 1;
                }
              },
              onLongPress: () {
                if (status == -10) return;
                remotePlayer.stop();
                statusNotifier.value = -1;
              },
              child: IgnorePointer(
                ignoring: status == -11,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo,
                  ),
                  child: status == -11
                      ? hw.circleLoading(color: Colors.white)
                      : Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    player.dispose();
    remotePlayer.dispose();
  }
}

class AudioDemo extends StatelessWidget {
  AudioDemo({super.key});

  final pathNotifier = ValueNotifier<String?>(null);

  final recorder = AudioRecordService();
  final player = AudioPlayerService();
  final remotePlayer = AudioPlayerService();

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(height: 8);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CText("Ses", isBold: true, size: 18),
          space,
          ValueListenableBuilder<String?>(
            valueListenable: pathNotifier,
            builder: (_, path, _) {
              if (path == null) return recordWidget();
              return playerWidget(path);
            },
          ),
          CText("Butona basılı tutarak ses kaydet, sonra dinle"),
          space,
          Divider(),
          space,
          remotePlayerWidget(
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
          ),
          CText("Url üzerinden otomatik indir ve dinle"),
        ],
      ),
    );
  }

  Widget recordWidget() {
    return GestureDetector(
      onTapDown: (_) async {
        recorder.start(
          finishCallback: (path) {
            if (path != null) pathNotifier.value = path;
          },
        );
      },
      onLongPressEnd: (_) async {
        final path = await recorder.stop();
        if (path != null) pathNotifier.value = path;
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.indigo),
        child: Icon(Icons.mic_rounded, color: Colors.white),
      ),
    );
  }

  Widget playerWidget(String path) {
    final statusNotifier = ValueNotifier<int>(-1);

    return FutureBuilder(
      future: player.prepare(path: path),
      builder: (context, snapshot) {
        if (snapshot.data == null) return SizedBox.shrink();
        final totalDuration = snapshot.data!;
        final timer = CustomTimer(
          periotDuration: 10,
          totalDuration: totalDuration,
        );

        return ValueListenableBuilder<int>(
          valueListenable: statusNotifier,
          builder: (_, status, _) {
            final icon = status == 1
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded;

            return Row(
              spacing: 8,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: timer.stream,
                    builder: (context, snapshot) {
                      final timerDuration = snapshot.data ?? Duration.zero;
                      double value = 0;
                      if (timerDuration.inMilliseconds != 0) {
                        value =
                            timerDuration.inMilliseconds /
                            totalDuration.inMilliseconds;
                      }
                      return LinearProgressIndicator(
                        minHeight: 10,
                        value: value,
                        backgroundColor: Colors.black12,
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(12),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (status == -1) {
                      player.play(
                        path: path,
                        finishCallback: () {
                          statusNotifier.value = -1;
                          timer.pause();
                        },
                      );
                      statusNotifier.value = 1;
                      timer.play();
                    } else if (status == 1) {
                      player.pause();
                      statusNotifier.value = 0;
                      timer.pause();
                    } else {
                      player.resume();
                      statusNotifier.value = 1;
                      timer.play();
                    }
                  },
                  onLongPress: () {
                    player.stop();
                    statusNotifier.value = -1;
                    timer.pause();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget remotePlayerWidget(String path) {
    final statusNotifier = ValueNotifier(-1);

    return FutureBuilder(
      future: remotePlayer.prepare(type: 1, path: path),
      builder: (context, snapshot) {
        if (snapshot.data == null) return SizedBox.shrink();
        final totalDuration = snapshot.data!;
        final timer = CustomTimer(
          periotDuration: 100,
          totalDuration: totalDuration,
        );

        return ValueListenableBuilder<int>(
          valueListenable: statusNotifier,
          builder: (_, status, _) {
            final icon = status == 1
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded;

            return Row(
              spacing: 8,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: timer.stream,
                    builder: (context, snapshot) {
                      final timerDuration = snapshot.data ?? Duration.zero;
                      double value = 0;
                      if (timerDuration.inMilliseconds != 0) {
                        value =
                            timerDuration.inMilliseconds /
                            totalDuration.inMilliseconds;
                      }
                      return LinearProgressIndicator(
                        minHeight: 10,
                        value: value,
                        backgroundColor: Colors.black12,
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(12),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (status == -1) {
                      remotePlayer.play(
                        path: path,
                        finishCallback: () {
                          statusNotifier.value = -1;
                          timer.pause();
                        },
                      );
                      statusNotifier.value = 1;
                      timer.start();
                    } else if (status == 1) {
                      remotePlayer.pause();
                      statusNotifier.value = 0;
                      timer.pause();
                    } else {
                      remotePlayer.resume();
                      statusNotifier.value = 1;
                      timer.play();
                    }
                  },
                  onLongPress: () {
                    remotePlayer.stop();
                    statusNotifier.value = -1;
                    timer.pause();
                    timer.sinkPosition(false);
                  },
                  child: IgnorePointer(
                    ignoring: status == -11,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo,
                      ),
                      child: status == -11
                          ? hw.circleLoading(color: Colors.white)
                          : Icon(icon, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void dispose() {
    player.dispose();
    remotePlayer.dispose();
  }
}

/* Documents and Integration
https://pub.dev/packages/video_player
https://pub.dev/packages/chewie
*/

import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum VideoServiceType { network, file, asset }

class VideoService {
  static final VideoService instance = VideoService._internal();
  VideoService._internal();

  static final _cacheVideoController = <String, VideoPlayerController>{};

  Widget placeholder() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(56),
      child: const Icon(Icons.downloading_rounded, color: Colors.grey),
    );
  }

  Widget videoPreview({
    required dynamic sourceData,
    VideoServiceType videoType = VideoServiceType.network,
  }) {
    final cacheKey = _getCacheKey(sourceData);
    if (_cacheVideoController[cacheKey]?.value.isInitialized == true) {
      return _videoWidget(_cacheVideoController[cacheKey]!);
    }
    return FutureBuilder<VideoPlayerController>(
      future: _videoInitialize(sourceData: sourceData, videoType: videoType),
      builder: (context, snapshot) {
        if (snapshot.data == null) return placeholder();
        return _videoWidget(snapshot.data!);
      },
    );
  }

  Widget videoBuild({
    required dynamic sourceData,
    VideoServiceType videoType = VideoServiceType.network,
    ChewieController? customController,
    ChewieController Function(ChewieController controller)? callback,
  }) {
    final cacheKey = _getCacheKey(sourceData);
    if (_cacheVideoController[cacheKey]?.value.isInitialized == true) {
      final controller =
          customController ??
          _getChewieController(_cacheVideoController[cacheKey]!);
      final ctrl = callback?.call(controller) ?? controller;
      return _chewieWidget(ctrl);
    }
    return FutureBuilder(
      future: _videoInitialize(sourceData: sourceData, videoType: videoType),
      builder: (context, snapshot) {
        if (snapshot.data == null) return placeholder();
        final controller =
            customController ?? _getChewieController(snapshot.data!);
        final ctrl = callback?.call(controller) ?? controller;
        return _chewieWidget(ctrl);
      },
    );
  }

  void stopAllVideo({bool isBegin = true}) {
    for (var element in _cacheVideoController.values) {
      element.pause();
      if (isBegin) element.seekTo(Duration.zero);
    }
  }

  void clearCache() {
    _cacheVideoController.clear();
  }

  String _getCacheKey(dynamic sourceData) =>
      sourceData is File ? sourceData.path : sourceData;

  Future<VideoPlayerController> _videoInitialize({
    required dynamic sourceData,
    VideoServiceType videoType = VideoServiceType.network,
  }) async {
    final cacheKey = sourceData is File ? sourceData.path : sourceData;
    if (_cacheVideoController[cacheKey]?.value.isInitialized == true) {
      return _cacheVideoController[cacheKey]!;
    } else if (_cacheVideoController[cacheKey] == null) {
      _cacheVideoController[cacheKey] = _getVideoController(
        videoType,
        sourceData,
      );
    }
    await _cacheVideoController[cacheKey]!.initialize();
    return _cacheVideoController[cacheKey]!;
  }

  VideoPlayerController _getVideoController(
    VideoServiceType videoType,
    dynamic sourceData,
  ) {
    switch (videoType) {
      case VideoServiceType.network:
        return VideoPlayerController.networkUrl(Uri.parse(sourceData));
      case VideoServiceType.file:
        return VideoPlayerController.file(sourceData);
      case VideoServiceType.asset:
        return VideoPlayerController.asset(sourceData);
    }
  }

  Widget _videoWidget(VideoPlayerController controller) {
    return SizedBox(
      width: controller.value.aspectRatio,
      height: 1,
      child: VideoPlayer(
        key: ValueKey(
          "${Random().nextInt(999).toString()}_${controller.dataSource}",
        ),
        controller,
      ),
    );
  }

  ChewieController _getChewieController(VideoPlayerController controller) =>
      ChewieController(
        videoPlayerController: controller,
        aspectRatio: controller.value.aspectRatio,
        allowPlaybackSpeedChanging: false,
        allowedScreenSleep: false,
        showOptions: false,
        showControls: false,
        showControlsOnInitialize: false,
        autoPlay: false,
        looping: false,
      );

  Widget _chewieWidget(ChewieController controller) {
    return SizedBox(
      width: controller.videoPlayerController.value.aspectRatio,
      height: 1,
      child: Chewie(
        key: ValueKey(
          "${Random().nextInt(999).toString()}_${controller.videoPlayerController.dataSource}",
        ),
        controller: controller,
      ),
    );
  }
}

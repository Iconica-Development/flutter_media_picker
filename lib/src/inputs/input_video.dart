// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:mime/mime.dart';

/// Input for video used by [MediaPicker].
class MediaPickerInputVideo implements MediaPickerInput {
  MediaPickerInputVideo({
    this.label = 'Video',
    this.widget,
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
    required this.videoPlayerFactory,
  });

  final Future<MediaResult?> Function()? pickFile;
  final VideoPlayerFactory videoPlayerFactory;

  @override
  Widget? widget;

  @override
  String label;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    var video = await pickFile?.call();

    if (video != null) {
      if (video.mimeType == null || video.mimeType!.isEmpty) {
        video.mimeType = lookupMimeType(
          video.fileName!,
          headerBytes: video.fileValue,
        );
      }
      return video;
    }

    return MediaResult();
  }

  @override
  Future<Widget> displayResult(MediaResult result) async {
    var data = result.fileValue;
    if (data != null) {
      return videoPlayerFactory.createVideoPlayer(data);
    }
    throw FlutterError(
      'Cannot display a video if none was provided. '
      'Make sure the mediaresult contains a fileValue',
    );
  }

  @override
  Map<String, dynamic>? checkPageSettings;

  @override
  void Function(MediaResult value)? onComplete;
}

class VideoResultPlayer extends StatefulWidget {
  const VideoResultPlayer({
    required this.video,
    required this.videoPlayerFactory,
    Key? key,
  }) : super(key: key);

  final Uint8List video;
  final VideoPlayerFactory videoPlayerFactory;

  @override
  State<VideoResultPlayer> createState() => _VideoResultPlayerState();
}

class _VideoResultPlayerState extends State<VideoResultPlayer> {
  @override
  Widget build(BuildContext context) {
    return widget.videoPlayerFactory.createVideoPlayer(widget.video);
  }
}

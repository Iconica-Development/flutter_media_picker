// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_media_picker/src/widgets/icon_button_with_text.dart';

/// Input for video used by [MediaPicker].
class MediaPickerInputVideo implements MediaPickerInput {
  MediaPickerInputVideo({
    this.label = "Video",
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
    required this.videoPlayerFactory,
  }) : icon = IconButtonWithText(icon: Icons.video_camera_front, iconText: label,);

  final Future<Uint8List?> Function()? pickFile;
  final VideoPlayerFactory videoPlayerFactory;

  @override
  String label;

  @override
  Widget icon;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    var image = await pickFile?.call();

    if (image != null && image.isNotEmpty) {
      return MediaResult(
        fileValue: image,
      );
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

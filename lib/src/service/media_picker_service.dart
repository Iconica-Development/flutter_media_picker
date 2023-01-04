// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_media_picker/video_player/video_player_native.dart'
    if (dart.library.html) 'package:media_picker/video_player/video_player_web.dart'
    as vp;
import 'package:video_player/video_player.dart';

class MediaPickerFileService implements MediaPickerService {
  late VideoPlayerController controller;

  @override
  Future<MediaResult?> pickImageFile() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      return MediaResult(
        fileName: image.name,
        mimeType: image.mimeType,
        fileValue: await image.readAsBytes(),
      );
    }
    return Future.value(null);
  }

  @override
  Future<MediaResult?> pickVideoFile() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (video != null) {
      return MediaResult(
        fileName: video.name,
        mimeType: video.mimeType,
        fileValue: await video.readAsBytes(),
      );
    }
    return Future.value(null);
  }

  Future<Widget> videoPlayer(Uint8List video) async {
    await _initialize(video);
    return VideoPlayer(controller);
  }

  _initialize(Uint8List video) async {
    controller = await vp.VideoPlayerWrapper().getController(video);

    await controller.initialize();
    await controller.setLooping(true);
    await controller.play();
  }

  @override
  Future<FilePickerResult?> pickFile(List<String> extensions) async {
    var file = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (file != null) {
      return file;
    }

    return Future.value(null);
  }
}

// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWrapper {
  Future<VideoPlayerController> getController(Uint8List video) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/video.mp4').create();
    file.writeAsBytesSync(video);
    return VideoPlayerController.file(file);
  }
}

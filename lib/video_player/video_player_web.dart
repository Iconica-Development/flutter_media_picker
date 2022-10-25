// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';

class VideoPlayerWrapper {
  Future<VideoPlayerController> getController(Uint8List video) async {
    final blob = Blob([video]);
    final url = Url.createObjectUrlFromBlob(blob);
    return VideoPlayerController.network(url);
  }
}

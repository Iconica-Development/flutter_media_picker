import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/video_player/video_player_native.dart'
    if (dart.library.html) 'package:media_picker/video_player/video_player_web.dart'
    as vp;
import 'package:video_player/video_player.dart';

abstract class VideoPlayerFactory {
  /// Returns a Videoplayer with given [video].
  /// Returns a loading screen if no data is loaded.
  Widget createVideoPlayer(FutureOr<Uint8List> video);
}

class MediaPickerVideoPlayerFactory implements VideoPlayerFactory {
  @override
  Widget createVideoPlayer(FutureOr<Uint8List> video) {
    return MediaPickerVideoPlayer(source: video);
  }
}

class MediaPickerVideoPlayer extends StatefulWidget {
  const MediaPickerVideoPlayer({Key? key, required this.source})
      : super(key: key);

  final FutureOr<Uint8List> source;

  @override
  State<MediaPickerVideoPlayer> createState() => _MediaPickerVideoPlayerState();
}

class _MediaPickerVideoPlayerState extends State<MediaPickerVideoPlayer> {
  late VideoPlayerController _controller;
  late Widget _video = Container(
    color: Colors.black,
    alignment: Alignment.center,
    child: const CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    _loadSource();
  }

  Future<void> _loadSource() async {
    _controller =
        await vp.VideoPlayerWrapper().getController(await widget.source);
    await _controller.initialize();
    await _controller.setLooping(true);
    await _controller.play();

    if (mounted) {
      setState(() {
        _video = VideoPlayer(_controller);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _video,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topLeft,
        children: [
          ...previousChildren,
          if (currentChild != null) currentChild,
        ],
      ),
    );
  }
}

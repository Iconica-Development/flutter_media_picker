import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_picker/src/abstracts/audio_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPickerAudioService implements AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder(
    logLevel: Level.nothing,
  );
  final FlutterSoundPlayer _player = FlutterSoundPlayer(
    logLevel: Level.nothing,
  );
  Directory? _directory;

  @override
  Future<String> setWorkingDirectory() async {
    if (_directory == null) {
      Directory dir = await getTemporaryDirectory();
      _directory = Directory('${dir.path}/audio.mp4');
    }

    return _directory!.path;
  }

  @override
  Future<void> recordStart() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    _recorder.openRecorder();
    if (_recorder.isRecording) {
      await _recorder.resumeRecorder();
    } else {
      await _recorder.startRecorder(
        toFile: _directory!.path,
        codec: Codec.aacMP4,
      );
    }
  }

  @override
  Future<void> recordStop() async {
    _recorder.stopRecorder();
    _recorder.closeRecorder();
  }

  @override
  void playAudio(Uint8List audio) {
    _recorder.closeRecorder();
    _player.openPlayer();
    _player.startPlayer(
      fromURI: _directory!.path,
    );
  }
}

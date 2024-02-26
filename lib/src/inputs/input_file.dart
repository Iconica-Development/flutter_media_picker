// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../flutter_media_picker.dart';

/// Input for file used by [MediaPicker].
class MediaPickerInputFile implements MediaPickerInput {
  /// Label for the file input.
  @override
  String label;

  /// Widget for the file input.
  @override
  Widget? widget;

  /// List of file extensions allowed.
  final List<String> fileExtensions;

  /// Factory for creating video players.
  final VideoPlayerFactory videoPlayerFactory = MediaPickerVideoPlayerFactory();

  /// Service for handling audio operations.
  final AudioService audioService = MediaPickerAudioService();

  /// Callback to pick a file.
  final Future<FilePickerResult?> Function(List<String>)? pickFile;

  /// Constructor for [MediaPickerInputFile].
  MediaPickerInputFile({
    this.label = 'File',
    this.widget,
    this.fileExtensions = const ['pdf', 'jpg', 'png'],
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
  });

  /// Method to handle button press for picking a file.
  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    var filePicked = await pickFile?.call(fileExtensions);
    if (filePicked != null && filePicked.files.first.bytes != null) {
      var file = filePicked.files.first;
      return MediaResult(
        fileValue: file.bytes,
        fileName: file.name,
        mimeType: lookupMimeType(
          file.name,
          headerBytes: file.bytes,
        ),
      );
    }
    return MediaResult();
  }

  /// Method to display the result of picking a file.
  @override
  Future<Widget> displayResult(MediaResult result) async {
    if (result.fileValue != null) {
      var mime = result.mimeType!.split("/").first;
      switch (mime) {
        case 'image':
          return Image.memory(
            result.fileValue!,
          );
        case 'video':
          return videoPlayerFactory.createVideoPlayer(
            result.fileValue!,
          );
        case 'text':
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(result.fileName!),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(String.fromCharCodes(result.fileValue!)),
              )
            ],
          );
        case 'audio':
          return Column(
            children: [
              if (result.fileName != null) ...[
                Text(result.fileName!),
              ],
              ElevatedButton(
                onPressed: () => audioService.playAudio(result.fileValue!),
                child: const Text("Play audio"),
              ),
            ],
          );
        default:
          return Text(result.fileName!);
      }
    }
    return Text(result.fileName!);
  }

  /// Map for checking page settings.
  @override
  Map<String, dynamic>? checkPageSettings;

  /// Callback function when the input is completed.
  @override
  void Function(MediaResult value)? onComplete;
}

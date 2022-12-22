// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';

import 'package:path/path.dart' as path;

import 'package:flutter_media_picker/src/media_result.dart';

import '../../flutter_media_picker.dart';

/// Input for photo used by [MediaPicker].
class MediaPickerInputFile implements MediaPickerInput {
  MediaPickerInputFile({
    this.label = "File",
    this.icon = const Icon(Icons.file_copy),
    this.fileExtensions = const ['pdf', 'jpg', 'png'],
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
  });

  final Future<FilePickerResult?> Function(List<String>)? pickFile;
  final List<String> fileExtensions;

  @override
  String label;

  @override
  Widget icon;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    var file = await pickFile?.call(fileExtensions);

    if (file != null && file.files.first.bytes != null) {
      return MediaResult(
        fileValue: file.files.first.bytes,
        fileType: path.extension(file.files.first.name),
        fileName: file.files.first.name,
      );
    }
    return MediaResult();
  }

  @override
  Future<Widget> displayResult(MediaResult result) async {
    if (result.fileValue != null) {
      switch (result.fileType) {
        case '.png':
        case '.jpg':
        case '.jpeg':
        case '.svg':
        case '.webp':
        case '.bmp':
        case '.gif':
          return Image.memory(
            result.fileValue!,
            height: 250,
          );
        case '.pdf':
        case '.doc':
        case '.docx':
          return Text(result.fileName!);
        case '.txt':
          return const DisplayText();
        default:
      }
    }

    return Container();
  }

  @override
  Map<String, dynamic>? checkPageSettings;

  @override
  void Function(MediaResult value)? onComplete;
}

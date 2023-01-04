// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';

import 'package:flutter_media_picker/src/media_result.dart';
import 'package:mime/mime.dart';

/// Input for photo used by [MediaPicker].
class MediaPickerInputPhoto implements MediaPickerInput {
  MediaPickerInputPhoto({
    this.label = 'Photo',
    this.widget,
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
  });

  final Future<MediaResult?> Function()? pickFile;

  @override
  String label;

  @override
  Widget? widget;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    var image = await pickFile?.call();

    if (image != null) {
      if (image.mimeType == null || image.mimeType!.isEmpty) {
        image.mimeType = lookupMimeType(
          image.fileName!,
          headerBytes: image.fileValue,
        );
      }
      return image;
    }
    return MediaResult();
  }

  @override
  Future<Widget> displayResult(MediaResult result) async {
    if (result.fileValue != null) {
      return Image.memory(
        result.fileValue!,
        height: 250,
      );
    }

    return Container();
  }

  @override
  Map<String, dynamic>? checkPageSettings;

  @override
  void Function(MediaResult value)? onComplete;
}

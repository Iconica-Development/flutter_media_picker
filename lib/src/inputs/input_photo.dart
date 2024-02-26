// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';

import 'package:flutter_media_picker/src/media_result.dart';
import 'package:mime/mime.dart';

/// Input for photo used by [MediaPicker].
class MediaPickerInputPhoto implements MediaPickerInput {
  /// Function to pick a file for photo input.
  final Future<MediaResult?> Function()? pickFile;

  /// Label for the photo input.
  @override
  String label;

  /// Widget representing the photo input.
  @override
  Widget? widget;

  /// Map containing settings to check the page.
  @override
  Map<String, dynamic>? checkPageSettings;

  /// Callback function called when the photo input is completed.
  @override
  void Function(MediaResult value)? onComplete;

  /// Constructor for [MediaPickerInputPhoto].
  ///
  /// [pickFile]: Function to pick a file for photo input.
  /// [label]: Label for the photo input. Defaults to 'Photo'.
  /// [widget]: Widget representing the photo input.
  /// [checkPageSettings]: Map containing settings to check the page.
  /// [onComplete]: Callback function called when the photo input is completed.
  MediaPickerInputPhoto({
    this.pickFile,
    this.label = 'Photo',
    this.widget,
    this.checkPageSettings,
    this.onComplete,
  });

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
}

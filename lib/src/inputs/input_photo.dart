// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';

import 'package:flutter_media_picker/src/media_result.dart';
import 'package:flutter_media_picker/src/widgets/icon_button_with_text.dart';

/// Input for photo used by [MediaPicker].
class MediaPickerInputPhoto implements MediaPickerInput {
  MediaPickerInputPhoto({
    this.label = "Photo",
    Widget? icon,
    this.checkPageSettings,
    this.onComplete,
    this.pickFile,
  }) : icon = icon ?? IconButtonWithText(
          icon: Icons.camera_alt,
          iconText: label,
        );

  final Future<Uint8List?> Function()? pickFile;

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

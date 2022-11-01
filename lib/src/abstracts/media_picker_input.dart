// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/media_result.dart';

/// Abstract class for inputs used by [MediaPicker].
///
/// The [label] is used as the title in the header.
///
/// [onPressed] is called when the user has chosen the input to use.
///
/// [displayResult] is used when the checkpage parameter is set for the [MediaPicker].
/// The widget will be given as [displayResult] within the checkpage parameter.
///
/// [checkPageSettings] are some settings that can be set when needed so they can be used in the checkPage.
///
/// [onComplete] will be called when the user has selected/made the media.
/// If checkpage is set this method will be called when the [onComplete] is called in the checkPage.
abstract class MediaPickerInput {
  String label = "Media Picker input";

  Future<MediaResult> onPressed(BuildContext context);

  Future<Widget> displayResult(MediaResult result);

  Map<String, dynamic>? checkPageSettings;

  void Function(MediaResult result)? onComplete;
}

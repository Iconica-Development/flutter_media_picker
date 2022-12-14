// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/media_result.dart';

/// Abstract class for inputs used by [MediaPicker].
abstract class MediaPickerInput {
  /// The [label] is used as the title for the object in the media picker and no [widget] has been given.
  String label = 'Media Picker input';

  /// The [widget] is the object that is used to show in the media picker where the user can click on.
  Widget? widget;

  /// [onPressed] is called when the user has chosen the input to use.
  Future<MediaResult> onPressed(BuildContext context);

  /// [displayResult] is used when the checkpage parameter is set for the [MediaPicker].
  /// The widget will be given as [displayResult] within the checkpage parameter.
  Future<Widget> displayResult(MediaResult result);

  /// [checkPageSettings] are some settings that can be set when needed so they can be used in the checkPage.
  Map<String, dynamic>? checkPageSettings;

  /// [onComplete] will be called when the user has selected/made the media.
  /// If checkpage is set this method will be called when the [onComplete] is called in the checkPage.
  void Function(MediaResult result)? onComplete;
}

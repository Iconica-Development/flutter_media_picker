// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_form_wizard/flutter_form.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';
import 'package:flutter_media_picker/src/media_result.dart';

/// Input for text used by [MediaPicker].
class MediaPickerInputText implements MediaPickerInput {
  /// Label for the text input.
  @override
  String label;

  /// Widget for the text input.
  @override
  Widget? widget;

  /// Map for checking page settings.
  @override
  Map<String, dynamic>? checkPageSettings;

  /// Callback function when the input is completed.
  @override
  void Function(MediaResult value)? onComplete;

  /// Constructor for [MediaPickerInputText].
  MediaPickerInputText({
    this.label = 'Text',
    this.widget,
    this.checkPageSettings,
    this.onComplete,
  });

  /// Method to handle button press for picking text.
  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    return MediaResult(mimeType: 'plain/text');
  }

  /// Method to display the result of picking text.
  @override
  Future<Widget> displayResult(MediaResult result) async {
    return const DisplayText();
  }
}

/// Widget to display text input.
class DisplayText extends StatefulWidget {
  const DisplayText({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplayTextState();
}

class _DisplayTextState extends State<DisplayText> {
  final FlutterFormInputController<String> _controller =
      FlutterFormInputPlainTextController(
    id: 'title',
  );

  @override
  Widget build(BuildContext context) {
    return FlutterFormInputPlainText(
      label: const Text('Title'),
      controller: _controller,
      validationMessage: 'Field is mandatory',
    );
  }
}

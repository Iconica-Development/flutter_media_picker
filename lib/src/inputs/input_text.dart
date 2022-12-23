// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_media_picker/src/abstracts/media_picker_input.dart';
import 'package:flutter_media_picker/src/media_result.dart';
import 'package:flutter_media_picker/src/widgets/icon_button_with_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Input for text used by [MediaPicker].
class MediaPickerInputText implements MediaPickerInput {
  MediaPickerInputText({
    this.label = "Text",
    this.checkPageSettings,
    this.onComplete,
  }) : icon = IconButtonWithText(
          icon: Icons.text_fields,
          iconText: label,
        );

  @override
  String label;

  @override
  Widget icon;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    return MediaResult();
  }

  @override
  Future<Widget> displayResult(MediaResult result) async {
    return const DisplayText();
  }

  @override
  Map<String, dynamic>? checkPageSettings;

  @override
  void Function(MediaResult value)? onComplete;
}

class DisplayText extends ConsumerStatefulWidget {
  const DisplayText({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisplayTextState();
}

class _DisplayTextState extends ConsumerState<DisplayText> {
  final FlutterFormInputController<String> _controller =
      FlutterFormInputPlainTextController(
    id: 'title',
  );

  @override
  Widget build(BuildContext context) {
    return FlutterFormInputPlainText(
      label: const Text('Titel'),
      controller: _controller,
    );
  }
}

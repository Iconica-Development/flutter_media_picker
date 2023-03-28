// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../flutter_media_picker.dart';

/// [MediaPicker] is a widget that allows the user to select/make media from a variety of sources.
///
/// [mediaPickerInputs] makes it able to choose with types of media the user can select by providing a list of [MediaPickerInput]s.
///
/// By setting header the look of each media type item can be changed.
/// A label is provided which is set by the [MediaPickerInput.title] property.
/// The onpressed should be set so the to select that media type.
/// if null a standard header is used.
///
/// [onComplete] is the callback that will be fired when the medie is made or when the checkpage is completed.
/// With the results provided.
///
/// Via the [mediaCheckPage] a widget can be provided where the user can confirm the media they selected.
/// The displayresult is a widget that shows of the chosen/made media.
/// The inputSettings are settings set per input some media type specifics can be set.
///
/// Example:
/// ```dart
/// Wrap(
///   children: [
///     Container(
///       width: MediaQuery.of(context).size.width,
///       decoration: const BoxDecoration(
///         color: Colors.white,
///         borderRadius: BorderRadius.only(
///           topLeft: Radius.circular(15),
///           topRight: Radius.circular(15),
///         ),
///       ),
///       child: Column(
///         children: [
///           const SizedBox(
///             height: 8,
///           ),
///           Container(
///             width: 70,
///             height: 5,
///             decoration: BoxDecoration(
///               borderRadius: BorderRadius.circular(100),
///               color: const Color(0xFF000000).withOpacity(0.50),
///             ),
///           ),
///           const SizedBox(
///             height: 14,
///           ),
///           const Text(
///             'Maken',
///             style: TextStyle(
///               fontWeight: FontWeight.w900,
///               fontSize: 20,
///             ),
///           ),
///           const SizedBox(
///             height: 15,
///           ),
///           MediaPicker(
///             mediaPickerInputs: [
///               MediaPickerInputPhoto(
///                 checkPageSettings: {'title': 'Foto delen'},
///                 onComplete: (MediaResult result) {},
///               ),
///               MediaPickerInputVideo(
///                 checkPageSettings: {'title': 'Video delen'},
///                 onComplete: (MediaResult result) {},
///               ),
///               if (!kIsWeb)
///                 MediaPickerInputAudio(
///                   checkPageSettings: {'title': 'Audio delen'},
///                   onComplete: (MediaResult result) {},
///                 ),
///               MediaPickerInputText(
///                 checkPageSettings: {'title': 'Tekst delen'},
///                 onComplete: (MediaResult result) {},
///               ),
///             ],
///             mediaCheckPage: (Widget displayResult,
///                     Map<String, dynamic>? inputSettings,
///                     Function onComplete) =>
///                 MediaCheckPage(
///               displayResult: displayResult,
///               inputSettings: inputSettings ?? {},
///               onComplete: onComplete,
///             ),
///           ),
///           const SizedBox(
///             height: 30,
///           ),
///         ],
///       ),
///     ),
///   ],
/// );
///```

class MediaPicker extends StatefulWidget {
  const MediaPicker({
    this.mediaPickerInputs,
    this.inputsDirection = Axis.horizontal,
    this.onComplete,
    this.mediaCheckPage,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
    this.loadingIconColor,
    Key? key,
  }) : super(key: key);

  final List<MediaPickerInput>? mediaPickerInputs;
  final void Function(MediaResult result)? onComplete;
  final Axis inputsDirection;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color? loadingIconColor;
  final Widget Function(
      Widget displayResult,
      Map<String, dynamic>? inputSettings,
      Function(Map<String, dynamic> results) onComplete)? mediaCheckPage;

  @override
  State<StatefulWidget> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<MediaPickerInput> inputs = [
      MediaPickerInputPhoto(),
      MediaPickerInputVideo(
        videoPlayerFactory: MediaPickerVideoPlayerFactory(),
      ),
      if (!kIsWeb)
        MediaPickerInputAudio(
          audioService: MediaPickerAudioService(),
        ),
    ];

    if (widget.mediaPickerInputs != null) {
      inputs = widget.mediaPickerInputs!;
    }

    var theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      direction: widget.inputsDirection,
      spacing: widget.horizontalSpacing,
      runSpacing: widget.verticalSpacing,
      children: [
        if (_isLoading) ...[
          SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(
              color: widget.loadingIconColor ?? theme.primaryColor,
            ),
          ),
        ] else ...[
          for (final input in inputs) ...[
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                await onPressedMediaType(context, input);
              },
              child: Wrap(
                children: [
                  input.widget ??
                      Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF979797),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              input.label,
                              style: theme.textTheme.headline6,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ]
        ]
      ],
    );
  }

  Future<void> onPressedMediaType(
      BuildContext context, MediaPickerInput input) async {
    MediaResult content = await input.onPressed(context);

    if (widget.mediaCheckPage != null &&
        (input.runtimeType == MediaPickerInputText || _hasContent(content))) {
      var checkPage = widget.mediaCheckPage!(
        await input.displayResult(content),
        input.checkPageSettings,
        (Map<String, dynamic> results) {
          MediaResult result = MediaResult(
            fileValue: content.fileValue,
            textValue: content.textValue,
            mimeType: content.mimeType,
            checkPageResults: results,
          );

          if (input.onComplete != null) {
            input.onComplete!(result);
          }

          if (widget.onComplete != null) {
            widget.onComplete!(result);
          }
        },
      );

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => checkPage,
        ),
      );
    } else {
      if (input.onComplete != null) {
        input.onComplete!(content);
      }

      if (widget.onComplete != null) {
        widget.onComplete!(content);
      }
    }
  }

  bool _hasContent(MediaResult content) {
    return content.fileValue != null || content.textValue != null;
  }
}

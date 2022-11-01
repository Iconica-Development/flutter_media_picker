// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
class MediaPicker extends ConsumerWidget {
  const MediaPicker({
    this.mediaPickerInputs,
    this.header,
    this.onComplete,
    this.mediaCheckPage,
    Key? key,
  }) : super(key: key);

  final List<MediaPickerInput>? mediaPickerInputs;
  final Widget Function(String label, Function onPressed)? header;
  final void Function(MediaResult result)? onComplete;
  final Widget Function(
      Widget displayResult,
      Map<String, dynamic>? inputSettings,
      Function(Map<String, dynamic> results) onComplete)? mediaCheckPage;

  @override
  Widget build(BuildContext context, ref) {
    List<MediaPickerInput> inputs = [
      MediaPickerInputPhoto(),
      MediaPickerInputVideo(
        videoPlayerFactory: ref.read(videoFactoryProvider),
      ),
      if (!kIsWeb)
        MediaPickerInputAudio(
          audioService: ref.read(audioPlayerServiceProvider),
        ),
    ];

    if (mediaPickerInputs != null) {
      inputs = mediaPickerInputs!;
    }

    return Column(
      children: [
        for (final input in inputs) ...[
          const SizedBox(height: 2.5),
          header?.call(input.label, (BuildContext ct) async {
                await onPressedMediaType(ct, input);
              }) ??
              GestureDetector(
                onTap: () async {
                  await onPressedMediaType(context, input);
                },
                child: Container(
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
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 2.5),
        ],
      ],
    );
  }

  Future<void> onPressedMediaType(
      BuildContext context, MediaPickerInput input) async {
    MediaResult content = await input.onPressed(context);

    if (mediaCheckPage != null &&
        (input.runtimeType == MediaPickerInputText || _hasContent(content))) {
      var checkPage = mediaCheckPage!(
        await input.displayResult(content),
        input.checkPageSettings,
        (Map<String, dynamic> results) {
          MediaResult result = MediaResult(
            fileValue: content.fileValue,
            textValue: content.textValue,
            checkPageResults: results,
          );

          if (input.onComplete != null) {
            input.onComplete!(result);
          }

          if (onComplete != null) {
            onComplete!(result);
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

      if (onComplete != null) {
        onComplete!(content);
      }
    }
  }

  bool _hasContent(MediaResult content) {
    return content.fileValue != null || content.textValue != null;
  }
}

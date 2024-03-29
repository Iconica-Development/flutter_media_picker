// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:example/media_picker_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

class MediaPickerExample extends StatefulWidget {
  const MediaPickerExample({required this.callback, Key? key})
      : super(key: key);
  final Function callback;

  @override
  State<StatefulWidget> createState() => _MediaPickerExampleState();
}

class _MediaPickerExampleState extends State<MediaPickerExample> {
  @override
  Widget build(BuildContext context) {
    var mediaService = MediaPickerFileService();
    var audioService = MediaPickerAudioService();
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF000000).withOpacity(0.50),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Create/Pick',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MediaPicker(
                loadingIconColor: Theme.of(context).colorScheme.secondary,
                mediaPickerInputs: [
                  MediaPickerInputPhoto(
                    label: 'Make photo',
                    // widget: const IconButtonWithText(
                    //   icon: Icons.photo,
                    //   iconText: "Make photo",
                    // ),
                    pickFile: mediaService.pickImageFile,
                    checkPageSettings: {
                      'title': 'Share photo',
                      'width': 125.0,
                      'height': 200.0,
                    },
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                  MediaPickerInputVideo(
                    label: 'Make video',
                    // widget: const IconButtonWithText(
                    //   icon: Icons.video_camera_front,
                    //   iconText: "Make video",
                    // ),
                    pickFile: mediaService.pickVideoFile,
                    videoPlayerFactory: MediaPickerVideoPlayerFactory(),
                    checkPageSettings: {
                      'title': 'Share video',
                      'width': 122.5,
                      'height': 200.0,
                    },
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                  if (!kIsWeb)
                    MediaPickerInputAudio(
                      label: 'Record audio',
                      // widget: const IconButtonWithText(
                      //   icon: Icons.record_voice_over,
                      //   iconText: "Record audio",
                      // ),
                      checkPageSettings: {'title': 'Share audio'},
                      onComplete: (MediaResult result) =>
                          Navigator.pop(context),
                      inputStyling: AudioInputStyling(
                        leftButton: (_, __) => GestureDetector(
                          onTap: () async => Navigator.pop(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Back',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                      audioService: audioService,
                    ),
                  MediaPickerInputText(
                    label: 'Write text',
                    // widget: const IconButtonWithText(
                    //   icon: Icons.text_fields,
                    //   iconText: "Write text",
                    // ),
                    checkPageSettings: {'title': 'Share text'},
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                  MediaPickerInputFile(
                    label: 'Select file',
                    // widget: const IconButtonWithText(
                    //   icon: Icons.file_copy,
                    //   iconText: "Select file",
                    // ),
                    pickFile: mediaService.pickFile,
                    fileExtensions: [
                      'pdf',
                      'doc',
                      'png',
                      'jpg',
                      'docx',
                      'bmp',
                      'gif',
                      'txt',
                      'mp4',
                      'mp3',
                    ],
                    checkPageSettings: {
                      'title': 'Share file',
                      'height': 200.0,
                    },
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                ],
                mediaCheckPage: (Widget displayResult,
                        Map<String, dynamic>? inputSettings,
                        Function onComplete) =>
                    MediaCheckPage(
                  cancel: widget.callback,
                  displayResult: displayResult,
                  inputSettings: inputSettings ?? {},
                  onComplete: onComplete,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

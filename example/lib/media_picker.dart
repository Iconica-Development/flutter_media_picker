import 'package:example/media_picker_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MediaPickerPage extends ConsumerStatefulWidget {
  const MediaPickerPage({required this.callback, Key? key}) : super(key: key);
  final Function callback;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaPickerState();
}

class _MediaPickerState extends ConsumerState<MediaPickerPage> {
  @override
  Widget build(BuildContext context) {
    var mediaService = ref.read<MediaPickerService>(mediaPickerServiceProvider);
    var audioService = ref.read<AudioService>(audioPlayerServiceProvider);
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
                'Maken',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MediaPicker(
                mediaPickerInputs: [
                  MediaPickerInputPhoto(
                    pickFile: mediaService.pickImageFile,
                    checkPageSettings: {
                      'title': 'Foto delen',
                      'width': 125.0,
                      'height': 200.0,
                    },
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                  MediaPickerInputVideo(
                    pickFile: mediaService.pickVideoFile,
                    videoPlayerFactory: MediaPickerVideoPlayerFactory(),
                    checkPageSettings: {
                      'title': 'Video delen',
                      'width': 122.5,
                      'height': 200.0,
                    },
                    onComplete: (MediaResult result) {
                      Navigator.pop(context);
                    },
                  ),
                  if (!kIsWeb)
                    MediaPickerInputAudio(
                      checkPageSettings: {'title': 'Audio delen'},
                      onComplete: (MediaResult result) {
                        Navigator.pop(context);
                      },
                      audioService: audioService,
                    ),
                  MediaPickerInputText(
                    checkPageSettings: {'title': 'Tekst delen'},
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

// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Input for audio used by [MediaPicker].
///
/// This feature is only usable for native applications.
class MediaPickerInputAudio implements MediaPickerInput {
  MediaPickerInputAudio({
    this.label = 'Audio',
    this.widget,
    this.checkPageSettings,
    this.onComplete,
    required this.audioService,
    this.inputStyling,
  });

  final AudioService audioService;

  final AudioInputStyling? inputStyling;

  @override
  String label;

  @override
  Widget? widget;

  @override
  Future<MediaResult> onPressed(BuildContext context) async {
    MediaResult audio = MediaResult();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Recorder(
          audioService: audioService,
          onComplete: (MediaResult content) {
            if (content.fileValue != null) {
              content.mimeType = 'audio/mpeg';
              audio = content;
            } else {
              throw Exception('No recording returned');
            }
          },
          inputStyling: inputStyling ?? AudioInputStyling(),
        ),
      ),
    );

    return audio;
  }

  @override
  Future<Widget> displayResult(MediaResult result) async {
    var data = result.fileValue;
    if (data != null) {
      Column(
        children: [
          if (result.fileName != null) ...[
            Text(result.fileName!),
          ],
          ElevatedButton(
            onPressed: () => audioService.playAudio(data),
            child: const Text("Play audio"),
          ),
        ],
      );
    }

    return Container();
  }

  @override
  Map<String, dynamic>? checkPageSettings;

  @override
  void Function(MediaResult value)? onComplete;
}

class Recorder extends ConsumerStatefulWidget {
  const Recorder({
    required this.onComplete,
    required this.audioService,
    required this.inputStyling,
    Key? key,
  }) : super(key: key);

  final void Function(MediaResult value) onComplete;
  final AudioService audioService;

  final AudioInputStyling inputStyling;

  @override
  ConsumerState<Recorder> createState() => _RecorderState();
}

class _RecorderState extends ConsumerState<Recorder> {
  final Clock clock = Clock();
  String? directory;

  bool recording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.inputStyling.background ??
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    radius: 2,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFCCCCCC),
                    ],
                  ),
                ),
              ),
          Center(
            child: FutureBuilder<String>(
              future: widget.audioService.setWorkingDirectory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  directory = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.inputStyling.pageContent != null)
                        widget.inputStyling.pageContent!,
                      StreamBuilder(
                        stream: Stream.periodic(
                          recording
                              ? const Duration(milliseconds: 1000)
                              : const Duration(hours: 1),
                        ),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('mm:ss').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                clock.getCurrentTime(),
                              ),
                            ),
                            style: widget.inputStyling.timeTextStyle ??
                                Theme.of(context).textTheme.headline5,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          widget.inputStyling.playButton?.call(
                                recording,
                                playOnTap,
                              ) ??
                              SizedBox(
                                width: 82,
                                height: 82,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFF0F0F0),
                                              Color(0xFFC6C6C6),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFC6C6C6),
                                                  Color(0xFFF0F0F0),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: IconButton(
                                        iconSize: 65,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 30,
                                        onPressed: () {
                                          playOnTap();
                                        },
                                        icon: Icon(
                                          recording
                                              ? Icons.pause
                                              : Icons.play_arrow_rounded,
                                          color: const Color(0xFF4C4C4C),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          widget.inputStyling.nextButton != null
                              ? Expanded(
                                  child: Center(
                                    child: widget.inputStyling.nextButton!.call(
                                      recording,
                                      nextOnTap,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        nextOnTap();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD8D8D8),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Next',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  playOnTap() {
    if (recording) {
      widget.audioService.recordStop();

      clock.stopClock();

      setState(() {
        recording = false;
      });
    } else {
      widget.audioService.recordStart();

      clock.startClock();

      setState(() {
        recording = true;
      });
    }
  }

  nextOnTap() async {
    widget.audioService.recordStop();

    widget.onComplete(
      MediaResult(
        fileValue: await File(directory!).readAsBytes(),
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

/// Used by [MediaPickerInputAudio] to set styling options.
///
/// background can be set to determine the background of the page.
///
/// pageContent can be set to set any widget at the top of the page.
///
/// timeTextStyle sets the [TextStyle] of the time that shows the recording duration. Defaults to headline5.
///
/// playButton changes the default play/pause button.
///
/// nextButton changes the default next/finish button.
class AudioInputStyling {
  AudioInputStyling({
    this.background,
    this.pageContent,
    this.timeTextStyle,
    this.playButton,
    this.nextButton,
  });

  /// background can be set to determine the background of the page.
  final Widget? background;

  /// pageContent can be set to set any widget at the top of the page.
  final Widget? pageContent;

  /// timeTextStyle sets the [TextStyle] of the time that shows the recording duration. Defaults to headline5.
  final TextStyle? timeTextStyle;

  /// playButton changes the default play/pause button.
  final Widget Function(bool recording, Function onTap)? playButton;

  /// nextButton changes the default next/finish button.
  final Widget Function(bool recording, Function onTap)? nextButton;
}

/// Generic clock class can be created and used to keep the time.
class Clock {
  /// [startTime] indiciates the starting time of the clock
  DateTime startTime = DateTime.now();

  /// [endTime] indicates the end time of the clock
  DateTime? endTime = DateTime.now();

  int _millisecondsfromEpoch = 0;

  /// [startClock] can be called to start the clock and count up from [startTime]
  void startClock() {
    startTime = DateTime.now();
    endTime = null;
  }

  /// [stopClock] can be called to stop the clock and saves the difference from [startTime] and [endTime]
  void stopClock() {
    endTime = DateTime.now();
    _millisecondsfromEpoch +=
        endTime!.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
  }

  /// [getCurrentTime] can be called to get the difference between [startTime] and [endTime] in milliseconds
  int getCurrentTime() {
    if (endTime != null) {
      return _millisecondsfromEpoch;
    } else {
      return DateTime.now().millisecondsSinceEpoch -
          startTime.millisecondsSinceEpoch +
          _millisecondsfromEpoch;
    }
  }
}

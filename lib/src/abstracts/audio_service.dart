// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

abstract class AudioService {
  /// creates a temporary path for recording [audio] and returns that path;
  Future<String> setWorkingDirectory();

  /// starts recording [audio].
  /// if recording was paused it resumes the current recording.
  Future<void> recordStart();

  /// Stops the current [audio] recording.
  Future<void> recordStop();

  /// Starts playing the given [Uint8List] as [audio].
  void playAudio(Uint8List audio);
}

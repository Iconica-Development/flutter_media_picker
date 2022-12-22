// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

abstract class MediaPickerService {
  /// Returns [Uint8List] based on given [ImageSource].
  Future<Uint8List?> pickImageFile();

  /// Returns [Uint8List] based on given [VideoSource].
  Future<Uint8List?> pickVideoFile();

  /// Returns [Uint8List] based on given [File].
  Future<Uint8List?> pickFile();
}

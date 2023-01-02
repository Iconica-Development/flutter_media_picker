// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

abstract class MediaPickerService {
  /// Returns [Uint8List] based on given [ImageSource].
  Future<Uint8List?> pickImageFile();

  /// Returns [Uint8List] based on given [VideoSource].
  Future<Uint8List?> pickVideoFile();

  /// Returns [FilePickerResult] based on given [File].
  Future<FilePickerResult?> pickFile(List<String> fileExtensions);
}

// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

abstract class MediaPickerService {
  /// Returns [MediaResult] based on given [ImageSource].
  Future<MediaResult?> pickImageFile();

  /// Returns [Uint8List] based on given [VideoSource].
  Future<MediaResult?> pickVideoFile();

  /// Returns [FilePickerResult] based on given [File].
  Future<FilePickerResult?> pickFile(List<String> fileExtensions);
}

// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:typed_data';

/// MediaResult is a model that is used to return the media selected/media with the [MediaPicker].
class MediaResult {
  MediaResult({
    this.textValue,
    this.fileValue,
    this.checkPageResults,
    this.mimeType,
    this.fileName,
  });

  /// For textfield returns actual text,
  /// for all other types returns description of the media or null
  final String? textValue;

  /// Return file, is null for textfields
  final Uint8List? fileValue;

  /// Returns the values from the checkPageResults if checkpage is set.
  final Map<String, dynamic>? checkPageResults;

  /// Returns the mime type of the file.
  String? mimeType;

  /// Returns the file name when a file is selected with the FilePicker.
  String? fileName;
}

import 'dart:typed_data';

/// MediaResult is a model that is used to return the media selected/media with the [MediaPicker].
class MediaResult {
  MediaResult({
    this.textValue,
    this.fileValue,
    this.checkPageResults,
  });

  /// For textfield returns actual text,
  /// for all other types returns description of the media or null
  final String? textValue;

  /// Return file, is null for textfields
  final Uint8List? fileValue;

  /// Returns the values from the checkPageResults if checkpage is set.
  final Map<String, dynamic>? checkPageResults;
}

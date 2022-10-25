import 'dart:typed_data';

abstract class MediaPickerService {
  /// Returns [Uint8List] based on given [ImageSource].
  Future<Uint8List?> pickImageFile();

  /// Returns [Uint8List] based on given [VideoSource].
  Future<Uint8List?> pickVideoFile();
}

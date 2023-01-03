// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

library flutter_media_picker;

export './src/abstracts/abstracts.dart';
export './src/inputs/inputs.dart';
export './src/service/services.dart';
export './src/media_result.dart';
export './src/media_picker.dart';

import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mediaPickerServiceProvider = Provider<MediaPickerService>(
  (ref) => MediaPickerFileService(),
);

final videoFactoryProvider = Provider<VideoPlayerFactory>(
  (ref) => MediaPickerVideoPlayerFactory(),
);

final audioPlayerServiceProvider = Provider<AudioService>(
  (ref) => MediaPickerAudioService(),
);

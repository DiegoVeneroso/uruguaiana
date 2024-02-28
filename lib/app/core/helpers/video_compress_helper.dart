import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressHelper {
  static Future<MediaInfo?> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);
      return VideoCompress.compressVideo(file.path,
          quality: VideoQuality.LowQuality,
          includeAudio: true,
          deleteOrigin: true);
    } catch (e) {
      debugPrint(e.toString());
    }
    VideoCompress.cancelCompression();
    return null;
  }
}

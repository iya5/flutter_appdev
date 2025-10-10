import 'package:flutter/material.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import '/pages/activity1/song_model.dart';

class MusicPlayerBackground {
  static Future<void> updateFromSong(Song song) async {
    final picture = song.metadata.picture;

    // 🖼 No album art → fallback to black
    if (picture == null) {
      ColorPalette.musicPlayerBG = const Color(0xFF000000);
      return;
    }

    try {
      final imageProvider = MemoryImage(picture.bytes);
      final colorScheme =
          await ColorScheme.fromImageProvider(provider: imageProvider);

      ColorPalette.musicPlayerBG = colorScheme.primary;
    } catch (e) {
      ColorPalette.musicPlayerBG = const Color(0xFF000000);
    }
  }
}

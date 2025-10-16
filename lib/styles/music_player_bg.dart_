import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import '/pages/activity1/song_model.dart';

class MusicPlayerBackground {
  static Future<void> updateFromSong(Song song) async {
    final picture = song.metadata.picture;

    // No album art → fallback to black
    if (picture == null || picture.bytes.isEmpty) {
      ColorPalette.musicPlayerBG = Colors.black;
      return;
    }

    try {
      final imageProvider = MemoryImage(picture.bytes);
      final colorScheme =
          await ColorScheme.fromImageProvider(provider: imageProvider);

      ColorPalette.musicPlayerBG = colorScheme.primary;
    } catch (_) {
      // Fallback color if extraction fails
      ColorPalette.musicPlayerBG = Colors.black;
    }
  }
}

class GradientBackground {
  static Future<void> updateFromSong(Song song) async {
    final picture = song.metadata.picture;

    // Fallback gradient if no album art
    if (picture == null || picture.bytes.isEmpty) {
      ColorPalette.musicPlayerGradient = const LinearGradient(
        colors: [Colors.black, Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      return;
    }

    try {
      final imageProvider = MemoryImage(picture.bytes);
      final colorScheme =
          await ColorScheme.fromImageProvider(provider: imageProvider);

      
      ColorPalette.musicPlayerGradient = LinearGradient(
        colors: [
          colorScheme.primary,
          colorScheme.secondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(math.pi / 4)
      );
    } catch (_) {
      ColorPalette.musicPlayerGradient = const LinearGradient(
        colors: [Colors.black, Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

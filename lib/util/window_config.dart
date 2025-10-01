import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class WindowConfig {
  static Future<void> init() async {
    // Only run on desktop platforms (Windows, macOS, Linux)
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(178, 417),
        size: Size(178, 417),
        center: true,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}

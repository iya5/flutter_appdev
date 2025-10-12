import 'package:flutter/material.dart';

class ColorPalette {
  // ---------- Backgrounds ----------
  static const Color background = Color(0xFF000000);
  static Color musicPlayerBG = const Color(0xFF000000);
  static LinearGradient musicPlayerGradient = const LinearGradient(
    colors: [Colors.black, Colors.grey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color appBar = Color(0xFF000000);

  // ---------- Text ----------
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color.fromARGB(130, 255, 255, 255);
  static const Color textSubtitle = Colors.white70;
  static const Color textMuted = Colors.white54;

  // ---------- Controls ----------
  static const Color sliderActive = Colors.white;
  static const Color sliderInactive = Color.fromARGB(110, 255, 255, 255);

  // ---------- Icons ----------
  static const Color iconPrimary = Colors.white;
  static const Color iconInactive = Color.fromARGB(130, 255, 255, 255);

  // ---------- Effects ----------
  static const Color splash = Colors.white;
  static const Color hoveredList = Color.fromARGB(40, 255, 255, 255);
}

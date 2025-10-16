import 'package:flutter/material.dart';

class ColorPalette {
  // ---------- Backgrounds ----------
  final Color background;
  final Color appBar;

  // ---------- Text ----------
  final Color textPrimary;
  final Color textSecondary;
  final Color textSubtitle;
  final Color textMuted;

  // ---------- Controls ----------
  final Color sliderActive;
  final Color sliderInactive;

  // ---------- Icons ----------
  final Color iconPrimary;
  final Color iconInactive;

  // ---------- Effects ----------
  final Color splash;
  final Color hoveredList;

  const ColorPalette({
    required this.background,
    required this.appBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.textSubtitle,
    required this.textMuted,
    required this.sliderActive,
    required this.sliderInactive,
    required this.iconPrimary,
    required this.iconInactive,
    required this.splash,
    required this.hoveredList,
  });

  // ---------- DARK THEME ----------
  static const dark = ColorPalette(
    background: Color(0xFF000000),
    appBar: Color(0xFF000000),
    textPrimary: Colors.white,
    textSecondary: Color.fromARGB(130, 255, 255, 255),
    textSubtitle: Colors.white70,
    textMuted: Colors.white54,
    sliderActive: Colors.white,
    sliderInactive: Color.fromARGB(110, 255, 255, 255),
    iconPrimary: Colors.white,
    iconInactive: Color.fromARGB(130, 255, 255, 255),
    splash: Colors.white,
    hoveredList: Color.fromARGB(40, 255, 255, 255),
  );

  // ---------- LIGHT THEME ----------
  static const light = ColorPalette(
    background: Color(0xFFFFFFFF),
    appBar: Color(0xFFFFFFFF),
    textPrimary: Colors.black,
    textSecondary: Color.fromARGB(180, 0, 0, 0),
    textSubtitle: Colors.black87,
    textMuted: Colors.black54,
    sliderActive: Colors.black,
    sliderInactive: Color.fromARGB(100, 0, 0, 0),
    iconPrimary: Colors.black,
    iconInactive: Color.fromARGB(120, 0, 0, 0),
    splash: Colors.black,
    hoveredList: Color.fromARGB(20, 0, 0, 0),
  );
}

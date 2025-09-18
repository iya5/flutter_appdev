import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    color: ColorPalette.textPrimary,
    fontSize: 28,
  );

  static const TextStyle title = TextStyle(
    color: ColorPalette.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle subtitle = TextStyle(
    color: ColorPalette.textSubtitle,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle subtitle2 = TextStyle(
    color: ColorPalette.textSubtitle,
    fontSize: 15,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle body = TextStyle(
    color: ColorPalette.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body2 = TextStyle(
    color: ColorPalette.textMuted,
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  static const TextStyle caption = TextStyle(
    color: ColorPalette.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle caption2 = TextStyle(
    color: ColorPalette.textSubtitle,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

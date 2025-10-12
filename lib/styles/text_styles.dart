import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTextStyles {  
  static const double _minHeadline = 20;
  static const double _maxHeadline = 30;

  static const double _minTitle = 14;
  static const double _maxTitle = 24;

  static const double _minSubtitle = 10;
  static const double _maxSubtitle = 18;

  static const double _minSubtitle2 = 9.5;
  static const double _maxSubtitle2 = 17;

  static const double _minBody = 9;
  static const double _maxBody = 16;

  static const double _minBody2 = 9;
  static const double _maxBody2 = 16;

  static const double _minCaption = 8;
  static const double _maxCaption = 14;

  static const double _minCaption2 = 8;
  static const double _maxCaption2 = 14;


  static TextStyle get headline => TextStyle(
        color: ColorPalette.textPrimary,
        fontSize: 28.clamp(_minHeadline, _maxHeadline).toDouble(),
      );

  static TextStyle get title => TextStyle(
        color: ColorPalette.textPrimary,
        fontSize: 22.clamp(_minTitle, _maxTitle).toDouble(),
        fontWeight: FontWeight.w500,
      );

  static TextStyle get subtitle => TextStyle(
        color: ColorPalette.textSubtitle,
        fontSize: 16.clamp(_minSubtitle, _maxSubtitle).toDouble(),
        fontWeight: FontWeight.w400,
      );

  static TextStyle get subtitle2 => TextStyle(
        color: ColorPalette.textSubtitle,
        fontSize: 15.clamp(_minSubtitle2, _maxSubtitle2).toDouble(),
        fontWeight: FontWeight.w300,
      );

  static TextStyle get body => TextStyle(
        color: ColorPalette.textPrimary,
        fontSize: 14.clamp(_minBody, _maxBody).toDouble(),
        fontWeight: FontWeight.w400,
      );

  static TextStyle get body2 => TextStyle(
        color: ColorPalette.textMuted,
        fontSize: 14.clamp(_minBody2, _maxBody2).toDouble(),
        fontWeight: FontWeight.w200,
      );

  static TextStyle get caption => TextStyle(
        color: ColorPalette.textSecondary,
        fontSize: 12.clamp(_minCaption, _maxCaption).toDouble(),
        fontWeight: FontWeight.w300,
      );

  static TextStyle get caption2 => TextStyle(
        color: ColorPalette.textSubtitle,
        fontSize: 12.clamp(_minCaption2, _maxCaption2).toDouble(),
        fontWeight: FontWeight.w400,
      );
}

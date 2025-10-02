import 'package:flutter/material.dart';

class AppIconSizes {
  static const double _minOuterIcon = 8.0;
  static const double _maxOuterIcon = 24.0;

  static const double _minMoveIcon = 12.0;
  static const double _maxMoveIcon = 36.0;

  static const double _minPlayIcon = 16.67;
  static const double _maxPlayIcon = 50.0;

  static const double _minSizedBoxIcon = 1.0;
  static const double _maxSizedBoxIcon = 50.0;

  static const double _minSlider = 1.0;
  static const double _maxSlider = 12.0;


  // shuffle, repeat etc
  static double outerIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.05).clamp(_minOuterIcon, _maxOuterIcon);
  }

  // next, prev
  static double moveIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.07).clamp(_minMoveIcon, _maxMoveIcon);
  }

  // play pause
  static double playIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.1).clamp(_minPlayIcon, _maxPlayIcon);
  }

  // horizontal space
  static double sizedBoxIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.04).clamp(_minSizedBoxIcon, _maxSizedBoxIcon);
  }

  // slider obv...
  static double sizedBoxSlider(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight * 0.01).clamp(_minSlider, _maxSlider);
  }
}

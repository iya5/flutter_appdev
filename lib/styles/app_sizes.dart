import 'dart:math';
import 'package:flutter/material.dart';

class AppSizes {
  final BuildContext context;

  AppSizes(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  double get smallCoverSize =>
      (screenWidth * 0.1).clamp(70.0, 120.0);

  double get coverSize =>
      min(screenWidth * 0.5, screenHeight * 0.5).clamp(50.0, 600.0);

  // Song list scalers
  static const double _minScalingFactor = 0.01; // x
  static const double _maxScalingFactor = 0.99; // y

  static const double _minScreenHeight = 400.0; // a
  static const double _maxScreenHeight = 1200.0; // b

  double get baseScaling {
    double scaling = _minScalingFactor +
        ((screenHeight - _minScreenHeight) / (_maxScreenHeight - _minScreenHeight)) *
            (_maxScalingFactor - _minScalingFactor);

    return scaling.clamp(_minScalingFactor, _maxScalingFactor);
  }

  double get minListHeight => screenHeight * 0.01;
  double get maxListHeight => screenHeight * 0.4;

  double get songListHeight =>
      (screenHeight * baseScaling).clamp(minListHeight, maxListHeight);
  

  double get minHeightBtmControl => screenHeight * 0.01; 
  double get maxHeightBtmControl => screenHeight * 0.06;

  double get bottomControlHeight => (screenHeight * baseScaling).clamp(minHeightBtmControl, maxHeightBtmControl);


  double get verticalMargin => (screenHeight * 0.01).clamp(1.0, 5.0);
  double get songImageSize => (screenWidth * 0.1).clamp(45.0, 55.0); 

}

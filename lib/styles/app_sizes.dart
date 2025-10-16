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
      min(screenWidth * 0.5, screenHeight * 0.5).clamp(100.0, 700.0);

  // Song list scaling
  static const _minScale = 0.09;
  static const _maxScale = 1;
  static const _minHeight = 450.0;
  static const _maxHeight = 1300.0;

  double get _scaleFactor {
    final ratio = ((screenHeight - _minHeight) / (_maxHeight - _minHeight))
        .clamp(0.0, 1.0);
    return _minScale + ratio * (_maxScale - _minScale);
  }

  double get _minListHeight => screenHeight * 0.33;
  double get _maxListHeight => screenHeight * 0.58;

  double get songListHeight =>
      (screenHeight * _scaleFactor).clamp(_minListHeight, _maxListHeight);

  double get minHeightBtmControl => screenHeight * 0.03; 
  double get maxHeightBtmControl => screenHeight * 0.06;


  double get bottomControlHeight {
    double height = screenHeight * 0.06; 
    return height.clamp(minHeightBtmControl, maxHeightBtmControl);
  }

  double get verticalMargin => (screenHeight * 0.009).clamp(1.0, 2.0);
  double get songImageSize => (screenWidth * 0.1).clamp(45.0, 55.0); 

}

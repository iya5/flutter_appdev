import 'package:flutter/material.dart';

int clampi(int min, int max, int value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

double clampd(double min, double max, double value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

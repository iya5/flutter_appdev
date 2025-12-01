import 'constants.dart';
import 'package:flutter/widgets.dart';

import 'game_object.dart';
import 'sprite.dart';

List<Sprite> dogFrames = [
  Sprite()
    ..imagePath = "assets/images/game/fiestaDog/fiestaDog.gif"
    ..imageHeight = 80
    ..imageWidth = 92,
];

class Fiestadog extends GameObject {
  // this is a logical location which is translated to pixel coordinates
  final Offset worldLocation;
  int frame = 0;

  Fiestadog({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (worldLocation.dx - runDistance) * worlToPixelRatio,
        4 / 7 * screenSize.height -
            dogFrames[frame].imageHeight -
            worldLocation.dy,
        dogFrames[frame].imageWidth.toDouble(),
        dogFrames[frame].imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(
      dogFrames[frame].imagePath,
      gaplessPlayback: true,
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> dino = [
  // Idle frames
  Sprite()
    ..imagePath = "assets/images/game/dino/idle_1.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/idle_2.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/idle_3.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/idle_4.png"
    ..imageWidth = 60
    ..imageHeight = 60,

  // Walk frames
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_1.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_2.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_3.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_4.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_5.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/walk_6.png"
    ..imageWidth = 60
    ..imageHeight = 60,

  // Jump frame
  Sprite()
    ..imagePath = "assets/images/game/dino/jump.png"
    ..imageWidth = 60
    ..imageHeight = 60,

  // death frame
  Sprite()
    ..imagePath = "assets/images/game/dino/dino_5.png"
    ..imageWidth = 60
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/game/dino/dino_6.png"
    ..imageWidth = 60
    ..imageHeight = 60,
];


enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(
      currentSprite.imagePath,
      width: currentSprite.imageWidth.toDouble(),
      height: currentSprite.imageHeight.toDouble(),
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
      isAntiAlias: false,
    );
  }


    @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.78 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    double elapsedTimeSeconds;
    try {
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    } catch (_) {
      elapsedTimeSeconds = 0;
    }

    // Calculate a frame counter based on elapsed time
    int frame = 0;
    if (elapsedTime != null) {
      frame = (elapsedTime.inMilliseconds ~/ 120);
    }

    // --- Animation logic based on state ---
    switch (state) {
      case DinoState.dead:
        // Death frames: last 2 sprites in the list (indices 11 and 12)
        currentSprite = dino[11 + (frame % 2)];
        break;

      case DinoState.jumping:
        // Jump frame: index 10
        currentSprite = dino[10];
        break;

      case DinoState.running:
        // Walk frames: indices 4–9
        currentSprite = dino[4 + (frame % 6)];
        break;

      default:
        // Idle frames: indices 0–3 (if you want idle at start)
        currentSprite = dino[frame % 4];
    }

    // --- Physics ---
    if (state != DinoState.dead) {
      dispY += velY * elapsedTimeSeconds;

      if (dispY <= 0) {
        dispY = 0;
        velY = 0;
        state = DinoState.running; // or idle if you want
      } else {
        velY -= gravity * elapsedTimeSeconds;
      }
    }
  }



  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velY = jumpVelocity;
    }
  }

  void die() {
    currentSprite = dino[5];
    state = DinoState.dead;
  }
}
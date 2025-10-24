import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';

class DinoSprites {
  late final SpriteAnimation idle;
  late final SpriteAnimation run;
  late final SpriteAnimation jump;
  late final SpriteAnimation death;
  late final SpriteAnimation zoom;

  DinoSprites._(); 

  static Future<DinoSprites> load() async {
    final sprites = DinoSprites._();

    final image = await Flame.images.load('DinoSprites - tard.png');
    final frameWidth = image.width / 20;
    final frameHeight = image.height.toDouble();

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(frameWidth, frameHeight),
    );

    sprites.idle  = spriteSheet.createAnimation(row: 0, from: 0,  to: 3,  stepTime: 0.1);
    sprites.run   = spriteSheet.createAnimation(row: 0, from: 4,  to: 6,  stepTime: 0.08);
    sprites.jump  = spriteSheet.createAnimation(row: 0, from: 7,  to: 9,  stepTime: 0.1);
    sprites.death = spriteSheet.createAnimation(row: 0, from: 10, to: 12, stepTime: 0.12);
    sprites.zoom  = spriteSheet.createAnimation(row: 0, from: 13, to: 19, stepTime: 0.08);

    return sprites;
  }
}

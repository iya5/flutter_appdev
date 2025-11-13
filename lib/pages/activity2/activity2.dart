import 'dart:math';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_appdev/pages/activity2/time.dart';

import 'package:flutter_appdev/styles/text_styles.dart';
import 'package:flutter_appdev/styles/color_palette.dart';

class Activity2 extends StatelessWidget {
  const Activity2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino 8-Bit Game',
      home: Scaffold(appBar: buildAppBar(context), body: const DinoGame()),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ------------------------------------------

class DinoGame extends StatefulWidget {
  const DinoGame({super.key});
  @override
  State<DinoGame> createState() => DinoGameState();
}

class Player {
  late double width;
  late double height;


  double posY = 200;
  double posX = 100;

  /* velocity is the actual movement of the player: how fast are they moving
     at the moment */
  double velocityX = 0;
  double velocityY = 0;

  /* constant dictating how fast the player moves */
  late double speed;

  /* configurable settings for the player */
  double jumpHeight = 7;
  int jumpTicks = 0;

  /* flags for the player */
  bool jumping = false;

  Player(this.width, this.height, this.speed);

  void jump() {
    if (!jumping && posY == FLOOR_Y_POS) {
      jumping = true;
      velocityY = jumpHeight;
      jumpTicks = 13;
    }
  }

  void moveLeft() {
    velocityX -= speed;
  }

  void moveRight() {
    velocityX += speed;
  }
}

// ignore: constant_identifier_names
const int FRAMETIME_PER_MS = 16;
// ignore: constant_identifier_names
double CEILING_Y_POS = 500;
double FLOOR_Y_POS = 200;
double WALL_LEFT_POS = 0;
double WALL_RIGHT_POS = 900;
// ignore: constant_identifier_names
double GRAVITY = 4;





class DinoGameState extends State<DinoGame> {
  double cactusX = 0;
  double cactusY = FLOOR_Y_POS;
  double cactusVelocityX = 6; 

  Player player = Player(70, 70, 2);

  /* gives us ability to track all keys from our input and their state */
  Set<LogicalKeyboardKey> pressedKeys = {};

  int score = 0;
  bool gameOver = false;
  bool gameStarted = false;
  bool cactusPassed = false;

  final FocusNode keyboardFocus = FocusNode();

  static const double cactusWidth = 70;
  static const double cactusHeight = 60;

  late Timer gameTimer;

  @override
  void initState() {
    super.initState();

    gameTimer = Timer.periodic(const Duration(milliseconds: FRAMETIME_PER_MS), (
      timer,
    ) {
      gameLoop();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(keyboardFocus);
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  bool aabbCollisionCheck(double a_minX,
    double a_minY,
    double a_maxX,
    double a_maxY,
    double b_minX,
    double b_minY,
    double b_maxX,
    double b_maxY,
  ) {
    return (a_maxX > b_minX &&
          b_maxX > a_minX &&
          a_maxY > b_minY &&
          b_maxY > a_minY);
  }

  void gameLoop() {
    setState(() {
      gameOver = false;
      gameStarted = true;

      cactusX -= cactusVelocityX;

      player.velocityX = 0;
      player.velocityY = 0;

      double PminX = player.posX;
      double PminY = player.posY;

      double PmaxX = player.posX + (player.width - 20);
      double PmaxY = player.posY + player.height;

      double CminX = cactusX;
      double CminY = cactusY;

      double CmaxX = cactusX + (cactusWidth - 20);
      double CmaxY = cactusY + cactusHeight;

      if (cactusX + cactusWidth < 0 && !cactusPassed) {
        score += 1;
        cactusPassed = true; // move it back to the right side
      }

      if (cactusX + cactusWidth < 0) {
        cactusX = WALL_RIGHT_POS;
        cactusPassed = false;
      }

      processInput();
      /* if the player is jumping or if they are off the ground, apply gravity
         to their velocity, then subtract the player's position Y from the
         velocity */
      if (player.jumping || player.posY > FLOOR_Y_POS) {
        if (player.jumpTicks > 0) {
          player.velocityY += player.jumpHeight;
          player.jumpTicks--;
        } else {
          player.velocityY -= GRAVITY;
        }
      }

      /* get all contributions to velocity & apply to the position */
      player.posX += player.velocityX * player.speed;
      player.posY += player.velocityY * player.speed;

      /* clamp player to the floor if they land or are underneathe the ground */
      if (player.posY <= FLOOR_Y_POS) {
        player.velocityY = 0;
        player.jumping = false;
        player.posY = FLOOR_Y_POS;
      }

      // should be clamping
      if (player.posX + player.width >= WALL_RIGHT_POS) {
        player.posX = WALL_RIGHT_POS - player.width;
        player.velocityX = 0;
      }

      if (player.posX <= WALL_LEFT_POS) {
        player.posX = WALL_LEFT_POS;
        player.velocityX = 0;
      }

      bool collided = aabbCollisionCheck(
        PminX, PminY, PmaxX, PmaxY,
        CminX, CminY, CmaxX, CmaxY,
      );

      if (collided) {
        gameOver = true;
        cactusVelocityX = 0; // stop player
      }
    });
  }



  void processInput() {
    /* if no keys were pressed, leave the function to prevent further calculation */
    if (pressedKeys.isEmpty) return;

    /* process my input keys */
    for (final key in pressedKeys) {
      if (gameOver) {
        for (final key in pressedKeys) {
          if (key == LogicalKeyboardKey.keyW || key == LogicalKeyboardKey.space) {
            gameLoop();
            print("Game restarted!");
          }
        }
        return; // prevent dead dino movement
      }

      if (key == LogicalKeyboardKey.keyW || key == LogicalKeyboardKey.space) {
          player.jump();
          print("space");
      }

      if (key == LogicalKeyboardKey.keyA ||
          key == LogicalKeyboardKey.arrowLeft) {
        player.moveLeft();
      }

      if (key == LogicalKeyboardKey.keyD ||
          key == LogicalKeyboardKey.arrowRight) {
        player.moveRight();
      }
    }
  }

  void pollInput(KeyEvent event) {
    /* we grab the key from the event class giving us access to keys that were
       pressed & their states too */
    final key = event.logicalKey;

    /* if the key was pressed (short/long), then we say that the key is pressed */
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (!pressedKeys.contains(key)) {
        pressedKeys.add(key);
      }
      /* if the key is not pressed, then remove it from the set of pressed keys */
    } else if (event is KeyUpEvent) {
      pressedKeys.remove(key);
    }
  }

  Widget buildGame(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CEILING_Y_POS = screenSize.height;
    WALL_RIGHT_POS = screenSize.width;

    return Stack(
      children: [
        // Ground
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: FLOOR_Y_POS,
          width: double.infinity,
          color: const Color.fromARGB(255, 235, 192, 63),
        ),
      ),

      // Cactus obstacle
      Positioned(
        bottom: FLOOR_Y_POS,
        left: cactusX,
        child: Image.asset(
          'assets/images/game/cactus.png',
          width: cactusWidth,
          height: cactusHeight,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          opacity: const AlwaysStoppedAnimation(.9),
        ),
      ),

      // Player (dino)
      Positioned(
        bottom: player.posY,
        left: player.posX,
        child: Transform(
          alignment: Alignment.center,
          transform: player.velocityX < 0.0
              ? Matrix4.rotationY(pi)
              : Matrix4.identity(),
          child: Image.asset(
            !gameStarted
                ? 'assets/images/game/idle.gif'         // idle before starting
                : gameOver
                    ? 'assets/images/game/dead.png'     // dead when game over
                    : (player.jumping
                        ? 'assets/images/game/jump.png' // jumping
                        : 'assets/images/game/walk.gif'), // walking
            width: player.width,
            height: player.height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
          ),

        ),
      ),

      // Score display (top-right)
      Positioned(
        top: 20,
        right: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(100, 0, 0, 0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),

      // Game over overlay
      if (gameOver)
        Container(
          color: const Color.fromARGB(229, 0, 0, 0),
          child: Center(
            child: Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 199, 13, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: keyboardFocus,
        autofocus: true,
        onKeyEvent: (event) => pollInput(event),
        child: Center(
          child: Container(
            width: WALL_RIGHT_POS,
            height: CEILING_Y_POS,
            color: const Color.fromARGB(255, 116, 191, 229),
            child: buildGame(context),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
PreferredSizeWidget? buildAppBar(BuildContext context) {
  final palette = ColorPalette.dark;
  return AppBar(
    leading: IconButton(
      icon: Icon(CupertinoIcons.clear_thick, color: palette.iconPrimary),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Music Player', style: AppTextStyles.title(palette: palette)),
        Text('Activity 1', style: AppTextStyles.caption(palette: palette)),
      ],
    ),
    backgroundColor: palette.appBar,
    toolbarHeight: 70,
    elevation: 0,
  );
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class Activity2 extends StatelessWidget {
  const Activity2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino 8-Bit Game',
      home: Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.clear_thick, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity 2',
                    style: TextStyle(color: Colors.white),
              ),
              Text('Dino Game',
                    style: TextStyle(color: Colors.white,fontSize: 14.0, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          backgroundColor: Colors.purple,
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
        ),
        body: const DinoGame(),
        ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------------- app bar

class DinoGame extends StatefulWidget {
  const DinoGame({super.key});

  @override
  State<DinoGame> createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame> {
  // Player Variables
  double playerY = 0; // player vertical position
  double velocity = 0; // vertical speed
  bool isJumping = false;

  // Obstacle Variables
  double cactusX = 1.5; // cactus horizontal position

  // Game State
  int score = 0;
  bool gameOver = false;
  bool gameStarted = false;
  Timer? gameTimer; // main game loop timer

  final FocusNode _focusNode = FocusNode(); // for keyboard control

  // Cached screen size (to avoid MediaQuery null crash)
  late double screenWidth;
  late double screenHeight;
  bool _hasSetScreenSize = false;

  // Constants
  static const double groundHeight = 400;
  static const double playerWidth = 50;
  static const double playerHeight = 50;
  static const double cactusWidth = 50;
  static const double cactusHeight = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    });
  }

  // Start / Restart the Game
  void startGame() {
    // prevent restarting mid-play
    if (gameStarted && !gameOver) return;

    setState(() {
      score = 0;
      gameOver = false;
      gameStarted = true;
      cactusX = 0;
      playerY = 0;
      velocity = 0;
      isJumping = false;
    });

    // start game loop (every 30ms)
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) updateGame();
    });
  }

  // Collision detection
  bool checkCollision() {
    final playerRect = Rect.fromCenter(
      center: Offset(
        screenWidth * 0.2,
        screenHeight -
            groundHeight / 2 -
            playerHeight / 2 -
            playerY * 100,
      ),
      width: playerWidth,
      height: playerHeight,
    );

    final cactusRect = Rect.fromCenter(
      center: Offset(
        screenWidth * (0.55 + cactusX * 0.3),
        screenHeight - groundHeight / 2 - cactusHeight / 2,
      ),
      width: cactusWidth,
      height: cactusHeight,
    );

    return playerRect.overlaps(cactusRect);
  }

  // Main Game Loop
  void updateGame() {
    if (gameOver) return;

    setState(() {
      // move cactus left
      cactusX -= 0.02;

      // handle gravity & jump
      if (isJumping || playerY > 0) {
        velocity -= 0.020; // gravity
        playerY += velocity;
        if (playerY <= 0) {
          playerY = 0;
          isJumping = false;
          velocity = 0;
        }
      }

      // reset cactus position & score
      if (cactusX < -1.2) {
        cactusX = 1.5 + Random().nextDouble();
        score++;
      }

      // collision check
      if (checkCollision()) {
        gameOver = true;
        gameStarted = false;
        gameTimer?.cancel();
      }
    });
  }

  // Jump Action
  void jump() {
    if (!isJumping && playerY == 0 && !gameOver) {
      setState(() {
        isJumping = true;
        velocity = 0.25; // jump impulse
      });
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose(); // dispose focus node properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cache screen size once
    if (!_hasSetScreenSize) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
      _hasSetScreenSize = true;
    }

    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          // spacebar to jump/start
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            if (!gameStarted || gameOver) {
              startGame();
            } else {
              jump();
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
            if (!gameStarted || gameOver) {
              startGame();
            } else {
              jump();
            }
          },
          child: Stack(
            children: [
              // Background Sky
              Container(color: const Color.fromARGB(255, 116, 191, 229)),

              // Ground
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: groundHeight,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 234, 178, 10),
                ),
              ),

              // Cactus
              Positioned(
                left: screenWidth * (0.5 + cactusX * 0.3),
                bottom: groundHeight,
                child: Image.asset(
                  'assets/images/dodge/cactus.png',
                  width: cactusWidth,
                  height: cactusHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
              ),

              // Player
              Positioned(
                left: screenWidth * 0.2 - playerWidth / 2,
                bottom: groundHeight + playerY * 100,
                child: Image.asset(
                  'assets/images/dodge/player.png',
                  width: playerWidth,
                  height: playerHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
              ),

              // Score
              Positioned(
                top: 50,
                left: 20,
                child: Text(
                  'Score: $score',
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),

              // Game Over Screen
              if (gameOver)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Game Over!',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Score: $score',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white)),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: startGame,
                          icon: const Icon(Icons.play_arrow, size: 50),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

              // Start Screen
              if (!gameStarted && !gameOver)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.play_arrow,
                          size: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap or Press Space to Start',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

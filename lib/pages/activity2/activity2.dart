import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

class Activity2 extends StatelessWidget {
  const Activity2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino 8-Bit Game',
      home: const DinoGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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

  // Constants for positioning
  static const double groundHeight = 100;
  static const double playerWidth = 50;
  static const double playerHeight = 50;
  static const double cactusWidth = 50;
  static const double cactusHeight = 50;

  @override
  void initState() {
    super.initState();
    // Automatically focus keyboard listener when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
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
      cactusX = 1.5;
      playerY = 0;
      velocity = 0;
      isJumping = false;
    });

    // start game loop (every 30ms)
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      updateGame();
    });
  }

  // Collision detection using Rect
  bool checkCollision() {
    // Get player rect - positioned at bottom of screen with vertical offset
    final playerRect = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width * 0.2, // 20% from left
        MediaQuery.of(context).size.height - groundHeight / 2 - playerHeight / 2 - playerY * 100,
      ),
      width: playerWidth,
      height: playerHeight,
    );

    // Get cactus rect - positioned at bottom of screen
    final cactusRect = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width * (0.5 + cactusX * 0.3), // Adjusted for better collision range
        MediaQuery.of(context).size.height - groundHeight / 2 - cactusHeight / 2,
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
        velocity -= 0.015; // gravity pull
        playerY += velocity;
        if (playerY <= 0) {
          // reset when player lands
          playerY = 0;
          isJumping = false;
          velocity = 0;
        }
      }

      // reset cactus position and increase score
      if (cactusX < -1.2) {
        cactusX = 1.5 + Random().nextDouble();
        score++;
      }

      // Collision Detection using Rect
      if (checkCollision()) {
        gameOver = true;
        gameStarted = false;
        gameTimer?.cancel();
      }
    });
  }

  // Jump Action 
  void jump() {
    // only jump if on the ground and not game over
    if (!isJumping && playerY == 0 && !gameOver) {
      setState(() {
        isJumping = true;
        velocity = 0.25; // increased jump impulse for better feel
      });
    }
  }

  @override
  void dispose() {
    // stop timer when widget is destroyed
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          // spacebar to jump or start
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
          // tap anywhere to start or jump
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

              // Ground (fills entire bottom) 
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: groundHeight,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 234, 178, 10),
                ),
              ),

              // Cactus (obstacle) - positioned at ground level
              Positioned(
                left: MediaQuery.of(context).size.width * (0.5 + cactusX * 0.3),
                bottom: groundHeight, // Positioned at top of ground
                child: Image.asset(
                  'assets/images/dodge/cactus.png',
                  width: cactusWidth,
                  height: cactusHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
              ),

              // Player (dino) - positioned at ground level with jump offset
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2 - playerWidth / 2,
                bottom: groundHeight + playerY * 100, // Ground level + jump offset
                child: Image.asset(
                  'assets/images/dodge/player.png',
                  width: playerWidth,
                  height: playerHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
              ),

              // Score Counter 
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
                        // play icon replaces button
                        IconButton(
                          onPressed: startGame,
                          icon: const Icon(Icons.play_arrow, size: 50),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

              // Start Screen (before first play)
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
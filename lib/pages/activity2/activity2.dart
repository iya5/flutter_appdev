import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cactus.dart';
import 'cloud.dart';
import 'dino.dart';
import 'game_object.dart';
import 'ground.dart';
import 'constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Forces portrait orientation for the entire app.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Main application wrapper.
    return const MaterialApp(
      title: 'jumping t-rex',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  // Player character
  Dino dino = Dino();

  // Horizontal movement variables
  double runVelocity = initialVelocity;
  double runDistance = 0;

  // Highest score reached
  int highScore = 0;

  // Controllers for the settings dialog
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());
  TextEditingController dayNightOffestController =
      TextEditingController(text: dayNightOffest.toString());

  // Animation controller driving all world updates
  late AnimationController worldController;

  // Stores previous update time for delta-time movement
  Duration lastUpdateCall = const Duration();

  // Initial game objects in the world
  List<Cactus> cacti = [
    Cactus(worldLocation: const Offset(200, 0)),
  ];

  // Two ground sprites looping infinitely
  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0)),
  ];

  // Clouds with their initial locations
  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  @override
  void initState() {
    super.initState();

    // Very long-duration controller; acts as a continuous game loop.
    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));

    // Every tick of the controller calls _update().
    worldController.addListener(_update);

    // Start game in "dead" state waiting for restart.
    _die();
  }

  // Kills the player and stops world movement.
  void _die() {
    setState(() {
      worldController.stop();
      dino.die();
    });
  }

  // Resets all game objects and variables to start a new game session.
  void _newGame() {
    setState(() {
      // Update high score
      highScore = max(highScore, runDistance.toInt());

      // Reset movement
      runDistance = 0;
      runVelocity = initialVelocity;

      // Reset dino
      dino.state = DinoState.running;
      dino.dispY = 0;

      // Reset world time
      worldController.reset();

      // Reset cactus positions
      cacti = [
        Cactus(worldLocation: const Offset(200, 0)),
        Cactus(worldLocation: const Offset(300, 0)),
        Cactus(worldLocation: const Offset(450, 0)),
      ];

      // Reset ground tiles
      ground = [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0)),
      ];

      // Reset clouds with random spread
      clouds = [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -15)),
        Cloud(worldLocation: const Offset(500, 10)),
        Cloud(worldLocation: const Offset(550, -10)),
      ];

      // Start world movement
      worldController.forward();
    });
  }

  // Core game loop: runs every frame via AnimationController listener.
  _update() {
    try {
      double elapsedTimeSeconds;

      // Update dino physics (gravity, jump)
      dino.update(lastUpdateCall, worldController.lastElapsedDuration);

      // Compute delta time in seconds
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      // Move world forward based on velocity
      runDistance += runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;

      // Acceleration increases game speed over time
      runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      // Dino rectangle used for collision checks
      Rect dinoRect = dino.getRect(screenSize, runDistance);

      // Cactus movement + collision logic
      for (Cactus cactus in cacti) {
        Rect obstacleRect = cactus.getRect(screenSize, runDistance);

        // Basic hitbox collision detection
        if (dinoRect.overlaps(obstacleRect.deflate(20))) {
          _die();
        }

        // If cactus passes offscreen, replace with new one
        if (obstacleRect.right < 0) {
          setState(() {
            cacti.remove(cactus);
            cacti.add(
              Cactus(
                worldLocation: Offset(
                  runDistance +
                      Random().nextInt(100) +
                      screenSize.width / worlToPixelRatio,
                  0,
                ),
              ),
            );
          });
        }
      }

      // Ground loop: when one tile leaves screen, spawn next
      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      // Cloud parallax loop
      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(200) +
                      screenSize.width / worlToPixelRatio,
                  Random().nextInt(50) - 25.0,
                ),
              ),
            );
          });
        }
      }

      // Store time of this update for next delta calculation
      lastUpdateCall = worldController.lastElapsedDuration!;
    } catch (e) {
      // Prevent crash if update fails
    }
  }

  @override
  void dispose() {
    // Dispose controllers on page exit
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    dayNightOffestController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

  // Build widget for each game object (cloud, ground, cactus, dino)
    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {          
            // Converts world coordinates into screen coordinates
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: AnimatedContainer(
        // Smoothly changes background color (day / night)
        duration: const Duration(milliseconds: 5000),
        color: (runDistance ~/ dayNightOffest) % 2 == 0
            ? Colors.white
            : Colors.black,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,

          // Jump when alive; restart when dead
          onTap: () {
            if (dino.state != DinoState.dead) {
              dino.jump();
            }
            if (dino.state == DinoState.dead) {
              _newGame();
            }
          },

          child: Stack(
            alignment: Alignment.center,
            children: [
              ...children,

              // Score text
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: screenSize.width / 2 - 30,
                    top: 100,
                    child: Text(
                      'Score: ' + runDistance.toInt().toString(),
                      style: TextStyle(
                        color: (runDistance ~/ dayNightOffest) % 2 == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),

              // High score text
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: screenSize.width / 2 - 50,
                    top: 120,
                    child: Text(
                      'High Score: ' + highScore.toString(),
                      style: TextStyle(
                        color: (runDistance ~/ dayNightOffest) % 2 == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
              
              // Settings button for physics adjustment
              Positioned(
                right: 20,
                top: 20,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _die(); // Pause game while editing
                    showDialog(
                      context: context,
                      builder: (context) {
                        // Physics adjustment dialog
                        return AlertDialog(
                          title: const Text("Change Physics"),
                          actions: [

                            
                            // Gravity field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Gravity:"),
                                    SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: TextField(
                                        controller: gravityController,
                                        key: UniqueKey(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Acceleration field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Acceleration:"),
                                    SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: TextField(
                                        controller: accelerationController,
                                        key: UniqueKey(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Run velocity field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Initial Velocity:"),
                                    SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: TextField(
                                        controller: runVelocityController,
                                        key: UniqueKey(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Jump velocity field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Jump Velocity:"),
                                    SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: TextField(
                                        controller: jumpVelocityController,
                                        key: UniqueKey(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Day/night offset field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Day-Night Offset:"),
                                    SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: TextField(
                                        controller: dayNightOffestController,
                                        key: UniqueKey(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Apply new physics values
                            TextButton(
                              onPressed: () {
                                gravity = int.parse(gravityController.text);
                                acceleration =
                                    double.parse(accelerationController.text);
                                initialVelocity =
                                    double.parse(runVelocityController.text);
                                jumpVelocity =
                                    double.parse(jumpVelocityController.text);
                                dayNightOffest =
                                    int.parse(dayNightOffestController.text);

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              // Manual kill switch for testing
              Positioned(
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    _die();
                  },
                  child: const Text(
                    "Force Kill Dino",
                    style: TextStyle(color: Colors.red),
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
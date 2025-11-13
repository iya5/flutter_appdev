class TimeState {
  double dt = 0;
  DateTime lastTime = DateTime.now();
  DateTime currentTime = DateTime.now();

  int fps = 0;
  double fpsTimer = 0.0;
  int fpsDisplay = 0;

  void update() {
    /* https://alvinalexander.com/source-code/flutter-dart-delta-time-performance-debugging-now */
    currentTime = DateTime.now();
    dt = currentTime.difference(lastTime).inMicroseconds / 1e6;
    lastTime = currentTime;

    fps++;
    fpsTimer += dt;

    if (fpsTimer >= 1.0) {
      //print("Frame Time: ${(1000.0 / fps.toDouble()).toStringAsFixed(2)}ms");
      fpsDisplay = fps;
      fps = 0;
      fpsTimer = 0.0;
    }
  }
}
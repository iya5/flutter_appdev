import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../song_model.dart';

class PlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> songs;

  int currentIndex = 0;
  bool isPlaying = false;
  bool isShuffle = false;
  int loopMode = 0; 

  PlayerService(this.songs);

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> playSong(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].path));
    currentIndex = index;
    isPlaying = true;
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    isPlaying = !isPlaying;
  }

  void nextSong() {
    if (isShuffle) {
      _shuffleSong();
    } else {
      currentIndex = (currentIndex + 1) % songs.length;
      playSong(currentIndex);
    }
  }

  void prevSong() {
    if (isShuffle) {
      _shuffleSong();
    } else {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
      playSong(currentIndex);
    }
  }

  void _shuffleSong() {
    if (songs.length <= 1) return;
    int newIndex = currentIndex;
    while (newIndex == currentIndex) {
      newIndex = Random().nextInt(songs.length);
    }
    playSong(newIndex);
  }

  void toggleLoopMode() {
    loopMode = (loopMode + 1) % 3;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

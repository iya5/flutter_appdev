import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'song.dart';

enum loopState { 
  off, 
  onSong, 
  onPlaylist
}

class Mp3Player {
  AudioPlayer audio;
  List<Song> songs = [];

  List<Song> originalPlaylist = [];

  double volume;
  int currentIndex;
  bool playing;
  bool shuffled;
  loopState looped;

  Duration currentPosition;

  Mp3Player({
    required this.audio,
    this.currentIndex = 0,
    this.volume = 0.5,
    this.playing = false,
    this.shuffled = false,
    this.looped = loopState.onPlaylist,
    this.currentPosition = Duration.zero,
  });

  Future<void> setVolume(double value) async {
    value = value.clamp(0, 1);
    audio.setVolume(value);
    volume = value;
  }

  Future<void> loadSongs(List<String> paths) async {
    for (int i = 0; i < paths.length; i++) {
      Song song = songCreate(paths[i]);
      songs.add(song);
      originalPlaylist.add(song);
    }
  }

  Future<void> play(int index) async {
    index = index.clamp(0, songs.length - 1);
    await audio.stop();
    audio.play(AssetSource(songs[index].path.replaceFirst("assets/", "")));
    playing = true;
    currentIndex = index;
  }

  Future<void> next() async {
    int index = (currentIndex + 1) % songs.length;
    await play(index);
  }

  Future<void> prev() async {
    int index = (currentIndex - 1) % songs.length;
    await play(index);
  }

  Future<void> pause() async {
    if (playing) {
      audio.pause();
      playing = false;
    }
  }

  Future<void> resume() async {
    if (!playing) {
      audio.resume();
      playing = true;
    }
  }

  Future<void> toggleResumePause() async {
    if (playing) {
      await audio.pause();
    } else {
      await audio.resume();
    }
    playing = !playing;
     print("mp3 is now ${playing ? "playing" : "paused"}");
  }

  Future<void> toggleShuffle() async {
    if (shuffled) {
      shuffleOff();
    } else {
      shuffleOn();
    }
    print("shuffle is now ${shuffled ? "on" : "off"}");
  }

  Future<void> shuffleOn() async {
    if (shuffled) return;

    shuffled = true;
    if (songs.isEmpty) return;

    Song currSong = getCurrentSong();
    originalPlaylist = List.from(songs);

    // shuffle songs
    _fisherYatesShuffle(songs);

    // find current song in newly shuffled playlist to avoid playing it again after skipping or running prev
    for (int i = 0; i < songs.length; i++) {
      if (songs[i].path == currSong.path) {
        currentIndex = i;
        break;
      }
    }
  }

  Future<void> shuffleOff() async {
    if (!shuffled) return;

    shuffled = false;
    if (songs.isEmpty) return;

    Song currSong = getCurrentSong();
    songs = List.from(originalPlaylist);

    // find current song in original playlist so that it's back to "normal"
    for (int i = 0; i < songs.length; i++) {
      if (songs[i].path == currSong.path) {
        currentIndex = i;
        break;
      }
    }
  }

  Song getSong(int index) {
    if (index < 0 || index >= songs.length) {
      index = index.clamp(0, songs.length - 1);
    }

    return songs[index];
  }

  Song getCurrentSong() {
    return getSong(currentIndex);
  }


  void _fisherYatesShuffle(List<Song> songs) {
    int _currIndex = songs.length;

    while (_currIndex != 0) {
      int randIndex = (Random().nextDouble() * _currIndex).floor();
      _currIndex--;

      Song temp = songs[_currIndex];
      songs[_currIndex] = songs[randIndex];
      songs[randIndex] = temp;
    }
  }

  Future<void> destroy() async {
    await audio.stop();
    await audio.dispose();
  }

  Future<void> loopToggle() async {
    if (looped == loopState.off) {
      looped = loopState.onSong;
    } else if (looped == loopState.onSong) {
      looped = loopState.onPlaylist;
    } else {
      looped = loopState.off;
    }
  }

  Future<void> repeat() async {
    await play(currentIndex);
  }

  Future<void> seekTo(Duration position) async {
    bool wasPlaying = playing;
    if (wasPlaying) {
      await pause();
    }

    await audio.seek(position);
    currentPosition = position;

    if (wasPlaying) {
      await resume();
    }
  }
}
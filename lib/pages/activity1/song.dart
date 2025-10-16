import 'dart:io';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/widgets.dart';

const List<String> songPaths = [
  "assets/music/1 TO 10.mp3",
  "assets/music/AVOCADO (feat. Gliiico).mp3",
  "assets/music/Alcohol-Free.mp3",
  "assets/music/Celebrate.mp3",
  "assets/music/Feel My Rhythm.mp3",
  "assets/music/Merry & Happy.mp3",
  "assets/music/MORE & MORE.mp3",
  "assets/music/Power Up.mp3",
  "assets/music/RUSH.mp3",
  "assets/music/UP NO MORE.mp3",
  "assets/music/러시안 룰렛 Russian Roulette.mp3",
  "assets/music/빨간 맛 Red Flavor.mp3",
  "assets/music/행복 (Happiness).mp3",
  "assets/music/SAY YOU LOVE ME.mp3",
  "assets/music/debug-file.mp3",
];

class Song {
  String path;
  String title;
  String artist;
  Duration duration;
  String album;
  Picture? picture;
  late final Image cover;

  Song(
    this.path,
    this.title,
    this.artist,
    this.duration,
    this.album,
    this.picture
  );
}

Song songCreate(String path) {
  // load the song onto memory then read using metadata reader lib
  // also parse the covers for the track onto pictures as uint8 bytes
  final loadedFile = File(path);
  AudioMetadata metadata = readMetadata(loadedFile, getImage: true);

  // load metadata onto song object with defaults if none found from tag
  // if picture bytes found, only load the first cover
  String title = metadata.title != null ? metadata.title! : "Unknown Title";
  String artist = metadata.artist != null ? metadata.artist! : "Unknown Artist";
  String album = metadata.album != null ? metadata.album! : "Unknown Album";
  Duration duration = metadata.duration != null ? metadata.duration! : Duration.zero;
  Picture? picture = metadata.pictures.isEmpty ? null : metadata.pictures[0];

  Song song = Song(path, title, artist, duration, album, picture);
  song.cover = songCoverBuild(song);

  return song;
}

// build cover from available bytes if it exists inside the metadata, if not,
// fallback to default image asset
Image songCoverBuild(Song song) {
  Picture? picture = song.picture;

  // on fallback if no bytes found
  if (picture == null) {
    return Image.asset("assets/images/default-album-cover.png");
  }
  
  // build image asset from bytes found in memory
  // clamp width and height to reduce memory bandwith and load faster
  return Image.memory(Uint8List.fromList(picture.bytes), width: 128, height: 128);
}
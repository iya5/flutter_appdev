import 'package:audiotags/audiotags.dart';

class SongRepository {
	static const List<String> songPaths = [
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
	];
}

class Song {
  SongMetadata metadata;
  String path;

  Song(this.metadata, this.path);
}

class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  int? year;
  Picture? picture;

  SongMetadata(
    this.title,
    this.trackArtist,
    this.album,
    this.year,
    this.picture,
  );
}
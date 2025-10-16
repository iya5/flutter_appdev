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
  late final Image cover;

  Song(
    this.path,
    this.title,
    this.artist,
    this.duration,
    this.album,
  );
}

Song songCreate(SongData data) {
  Song song = Song(data.path, data.title, data.artist, data.duration, data.album);
	song.cover = songCoverBuild(song, data.cover_path);

  return song;
}

Image songCoverBuild(Song song, String? path) {

  if (path == null) {
    print("No picture was provided");
    return Image.asset("assets/images/default-album-cover.jpg");
  }

  return Image.asset(path, width: 128, height: 128);
}

class SongData {
	String title;
	final String path;
	String? cover_path;
	String artist;
	String album;
	final Duration duration;

	SongData({
		this.title = "Unknown Title",
		required this.path,
		this.artist = "Unknown Artist",
		this.cover_path,
		this.album = "Unknown Album",
		required this.duration
	});
}

List<SongData> SONG_DATA = [
	SongData(
		title: "1 TO 10",
		path: 'assets/music/1 TO 10.mp3',
		artist: 'TWICE',
		cover_path: 'assets/music/cover/1 TO 10.jpg',
		album: 'TWICEcoaster',
		duration: Duration(seconds: 175),
	),
  SongData(
    title: "AVOCADO (feat. Gliiico)",
    path: 'assets/music/AVOCADO (feat. Gliiico).mp3',
    artist: 'Chaeyoung',
    cover_path: 'assets/music/cover/AVOCADO.png',
    album: 'LIL FANTASY vol.1',
    duration: Duration(seconds: 141),
  ),
  SongData(
    title: "Alcohol-Free",
    path: 'assets/music/Alcohol-Free.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/Alcohol-Free.jpg',
    album: 'Taste of Love',
    duration: Duration(seconds: 210),
  ),
  SongData(
    title: "Celebrate",
    path: 'assets/music/Celebrate.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/Celebrate.jpg',
    album: 'Celebrate',
    duration: Duration(seconds: 188),
  ),
  SongData(
    title: "Feel My Rhythm",
    path: 'assets/music/Feel My Rhythm.mp3',
    artist: 'Red Velvet',
    cover_path: 'assets/music/cover/Feel My Rhythm.jpg',
    album: 'The ReVe Festival 2022',
    duration: Duration(seconds: 210),
  ),
  SongData(
    title: "MORE & MORE",
    path: 'assets/music/MORE & MORE.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/MORE & MORE.jpg',
    album: 'MORE & MORE',
    duration: Duration(seconds: 199),
  ),
  SongData(
    title: "Merry & Happy",
    path: 'assets/music/Merry & Happy.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/Merry & Happy.jpg',
    album: 'Twicetagram',
    duration: Duration(seconds: 192),
  ),
  SongData(
    title: "Power Up",
    path: 'assets/music/Power Up.mp3',
    artist: 'Red Velvet',
    cover_path: 'assets/music/cover/Power Up.jpg',
    album: 'Summer Magic',
    duration: Duration(seconds: 202),
  ),
  SongData(
    title: "RUSH",
    path: 'assets/music/RUSH.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/RUSH.jpg',
    album: 'With YOU-th',
    duration: Duration(seconds: 156),
  ),
  SongData(
    title: "SAY YOU LOVE ME",
    path: 'assets/music/SAY YOU LOVE ME.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/SAY YOU LOVE ME.jpg',
    album: 'Yes or Yes',
    duration: Duration(seconds: 212),
  ),
  SongData(
    title: "UP NO MORE",
    path: 'assets/music/UP NO MORE.mp3',
    artist: 'TWICE',
    cover_path: 'assets/music/cover/UP NO MORE.png',
    album: 'Eyes wide open',
    duration: Duration(seconds: 214),
  ),
  SongData(
    title: "Test File",
    path: 'assets/music/debug-file.mp3',
    artist: 'test-artist',
    album: 'test-album',
    duration: Duration(seconds: 6),
  ),
  SongData(
    title: "러시안 룰렛 Russian Roulette",
    path: 'assets/music/러시안 룰렛 Russian Roulette.mp3',
    artist: 'Red Velvet',
    cover_path: 'assets/music/cover/Russian Roulette.jpg',
    album: 'Russian Roulette',
    duration: Duration(seconds: 211),
  ),
  SongData(
    title: "빨간 맛 Red Flavor",
    path: 'assets/music/빨간 맛 Red Flavor.mp3',
    artist: 'Red Velvet',
    cover_path: 'assets/music/cover/Red Flavor.png',
    album: 'The Red Summer',
    duration: Duration(seconds: 191),
  ),
  SongData(
    title: "행복 (Happiness)",
    path: 'assets/music/행복 (Happiness).mp3',
    artist: 'Red Velvet',
    cover_path: 'assets/music/cover/Happiness.jpg',
    album: 'Happiness',
    duration: Duration(seconds: 220),
  ),
];
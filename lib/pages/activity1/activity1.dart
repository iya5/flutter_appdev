import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'dart:math';
//import 'dart:typed_data';
import 'songListPage.dart';



class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  //int? year;
  //int? duration = tag?.duration;
  Picture? picture;

  SongMetadata(
    this.title,
    this.trackArtist,
    this.album,
    this.picture
  );
}

class _MusicPlayerState extends State<Activity1> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  SongMetadata songMetadata = SongMetadata(null, null, null, null);
  int _currentIndex = 0;
  bool _isPlaying = false;
  
  String? currentTitle;
  String? currentTrackArtist;
  String? currentAlbum;
  int? currentYear;
  //int? duration = tag?.duration;
  Picture? picture;

  List<String> songs = [
    "assets/music/1 TO 10.mp3",
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

  @override // docs: https://api.flutter.dev/flutter/widgets/State/initState.html
  void initState() { // used this to play the song immediately after clicking activity
    super.initState();
    _currentIndex = 0;

    _preload();

    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  Future<void> _preload() async {
    await _getMetadata(_currentIndex);

    await _audioPlayer.setSource(
      AssetSource((songs[_currentIndex].replaceFirst("assets/", "")))
    );
  }

  Future<void> _getMetadata(int index) async { // used this for showing metadata
    Tag? tag = await AudioTags.read(songs[index]);

    setState(() {
      songMetadata.title = tag?.title;
      songMetadata.trackArtist = tag?.trackArtist;
      songMetadata.album = tag?.album;
      //songMetadata.year = tag?.year;
      //int? duration = tag?.duration;
      List<Picture>? pictures = tag?.pictures;
      songMetadata.picture = pictures?[0];
    });
  }
  

  Future<void> _playSong(int index) async {
    // await is necessary to get metadata before rebuilding ui and playing song
    await _getMetadata(index); 
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].replaceFirst("assets/", "")));
    setState(() {
      _currentIndex = index;
      _isPlaying = true;
    });
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextSong() {
    _currentIndex = (_currentIndex + 1) % songs.length;
    _playSong(_currentIndex);
  }

  void _prevSong() {
    _currentIndex = (_currentIndex - 1 + songs.length) % songs.length;
    _playSong(_currentIndex);
  }

  void _shuffleSong() {
    _currentIndex = Random().nextInt(songs.length);
    _playSong(_currentIndex);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget getImage() {
    if (songMetadata.picture == null) {
      return Icon(Icons.music_note_sharp, size: 200, color: Colors.red);
    }
    return Image.memory(
      songMetadata.picture!.bytes,
      width: 400,
      height: 400,
      fit: BoxFit.cover
    );
  }

  Widget getDetails() {

    String title = (songMetadata.title == null) ? "Unknown Title" : songMetadata.title!;

    String artist = (songMetadata.trackArtist == null) ? "Unknown Artist" : songMetadata.trackArtist!;

    String album = (songMetadata.album == null) ? "Unknown Album" : songMetadata.album!;

    return Column (
      children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        Text(artist, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
        Text(album, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Music Player', style: TextStyle(color: Colors.white)),
            Text(
              'Activity 1',
              style: TextStyle(color: Colors.white, fontSize: 14.0, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        toolbarHeight: 80,
        toolbarOpacity: 0.5,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getImage(),
              SizedBox(height: 20),
              getDetails(),

              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.library_music),
                    iconSize: 30,
                    color: Colors.red,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongListPage(
                            songs: songs,
                            onSongSelected: _playSong,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 40,
                    onPressed: _prevSong,
                    color: Colors.red,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                    iconSize: 50,
                    onPressed: _togglePlayPause,
                    color: Colors.red,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 40,
                    onPressed: _nextSong,
                    color: Colors.red,
                  ),
                  IconButton(
                    icon: Icon(Icons.shuffle),
                    iconSize: 30,
                    onPressed: _shuffleSong,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

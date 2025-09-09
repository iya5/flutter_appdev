import 'package:flutter/cupertino.dart';
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

/* Im getting the music file metadata using audio tags: link in readme */
class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  //int? year;
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
  Duration _duration = Duration.zero; 
  Duration _position = Duration.zero;

  bool _isPlaying = false;
  
  String? currentTitle;
  String? currentTrackArtist;
  String? currentAlbum;
  int? currentYear;
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
  /* This is just to play the song immediately after clicking activity */
  void initState() { 
    super.initState();
    _currentIndex = 0;

    _preload();

    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });

    /* Listen to audio duration and position for the slider: audiotags */
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

  }

  
  /* used this for preloading metadata */
  Future<void> _preload() async {
    await _getMetadata(_currentIndex);

    await _audioPlayer.setSource(
      AssetSource((songs[_currentIndex].replaceFirst("assets/", "")))
    );
  }

  /* used this for showing metadata */
  Future<void> _getMetadata(int index) async { 
    Tag? tag = await AudioTags.read(songs[index]);

    setState(() {
      songMetadata.title = tag?.title;
      songMetadata.trackArtist = tag?.trackArtist;
      songMetadata.album = tag?.album;
      //songMetadata.year = tag?.year;
      List<Picture>? pictures = tag?.pictures;
      songMetadata.picture = pictures?[0];
    });
  }
  

  Future<void> _playSong(int index) async {
    /* await is necessary to get metadata before rebuilding ui and playing song */
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
      width: 500,
      height: 500,
      fit: BoxFit.cover
    );
  }

  Widget getDetails() {

    String title = (songMetadata.title == null) ? "Unknown Title" : songMetadata.title!;
    String artist = (songMetadata.trackArtist == null) ? "Unknown Artist" : songMetadata.trackArtist!;
    String album = (songMetadata.album == null) ? "Unknown Album" : songMetadata.album!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4), 
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              artist,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              " - ",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              album,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ],
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.clear_thick, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Music Player', style: TextStyle(color: Colors.white)),
            Text(
              'Activity 1',
              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        toolbarHeight: 80,
        toolbarOpacity: 0.5,
      ),



      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 550,
            height: double.infinity,
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        getImage(),
                        SizedBox(height: 20),
                        getDetails(),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color.fromARGB(255, 255, 255, 255),           
                                inactiveTrackColor: const Color.fromARGB(255, 86, 86, 86),          
                                thumbColor: const Color.fromARGB(255, 255, 255, 255),                
                                overlayColor: const Color.fromARGB(255, 255, 255, 255).withAlpha(32),
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                              ),
                              child: Slider(
                                min: 0,
                                max: _duration.inSeconds.toDouble(),
                                value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                                onChanged: (value) async {
                                  final position = Duration(seconds: value.toInt());
                                  await _audioPlayer.seek(position);
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10), 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatTime(_position),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    formatTime(_duration),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.list_bullet),
                        iconSize: 30,
                        color: Colors.white,
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
                        icon: Icon(CupertinoIcons.backward_fill),
                        iconSize: 40,
                        onPressed: _prevSong,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid),
                        iconSize: 50,
                        onPressed: _togglePlayPause,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(CupertinoIcons.forward_fill),
                        iconSize: 40,
                        onPressed: _nextSong,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(CupertinoIcons.shuffle),
                        iconSize: 30,
                        onPressed: _shuffleSong,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
        ),



      ),
    );
  }
   String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

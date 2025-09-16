import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'dart:math';
//import 'dart:typed_data';
import 'songListPage.dart';

// ======================= WIDGET =======================
class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

// ======================= DATA STRUCTURES =======================
/* Im getting the music file metadata using audio tags: links will be in readme*/
class Song {
  SongMetadata metadata;
  String path;

  Song(
    this.metadata,
    this.path,
  );
}

// struct for the meta data and then wrap the data of the song player
// https://medium.com/@suatozkaya/dart-constructors-101-69c5b9db5230
class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  int? year;
  Picture? picture;

  // https://dart.dev/language/constructors#generative-constructors
  // creating a constructor for the "struct"
  SongMetadata(
    this.title,
    this.trackArtist,
    this.album,
    this.year,
    this.picture,
  );
}

// ======================= STATE CLASS =======================
class _MusicPlayerState extends State<Activity1> {
  // ---------- Variables ----------
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<Song> songs;

  int _currentIndex = 0;
  Duration _duration = Duration.zero; 
  Duration _position = Duration.zero;

  bool _isPlaying = false;

  // docs: https://api.flutter.dev/flutter/dart-async/StreamSubscription-class.html
  late StreamSubscription<Duration> _durationListener;
  late StreamSubscription<Duration> _positionListener;
  late StreamSubscription<void> _completionListener;
  
  String? currentTitle;
  String? currentTrackArtist;
  String? currentAlbum;
  int? currentYear;
  Picture? picture;

  final List<String> _songPaths = [
    "assets/music/AVOCADO (feat. Gliiico).mp3",
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

  // ======================= INIT & DISPOSE =======================
  @override 
  void initState() { 
    super.initState();
    _currentIndex = 0;
    songs = [];

    _initPlayer();  

    _completionListener = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) _nextSong();
    });

    _durationListener = _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });

    _positionListener = _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel listeners before disposing so it wont crash my app T_T
    _durationListener.cancel();
    _positionListener.cancel();
    _completionListener.cancel();

    _audioPlayer.dispose();
    super.dispose();
  }

  // ======================= SONG LOADING =======================
  Future<void> _initPlayer() async {
    await _getSongs(_songPaths);

    if (songs.isNotEmpty) {
      await _audioPlayer.setSource(
        AssetSource(songs[0].path),
      );

      setState(() {
        _currentIndex = 0;
      });
    }
  }

  Future<void> _getSongs(List<String> songPaths) async {
    for (int i = 0; i < songPaths.length; i++) {
      Tag? tag = await AudioTags.read(songPaths[i]);
      SongMetadata metadata = SongMetadata(null, null, null, null, null);

      metadata.title = tag?.title;
      metadata.trackArtist = tag?.trackArtist;
      metadata.album = tag?.album;
      metadata.year = tag?.year;
      List<Picture>? pictures = tag?.pictures;
      metadata.picture = pictures?[0];

      Song song = Song(
        metadata,
        songPaths[i].replaceFirst("assets/", ""),
      );
      songs.add(song);
    }
  }

  // ======================= PLAYER CONTROLS =======================
  Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].path));
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

  // ======================= UI HELPERS =======================
  Widget getImage() {
    if (songs.isEmpty) {
      return Icon(Icons.music_note, size: 100,);
    }

    SongMetadata metadata = songs[_currentIndex].metadata; 
    if (metadata.picture == null) {
      return Icon(Icons.music_note, size: 100,);
    }

    return Image.memory(
      metadata.picture!.bytes,
      width: 500,
      height: 500,
      fit: BoxFit.cover
    );
  }

  Widget getDetails() {
    if (songs.isEmpty) {
      return const Text(
        "Loading...",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white,),
      );
    }

    SongMetadata metadata = songs[_currentIndex].metadata; 
    String title =  (metadata.title == null) ? "Unknown" : metadata.title!;
    String artist = (metadata.trackArtist == null) ? "Unknown" : metadata.trackArtist!;
    String album = (metadata.album == null) ? "Unknown" : metadata.album!;
    
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

  // ======================= BUILD METHOD =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        
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

      // ---------- Body ----------
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
                  // ---------- Image & Details ----------
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

                  // ---------- Slider ----------
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

                  // ---------- Controls ----------
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
                                songs: _songPaths,
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

  // ======================= FORMAT TIME =======================
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

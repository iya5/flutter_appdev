import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audiotags/audiotags.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import 'song_list_page.dart';
import 'song_model.dart';
import 'widgets/song_cover.dart';
import 'widgets/song_details.dart';
import 'widgets/player_controls.dart';



class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<Activity1> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<Song> songs;

  int _currentIndex = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool _isPlaying = false;
  bool _showSongList = false;
  bool _isShuffle = false;

  late StreamSubscription<Duration> _durationListener;
  late StreamSubscription<Duration> _positionListener;
  late StreamSubscription<void> _completionListener;

  String? currentTitle;
  String? currentTrackArtist;
  String? currentAlbum;
  int? currentYear;
  Picture? picture;

  final List<String> _songPaths = SongRepository.songPaths;


  // ======================= INIT & DISPOSE =======================
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    songs = [];

    _initPlayer();

    _completionListener = _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;

      //auto-play on by default
      if (_isShuffle) {
        _shuffleSong();
      } else {
        _nextSong();
      }
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
    _durationListener.cancel();
    _positionListener.cancel();
    _completionListener.cancel();

    _audioPlayer.dispose();
    super.dispose();
  }

  /* 
  The garbage collector doesn't force delete the widget immediately,
  so doing dispose on the listeners isn't enough, it will crash my app.

  AudioPlayer streams (onPositionChanged, onDurationChanged, etc.)
  keep firing even after the widget is disposed. The object stays around 
  because the stream listener is still holding a reference.

  When the callback calls setState() on a disposed widget,
  Flutter throws an error (similar in spirit to a segfault).
  That’s why the recommended solution is to cancel those listeners in 
  dispose() and/or guard with if (mounted) before calling setState() to
  free the widget from gc and stray events.

  subscription (or “listener”) is the link between the stream and callback.
  */

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
    try {
      Tag? tag = await AudioTags.read(songPaths[i]);

      if (tag == null) {
        continue;
      }

      SongMetadata metadata = SongMetadata(
        tag.title,
        tag.trackArtist,
        tag.album,
        tag.year,
        tag.pictures.isNotEmpty ? tag.pictures[0] : null,
      );

      Song song = Song(
        metadata,
        songPaths[i].replaceFirst("assets/", ""),
      );
      songs.add(song);
    } catch (e) {
      continue;
    }
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

// updated functions to respect the shuffle
  void _nextSong() {
    if (_isShuffle) {
      _shuffleSong(); 
    } else {
      _currentIndex = (_currentIndex + 1) % songs.length;
      _playSong(_currentIndex);
    }
  }

  void _prevSong() {
    if (_isShuffle) {
      _shuffleSong(); 
    } else {
      _currentIndex = (_currentIndex - 1 + songs.length) % songs.length;
      _playSong(_currentIndex);
    }
  }

  void _shuffleSong() {
    if (songs.length <= 1) return;

    int newIndex = _currentIndex;
    while (newIndex == _currentIndex) {
      newIndex = Random().nextInt(songs.length);
    }

    _playSong(newIndex);
  }

  // ======================= BUILD METHOD =======================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double smallCoverSize = (screenWidth * 0.1).clamp(70.0, 120.0);
    final double coverSize = min(screenWidth * 0.5, screenHeight * 0.5).clamp(70.0, 600.0);

    // ---------- song list ----------
    final double minScalingFactor = 0.1; // x
    final double maxScalingFactor = 0.99; // y

    final double minScreenHeight = 400.0; // a
    final double maxScreenHeight = 1200.0; // b

    // x + ((screeHeight - a) / (b - a)) * (x - y)
    double baseScaling = minScalingFactor + ((screenHeight - minScreenHeight) /
      (maxScreenHeight - minScreenHeight)) * (maxScalingFactor - minScalingFactor);

    baseScaling = baseScaling.clamp(minScalingFactor, maxScalingFactor);

    final double minListHeight = screenHeight * 0.01; 
    final double maxListHeight = screenHeight * 0.55; 

    double songListHeight = (screenHeight * baseScaling).clamp(minListHeight, maxListHeight);


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    // -------------------------- appbar --------------------------
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear_thick, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Music Player', style: AppTextStyles.title),
            Text(
              'Activity 1',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 145, 0),
        toolbarHeight: 70,
        toolbarOpacity: 1.0,
        elevation: 0, 
      ),

    // -------------------------- body --------------------------
       body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 213, 0),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: (screenWidth * 0.03).clamp(4.0, 10.0), 
            vertical: (screenHeight * 0.5).clamp(30.0, 60.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ 
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600, 
                  maxHeight: 1000
                ),
                child: Container(
                  
                  padding: EdgeInsets.symmetric(
                    horizontal: (screenWidth * 0.03).clamp(4.0, 10.0),
                    vertical: (screenHeight * 0.02).clamp(4.0, 10.0),
                  ),
                  color: const Color.fromARGB(255, 157, 255, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ---------- Img&Details metadata and songlist container ----------
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ---------- Image & Details ----------
                            Container(
                              constraints: const BoxConstraints(
                                minWidth: 200.0,
                              ),
                              width: double.infinity,
                              color: const Color.fromARGB(255, 0, 94, 255),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: _showSongList
                                  ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: smallCoverSize,
                                          width: smallCoverSize,
                                          child: SongCover(
                                            song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                            size: smallCoverSize,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              SongDetails(
                                                song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                              )
                                            ]
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: coverSize,
                                          width: coverSize,
                                          child: SongCover(
                                            song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                            size: coverSize, 
                                          ),
                                        ),
                                        SizedBox(height: (screenHeight * 0.02).clamp(5.0, 15.0)),
                                        SongDetails(
                                          song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                        ),
                                      ],
                                    ),
                            ),


                            // ---------- Song List ----------
                            if (_showSongList)
                              Container(
                                height: songListHeight,
                                color: const Color.fromARGB(255, 0, 0, 255),
                                child: SongListPage(
                                  songs: songs,
                                  onSongTap: _playSong,
                                ),
                              ),

                          ],
                        ),
                        
                      

                      const SizedBox(height: 8),

                      // ---------- Player Controls ----------
                      PlayerControls(
                          isPlaying: _isPlaying,
                          isShuffle: _isShuffle,
                          showSongList: _showSongList,
                          playSong: _playSong,
                          nextSong: _nextSong,
                          previousSong: _prevSong,
                          togglePlayPause: _togglePlayPause,
                          shuffleSong: () {
                            setState(() => _isShuffle = !_isShuffle);
                          },
                          toggleSongList: () {
                            setState(() => _showSongList = !_showSongList);
                          },
                          position: _position,
                          duration: _duration,
                          onSeek: (pos) async {
                            await _audioPlayer.seek(pos);
                          },
                        ),



                    ],
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
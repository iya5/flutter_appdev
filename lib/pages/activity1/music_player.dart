import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audiotags/audiotags.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import 'song_list_page.dart';
import 'song_model.dart';
import 'widgets/song_cover.dart';
import 'widgets/song_details.dart';
import 'widgets/controls.dart';
import '/styles/app_sizes.dart';
import '/styles/color_palette.dart';
import 'widgets/controls_secondary.dart';
import 'services/song_service.dart';

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
  int _loopMode = 0; 

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

      if (_loopMode == 1) {
        _playSong(_currentIndex);
      } else if (_loopMode == 2) {
        _nextSong();
      } else {
        if (_isShuffle) {
          _shuffleSong();
        } else {
          _nextSong();
        }
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

  // ======================= SONG LOADING =======================
  Future<void> _initPlayer() async {
    songs = await SongService.loadSongs(_songPaths);

    if (songs.isNotEmpty) {
      await _audioPlayer.setSource(
        AssetSource(songs[0].path),
      );

      setState(() {
        _currentIndex = 0;
      });
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

  void _toggleLoopMode() {
    setState(() {
      _loopMode = (_loopMode + 1) % 3;
    });
  }

  // ======================= BUILD METHOD =======================
  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final bool isWide = sizes.screenWidth > 900; // breakpoint

    return Scaffold(
      backgroundColor: ColorPalette.background,

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
            Text('Activity 1', style: AppTextStyles.caption),
          ],
        ),
        backgroundColor: ColorPalette.background,
        toolbarHeight: 70,
        elevation: 0,
      ),

      // -------------------------- body --------------------------
      body: isWide
          // ========== WIDE SCREEN ==========
          ? Row(
              children: [
                // ---------- L Main Player ----------
                Expanded(
                  flex: 2,
                  child: _buildMainPlayer(sizes, alwaysShowList: false, isWide: isWide),
                ),

                // ---------- R Song List ----------
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    color: const Color.fromARGB(255, 0, 0, 255),
                    child: SongListPage(
                      songs: songs,
                      onSongTap: _playSong,
                    ),
                  ),
                ),
              ],
            )

          // ========== NARROW SCREEN ==========
          : Center(
            child: _buildMainPlayer(sizes, alwaysShowList: true, isWide: isWide),
          ),
    );
  }

  Widget _buildMainPlayer(AppSizes sizes, {required bool alwaysShowList, required bool isWide}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 213, 0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: (sizes.screenHeight * 0.03).clamp(4.0, 50.0),
      ),
      
      child: Align(
        alignment: Alignment.bottomCenter,
        
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
          
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: (sizes.screenWidth * 0.02).clamp(1.0, 10.0),
              vertical: (sizes.screenHeight * 0.01).clamp(1.0, 10.0),
            ),
            color: const Color.fromARGB(255, 157, 255, 0), 
            
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                
                Expanded(child: Container(color: Colors.transparent)),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 200.0),
                        width: double.infinity,
                        color: const Color.fromARGB(255, 0, 94, 255),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: (_showSongList && alwaysShowList)
                            // Wide layout: Green + Pink (Purple inside Pink) row
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Green section
                                  SizedBox(
                                    height: sizes.smallCoverSize,
                                    width: sizes.smallCoverSize,
                                    child: SongCover(
                                      song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                      size: sizes.smallCoverSize,
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
                                      ],
                                    ),
                                  ),

                                  if (isWide)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (sizes.screenWidth * 0.02).clamp(1.0, 10.0),
                                        vertical: (sizes.screenHeight * 0.3).clamp(1.0, 10.0),
                                      ),
                                      child: Container(
                                        width: 200, // fixed width for song list
                                        color: Colors.pink,
                                        child: Container(
                                          color: Colors.purple,
                                          height: sizes.songListHeight,
                                          child: SongListPage(
                                            songs: songs,
                                            onSongTap: _playSong,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            // Narrow layout: vertical stack
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: sizes.coverSize,
                                    width: sizes.coverSize,
                                    child: SongCover(
                                      song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                      size: sizes.coverSize,
                                    ),
                                  ),
                                  SizedBox(height: (sizes.screenHeight * 0.02).clamp(5.0, 15.0)),
                                  SongDetails(
                                    song: songs.isNotEmpty ? songs[_currentIndex] : null,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    // Only show song list below in narrow mode
                    if (_showSongList && alwaysShowList && !isWide)
                      Container(
                        height: sizes.songListHeight,
                        color: const Color.fromARGB(255, 0, 0, 255),
                        child: SongListPage(
                          songs: songs,
                          onSongTap: _playSong,
                        ),
                      ),

                    const SizedBox(height: 8),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PlayerControls(
                          isPlaying: _isPlaying,
                          isShuffle: _isShuffle,
                          showSongList: _showSongList,
                          playSong: _playSong,
                          nextSong: _nextSong,
                          previousSong: _prevSong,
                          togglePlayPause: _togglePlayPause,
                          shuffleSong: () => setState(() => _isShuffle = !_isShuffle),
                          toggleSongList: () => setState(() => _showSongList = !_showSongList),
                          position: _position,
                          duration: _duration,
                          onSeek: (pos) async => await _audioPlayer.seek(pos),
                          loopMode: _loopMode,
                          toggleLoopMode: _toggleLoopMode,
                        ),

                        SizedBox(height: (sizes.screenHeight * 0.01).clamp(5.0, 15.0)),

                        PlayerControlsSecondary(
                          showSongList: _showSongList,
                          toggleSongList: () => setState(() => _showSongList = !_showSongList),
                        ),
                      ],
                    ),
                   ),


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


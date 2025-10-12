import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import 'song_list_page.dart';
import 'song_model.dart';
import 'widgets/song_cover.dart';
import 'widgets/song_details.dart';
import 'widgets/controls.dart';
import '/styles/app_sizes.dart';
import '/styles/color_palette.dart';
import '../../styles/music_player_bg.dart';
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

  final List<String> _songPaths = SongRepository.songPaths;

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
  @override
  void dispose() {
    _durationListener.cancel();
    _positionListener.cancel();
    _completionListener.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }


  // ================================= player controls
  Future<void> _initPlayer() async {
    songs = await SongService.loadSongs(_songPaths);

    if (songs.isNotEmpty) {
      await _audioPlayer.setSource(AssetSource(songs[0].path));
      await MusicPlayerBackground.updateFromSong(songs[0]);
      await GradientBackground.updateFromSong(songs[0]);

      setState(() {
        _currentIndex = 0;
      });
    }
  }

  Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].path));
    await MusicPlayerBackground.updateFromSong(songs[index]);
    await GradientBackground.updateFromSong(songs[index]);

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


  // =========================== build
  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final bool isWide = sizes.screenWidth > 900;

    return Scaffold(
      backgroundColor: ColorPalette.musicPlayerBG,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear_thick, color: ColorPalette.iconPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Music Player', style: AppTextStyles.title),
            Text('Activity 1', style: AppTextStyles.caption),
          ],
        ),
        backgroundColor: ColorPalette.musicPlayerBG,
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: _buildMainPlayer(sizes, alwaysShowList: true, isWide: isWide),
    );
  }

  Widget _buildMainPlayer(AppSizes sizes,
      {required bool alwaysShowList, required bool isWide}) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorPalette.musicPlayerGradient,
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
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
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: (isWide)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: sizes.coverSize,
                                        width: sizes.coverSize,
                                        child: SongCover(
                                          song: songs.isNotEmpty
                                              ? songs[_currentIndex]
                                              : null,
                                          size: sizes.coverSize,
                                        ),
                                      ),
                                      SizedBox(
                                          height: (sizes.screenHeight * 0.02)
                                              .clamp(5.0, 15.0)),
                                      SongDetails(
                                        song: songs.isNotEmpty
                                            ? songs[_currentIndex]
                                            : null,
                                      ),
                                    ],
                                  )
                                : (_showSongList && alwaysShowList)
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: sizes.smallCoverSize,
                                            width: sizes.smallCoverSize,
                                            child: SongCover(
                                              song: songs.isNotEmpty
                                                  ? songs[_currentIndex]
                                                  : null,
                                              size: sizes.smallCoverSize,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 4),
                                                SongDetails(
                                                  song: songs.isNotEmpty
                                                      ? songs[_currentIndex]
                                                      : null,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: sizes.coverSize,
                                            width: sizes.coverSize,
                                            child: SongCover(
                                              song: songs.isNotEmpty
                                                  ? songs[_currentIndex]
                                                  : null,
                                              size: sizes.coverSize,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  (sizes.screenHeight * 0.02)
                                                      .clamp(5.0, 15.0)),
                                          SongDetails(
                                            song: songs.isNotEmpty
                                                ? songs[_currentIndex]
                                                : null,
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        if (_showSongList && alwaysShowList && !isWide)
                          Container(
                            height: sizes.songListHeight,
                            color: Colors.transparent,
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
                                shuffleSong: () =>
                                    setState(() => _isShuffle = !_isShuffle),
                                toggleSongList: () =>
                                    setState(() => _showSongList = !_showSongList),
                                position: _position,
                                duration: _duration,
                                onSeek: (pos) async =>
                                    await _audioPlayer.seek(pos),
                                loopMode: _loopMode,
                                toggleLoopMode: _toggleLoopMode,
                              ),
                              SizedBox(
                                  height: (sizes.screenHeight * 0.01)
                                      .clamp(5.0, 15.0)),
                              PlayerControlsSecondary(
                                showSongList: _showSongList,
                                toggleSongList: () =>
                                    setState(() => _showSongList = !_showSongList),
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
            if (isWide)
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                  child: SongListPage(
                    songs: songs,
                    onSongTap: _playSong,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

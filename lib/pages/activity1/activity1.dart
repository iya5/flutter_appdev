import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audiotags/audiotags.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import 'song_list_widget.dart';
import 'song_model.dart';

// ======================= WIDGET =======================
class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
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

  final List<String> _songPaths = [
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

  // ======================= INIT & DISPOSE =======================
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    songs = [];

    _initPlayer();

    _completionListener = _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;

      if (_isShuffle) {
        _shuffleSong(); // auto-play random song if shuffle is on
      }
      // if shuffle is off, stop at the end :>
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

  // ======================= UI HELPERS =======================
  Widget getImage() {
    if (songs.isEmpty) {
      return const Icon(Icons.music_note, size: 100);
    }

    SongMetadata metadata = songs[_currentIndex].metadata;
    if (metadata.picture == null) {
      return const Icon(Icons.music_note, size: 100);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.memory(
        metadata.picture!.bytes,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getDetails() {
    if (songs.isEmpty) {
      return const Text(
        "Loading...",
        style: AppTextStyles.subtitle,
      );
    }

    SongMetadata metadata = songs[_currentIndex].metadata;
    String title = (metadata.title == null) ? "Unknown" : metadata.title!;
    String artist =
        (metadata.trackArtist == null) ? "Unknown" : metadata.trackArtist!;
    String album =
        (metadata.album == null) ? "Unknown" : metadata.album!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              artist,
              style: AppTextStyles.subtitle2,
            ),
            const Text(
              " - ",
              style: AppTextStyles.body2,
            ),
            Text(
              album,
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ],
    );
  }

  // // ======================= BUILD METHOD =======================
  @override
  Widget build(BuildContext context) {
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
          children: const [
            Text('Music Player', style: AppTextStyles.title),
            Text(
              'Activity 1',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        toolbarHeight: 80,
        toolbarOpacity: 1.0,
        elevation: 0, 
      ),

    // -------------------------- body --------------------------
      body: Container(
        decoration: const BoxDecoration(
          color: ColorPalette.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: 550,
            height: double.infinity,
            color: ColorPalette.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ---------- Img&Details metadata and songlist container ----------
                Container(
                  width: 500,        
                  height: 600, 
                  decoration: BoxDecoration(
                    color: ColorPalette.background,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ---------- Image & Details ----------
                      Container(
                        color: ColorPalette.background,
                        padding: const EdgeInsets.all(5),
                        child: _showSongList
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: getImage(),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        getDetails()
                                      ]
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: getImage(),
                                  ),
                                  const SizedBox(height: 20),
                                  getDetails(),
                                ],
                              ),
                      ),

                      const SizedBox(height: 1),

                      // ---------- Song List ----------
                      if (_showSongList)
                        Container(
                          height: 477,
                          color: ColorPalette.background,
                          child: SongListWidget(
                            songs: songs,
                            onSongTap: _playSong,
                          ),
                        ),

                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ---------- Slider ----------
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: ColorPalette.sliderActive,
                        inactiveTrackColor:ColorPalette.sliderInactive,
                        thumbColor: ColorPalette.sliderActive,
                        overlayColor: const Color.fromARGB(255, 255, 255, 255)
                            .withAlpha(32),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 10),
                      ),
                      child: Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds
                            .toDouble()
                            .clamp(0, _duration.inSeconds.toDouble()),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await _audioPlayer.seek(position);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTime(_position),
                            style: AppTextStyles.caption,
                          ),
                          Text(
                            formatTime(_duration),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Controls ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.list_bullet),
                      iconSize: 20,
                      color: _showSongList ? ColorPalette.iconPrimary : ColorPalette.iconInactive,
                      onPressed: () {
                        setState(() {
                          _showSongList = !_showSongList;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(CupertinoIcons.backward_fill),
                      iconSize: 30,
                      onPressed: _prevSong,
                      color: ColorPalette.iconPrimary
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(_isPlaying
                          ? CupertinoIcons.pause_solid
                          : CupertinoIcons.play_arrow_solid),
                      iconSize: 45,
                      onPressed: _togglePlayPause,
                      color: ColorPalette.iconPrimary
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(CupertinoIcons.forward_fill),
                      iconSize: 30,
                      onPressed: _nextSong,
                      color: ColorPalette.iconPrimary
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.shuffle,
                        color: _isShuffle ? ColorPalette.iconPrimary : ColorPalette.iconInactive,
                      ),
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          _isShuffle = !_isShuffle;
                        });
                      },
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

  // ======================= FORMAT TIME =======================
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
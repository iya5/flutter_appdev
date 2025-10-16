import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_appdev/pages/activity1/music_service.dart';
import 'package:flutter_appdev/pages/activity1/song_list_page.dart';
import 'package:flutter_appdev/pages/activity1/widgets/controls.dart';
import 'package:flutter_appdev/pages/activity1/widgets/song_cover.dart';
import 'package:flutter_appdev/pages/activity1/widgets/song_details.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import '/styles/app_sizes.dart';
import 'song.dart';
import '/styles/color_palette.dart';

class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<Activity1> {
  Mp3Player player = Mp3Player(audio: AudioPlayer());

  late StreamSubscription<Duration> positionListener;
  late StreamSubscription<void> completionListener;

  bool showSongList = false;

  @override
  void initState() {
    super.initState();
    player.loadSongs(songPaths);
    player.play(0);
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
    print("destroying player");
    player.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final bool isWide = sizes.screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: buildAppBar(),
      body: isWide ? buildWideLayout(sizes) : buildNormalLayout(sizes),
    );
  }

  Widget buildWideLayout(AppSizes sizes) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildSongMetadata(sizes),
            buildControls(player, sizes),
          ],
        ),
        buildSongListSectionWide()
      ]
    );
  }

  Widget buildNormalLayout(AppSizes sizes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (showSongList)
          ? buildSongMetadataSmall(sizes)
          : buildSongMetadata(sizes),
        buildSongListSection(sizes),
        buildControls(player, sizes),
        const SizedBox(height: 8),
    
      ],
    );
  }

  Widget buildControls(Mp3Player player, AppSizes sizes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerControls(player: player, updateParentWidget: () => setState(() {})),
        SizedBox(height: (sizes.screenHeight * 0.01).clamp(5.0, 15.0)),      
        PlayerControlsSecondary(
          showSongList: showSongList,
          toggleSongList: () { setState(() => showSongList = !showSongList); },
        ),
      ],
    );
  }

  Widget buildSongListSectionWide() {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.infinity,
        color: Colors.transparent,
        child: SongListPage(
          player: player,
          updateParentWidget: () => setState(() {}),
        ),
      ),
    );
  }

  Widget buildSongMetadata(AppSizes sizes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: sizes.coverSize,
          width: sizes.coverSize,
          child: SongCover(
            song: player.getCurrentSong(),
            size: sizes.coverSize,
          ),
        ),
        SizedBox(height: (sizes.screenHeight * 0.02).clamp(5.0, 15.0)),
        SongDetails(song: player.getCurrentSong()),
      ],
    );
  }

  Widget buildSongMetadataSmall(AppSizes sizes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizes.smallCoverSize,
          width: sizes.smallCoverSize,
          child: SongCover(
            song: player.getCurrentSong(),
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
                song: player.getCurrentSong()
              )
            ],
          ),
        ),
      ],
    );
  }
  
  Widget buildSongListSection(AppSizes sizes) {
    if (!showSongList) return const SizedBox(height: 0);

    return Container(
      height: sizes.songListHeight,
      color: Colors.transparent,
      child: SongListPage(
        player: player,
        updateParentWidget: () => setState(() {}),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar() {
    return AppBar(
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
      backgroundColor: ColorPalette.debugR,
      toolbarHeight: 70,
      elevation: 0,
    );
  }
}

  /* TODO
  REFACTOR ALL OF THIS
  Widget buildMainPlayer(AppSizes sizes,
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
  */

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

  @override
  void dispose() {
    print("destroying player");
    player.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final bool isWide = sizes.screenWidth > 790;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      appBar: buildAppBar(),
      /*
      body: Center(
        child: Container(
          decoration: BoxDecoration(gradient: ColorPalette.musicPlayerGradient),
          padding: const EdgeInsets.all(10),
          child: isWide ? buildWideLayout(sizes) : buildNormalLayout(sizes),
        ),
      ),
      */
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: isWide ? buildWideLayout(sizes) : buildNormalLayout(sizes)), 
      )
    );
  }

  Widget buildWideLayout(AppSizes sizes) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            
            //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // have song metadata
              // expand downwards sso that controls
              // take up the bottom of the screen only
              const Spacer(),
              buildSongCover(sizes),
              //buildSongMetadata(sizes),
              const Spacer(),
              SongDetails(song: player.getCurrentSong()),

              SizedBox(height: (sizes.screenHeight * 0.02).clamp(10.0, 15.0)),
              buildControls(player, sizes),
              const Spacer(),
            ],
          ),
        ),
        SizedBox(width: (sizes.screenWidth * 0.02).clamp(10.0, 15.0)),
        Expanded(flex: 1, child: buildSongListSectionWide()),
      ],
    );
  }


  Widget buildNormalLayout(AppSizes sizes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        (showSongList)
          ? buildSongMetadataSmall(sizes)
          : buildSongCover(sizes),
        buildSongListSection(sizes),
        if(!showSongList)
        const Spacer(),
        if (!showSongList)
        SongDetails(song: player.getCurrentSong()),

        SizedBox(height: (sizes.screenHeight * 0.02).clamp(10.0, 15.0)),
        buildControls(player, sizes),
      ],
    );
  }

  Widget buildControls(Mp3Player player, AppSizes sizes) {
    final sizes = AppSizes(context);
    final bool isWide = sizes.screenWidth > 790;
    return Container(
      width: sizes.screenWidth,
      decoration: BoxDecoration(
        color: const Color.fromARGB(144, 0, 255, 208),
      ),
      
      child: Column(
        children: [
          PlayerControls(player: player, updateParentWidget: () => setState(() {})),
          SizedBox(height: (sizes.screenHeight * 0.01).clamp(5.0, 15.0)),
          if(!isWide)
          PlayerControlsSecondary(
            showSongList: showSongList,
            toggleSongList: () { setState(() => showSongList = !showSongList); },
          ),
          
      ],
    ));
  }

  Widget buildSongListSectionWide() {
    return Container(
      height: double.infinity,
      color: const Color.fromARGB(144, 255, 153, 0),
      child: SongListPage(
        player: player,
        updateParentWidget: () => setState(() {}),
      ),
    );
  }
  Widget buildSongCover(AppSizes sizes) {
    return SizedBox(
      height: sizes.coverSize,
      width: sizes.coverSize,
      child: SongCover(
        song: player.getCurrentSong(),
        size: sizes.coverSize,
      )
    );
  }


  Widget buildSongMetadataSmall(AppSizes sizes) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200.0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
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
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
  
  Widget buildSongListSection(AppSizes sizes) {
    if (!showSongList) return const SizedBox(height: 0);

    return Container(
      height: sizes.songListHeight,
      color: const Color.fromARGB(144, 255, 153, 0),
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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      toolbarHeight: 70,
      elevation: 0,
    );
  }
}

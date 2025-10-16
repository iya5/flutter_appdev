import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/music_service.dart';
import 'package:flutter_appdev/styles/icon_sizes.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import '/styles/color_palette.dart';
import '/styles/app_sizes.dart';

String minuteSecondFormatDuration(Duration duration) {
  String min = duration.inMinutes.toString().padLeft(2, '0');
  String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return "$min:$sec";
}

class PlayerControls extends StatefulWidget {
  final Mp3Player player;
  final VoidCallback updateParentWidget;

  const PlayerControls({
    super.key,
    required this.player,
    required this.updateParentWidget
  });

  @override
  PlayerControlsState createState() => PlayerControlsState();
  
}

class PlayerControlsState extends State<PlayerControls> {
  late StreamSubscription<Duration> positionStream;
  late StreamSubscription<void> completeStream;
  late Mp3Player player;

  @override
  void initState() {
    super.initState();
    player = widget.player;
    initializeStreams();
  }

  @override
  void dispose() {
    print("freeing up streams from audio player");
    positionStream.cancel();
    completeStream.cancel();
    super.dispose();
  }

  void initializeStreams() {
    positionStream = player.audio.onPositionChanged.listen((Duration p) {
      setState(() => player.currentPosition = p);
    });

    completeStream = player.audio.onPlayerComplete.listen((_) async {
      if (player.looped == loopState.onPlaylist) {
        await player.next();
        setState(() {});
      } else if (player.looped == loopState.onSong) {
        await player.repeat();
        setState(() {});
      }
      // bug when loop state is off and song completes. unable to update button
      // when it completes(loop button)
      // do i need access to duration stream to fix this?
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);

    return Column(
      children: [
        buildPlaybackProgress(context),
        SizedBox(height: (sizes.screenHeight * 0.01).clamp(1.0, 28.0)),
        buildPlaybackControls(context),
      ]
    );
  }
  // TODO
  // when in wide mode, text is right next to each other when it shouldn't be
  Widget buildPlaybackProgress(BuildContext context) {
    return Column(
      children: [
        buildSeekbar(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minuteSecondFormatDuration(player.currentPosition), style: AppTextStyles.caption),
            Text(minuteSecondFormatDuration(player.getCurrentSong().duration), style: AppTextStyles.caption),
          ],
        )
      ]
    );
  }

  Widget buildPlaybackControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLoopButton(context),

        SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

        buildPrevButton(context),

        SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

        buildToggleResumePause(context),

        SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

        buildNextButton(context),

        SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

        buildShuffleButton(context)
      ],
    );
  }

  Widget buildLoopButton(BuildContext context) {
    IconData iconData = player.looped == loopState.onSong
      ? CupertinoIcons.repeat_1
      : CupertinoIcons.repeat;

    Color iconColor = player.looped == loopState.off
      ? ColorPalette.iconInactive
      : ColorPalette.iconPrimary;

    return IconButton(
      icon: Icon(iconData, color: iconColor),
      iconSize: AppIconSizes.outerIcon(context),
      onPressed: () async {
        await player.loopToggle();
        setState(() {});
      },
    );
  }

  Widget buildPrevButton(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.backward_fill),
      iconSize: AppIconSizes.moveIcon(context),
      color: ColorPalette.iconPrimary,
       onPressed: () async {
        await player.prev();
        widget.updateParentWidget();
       },
    );
  }

  Widget buildToggleResumePause(BuildContext context) {
    IconData iconData = player.playing 
      ? CupertinoIcons.pause_solid 
      : CupertinoIcons.play_arrow_solid;
    
    return IconButton(
      icon: Icon(iconData),
      iconSize: AppIconSizes.playIcon(context),
      color: ColorPalette.iconPrimary,
      onPressed: () async {
        await player.toggleResumePause();
        setState(() {});
      }
    );
  }

  Widget buildNextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.forward_fill),
      iconSize: AppIconSizes.moveIcon(context),
      onPressed: () async {
        await player.next();
        setState(() {});
      },
      color: ColorPalette.iconPrimary,
    );
  }

  Widget buildShuffleButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.shuffle,
        color: player.shuffled
            ? ColorPalette.iconPrimary
            : ColorPalette.iconInactive,
      ),
      iconSize: AppIconSizes.outerIcon(context),
      onPressed: () async {
        await player.toggleShuffle();
        setState(() {});
      },
    );
  }

  Widget buildSeekbar(BuildContext context) {
    double slidePos = player.currentPosition.inSeconds.toDouble();
    double slideDur = player.getCurrentSong().duration.inSeconds.toDouble();

    // force slide pos if bigger than the actual song duration (uh oh)
    // or force it to be 0 though this should never happen
    if (slidePos > slideDur) slidePos = slideDur;
    if (slidePos < 0) slidePos = 0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: ColorPalette.sliderActive,
        inactiveTrackColor: ColorPalette.sliderInactive,
        thumbColor: ColorPalette.sliderActive,
        overlayColor: const Color.fromARGB(255, 255, 255, 255).withAlpha(32),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
      ),
      child: Slider(
        min: 0,
        max: slideDur,
        value: slidePos,
        //divisions: slideDur.toInt(),
        onChanged: (value) async {
          await player.seekTo(Duration(seconds: value.toInt()));
          setState(() {});
        },
      ),
    );
  }
}


class PlayerControlsSecondary extends StatelessWidget {
  final bool showSongList;
  final VoidCallback toggleSongList;

  const PlayerControlsSecondary({
    super.key,
    required this.showSongList,
    required this.toggleSongList,
  });
  

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      
      height: sizes.bottomControlHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.moon_stars_fill), 
            iconSize: AppIconSizes.outerIcon(context),
            onPressed: () {
              // empty for now
            },
            color: ColorPalette.iconInactive, 
          ),

          IconButton(
            icon: const Icon(CupertinoIcons.list_bullet),
            iconSize: AppIconSizes.outerIcon(context),
            onPressed: toggleSongList,
            color: showSongList ? ColorPalette.iconPrimary : ColorPalette.iconInactive,
          ),
        ],
      ),

    );
  }
}
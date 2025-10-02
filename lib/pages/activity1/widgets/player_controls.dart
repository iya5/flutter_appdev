import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/styles/color_palette.dart';
import '/styles/text_styles.dart';
import '/util/util.dart';
import '/styles/icon_sizes.dart';
import '/styles/app_sizes.dart';


class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffle;
  final bool showSongList;

  final void Function(int) playSong;
  final VoidCallback nextSong;
  final VoidCallback previousSong;
  final VoidCallback togglePlayPause;
  final VoidCallback shuffleSong;
  final VoidCallback toggleSongList;
  final int loopMode;
  final VoidCallback toggleLoopMode;

  final Duration position;
  final Duration duration;
  final void Function(Duration) onSeek;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.isShuffle,
    required this.showSongList,
    required this.playSong,
    required this.nextSong,
    required this.previousSong,
    required this.togglePlayPause,
    required this.shuffleSong,
    required this.toggleSongList,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.loopMode,
    required this.toggleLoopMode,
  });
  

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);

    return Column(
      children: [
        Column(
          children: [
            SliderTheme(
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
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds
                    .toDouble()
                    .clamp(0, duration.inSeconds.toDouble()),
                onChanged: (value) {
                  onSeek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            SizedBox(
              height: AppIconSizes.sizedBoxSlider(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (sizes.screenWidth * 0.019).clamp(2.0, 20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position), style: AppTextStyles.caption),
                  Text(formatTime(duration), style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),

        SizedBox(
          height: (sizes.screenHeight * 0.01).clamp(1.0, 28.0),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                loopMode == 1
                    ? CupertinoIcons.repeat_1
                    : CupertinoIcons.repeat,
                color: loopMode == 0
                    ? ColorPalette.iconInactive
                    : ColorPalette.iconPrimary,
              ),
              iconSize: AppIconSizes.outerIcon(context),
              onPressed: toggleLoopMode,
            ),

            SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

            IconButton(
              icon: const Icon(CupertinoIcons.backward_fill),
              iconSize: AppIconSizes.moveIcon(context),
              onPressed: previousSong,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

            IconButton(
              icon: Icon(
                isPlaying
                    ? CupertinoIcons.pause_solid
                    : CupertinoIcons.play_arrow_solid,
              ),
              iconSize: AppIconSizes.playIcon(context),
              onPressed: togglePlayPause,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

            IconButton(
              icon: const Icon(CupertinoIcons.forward_fill),
              iconSize: AppIconSizes.moveIcon(context),
              onPressed: nextSong,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: AppIconSizes.sizedBoxIcon(context)),

            IconButton(
              icon: Icon(
                CupertinoIcons.shuffle,
                color: isShuffle
                    ? ColorPalette.iconPrimary
                    : ColorPalette.iconInactive,
              ),
              iconSize: AppIconSizes.outerIcon(context),
              onPressed: shuffleSong,
            ),
          ],
        ),
      ],
    );
  }
}

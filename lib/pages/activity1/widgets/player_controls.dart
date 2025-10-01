import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/styles/color_palette.dart';
import '/styles/text_styles.dart';
import '/util/util.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double sizedBoxSlider = (screenHeight * 0.01).clamp(1.0, 12.0);
    final double sizedBoxIcon = (screenWidth * 0.03).clamp(1.0, 50.0);
    final double outerIconSize = (screenWidth * 0.05).clamp(8.0, 24.0);
    final double moveIconSize = (screenWidth * 0.07).clamp(12.0, 36.0);
    final double playIconSize = (screenWidth * 0.1).clamp(16.67, 50.0);

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
              height: sizedBoxSlider,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (screenWidth * 0.019).clamp(2.0, 20.0),
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
          height: (screenHeight * 0.01).clamp(1.0, 28.0),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.list_bullet),
              iconSize: outerIconSize,
              color: showSongList
                  ? ColorPalette.iconPrimary
                  : ColorPalette.iconInactive,
              onPressed: toggleSongList,
            ),

            SizedBox(width: sizedBoxIcon),

            IconButton(
              icon: const Icon(CupertinoIcons.backward_fill),
              iconSize: moveIconSize,
              onPressed: previousSong,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: sizedBoxIcon),

            IconButton(
              icon: Icon(
                isPlaying
                    ? CupertinoIcons.pause_solid
                    : CupertinoIcons.play_arrow_solid,
              ),
              iconSize: playIconSize,
              onPressed: togglePlayPause,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: sizedBoxIcon),

            IconButton(
              icon: const Icon(CupertinoIcons.forward_fill),
              iconSize: moveIconSize,
              onPressed: nextSong,
              color: ColorPalette.iconPrimary,
            ),

            SizedBox(width: sizedBoxIcon),

            IconButton(
              icon: Icon(
                CupertinoIcons.shuffle,
                color: isShuffle
                    ? ColorPalette.iconPrimary
                    : ColorPalette.iconInactive,
              ),
              iconSize: outerIconSize,
              onPressed: shuffleSong,
            ),
          ],
        ),
      ],
    );
  }
}

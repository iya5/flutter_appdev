import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/styles/color_palette.dart';
import '/styles/icon_sizes.dart';
import '/styles/app_sizes.dart';
import '/styles/music_player_background.dart';


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
        color: ColorPalette.musicPlayerBG,
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
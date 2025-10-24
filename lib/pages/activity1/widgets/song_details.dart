import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/song.dart';
import '/styles/text_styles.dart';
import '/styles/color_palette.dart';

class SongDetails extends StatelessWidget {
	final Song song;
  final ColorPalette palette; 

	const SongDetails({
		super.key,
		required this.song,
		required this.palette
	});

	@override
	Widget build(BuildContext context) {
    

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          style: AppTextStyles.title(palette: palette),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              song.artist,
              style: AppTextStyles.subtitle2(palette: palette),
            ),
             Text(
              " - ",
              style: AppTextStyles.body2(palette: palette),
            ),
            Text(
              song.album,
              style: AppTextStyles.body2(palette: palette),
            ),
          ],
        ),
      ],
    );
  }
}
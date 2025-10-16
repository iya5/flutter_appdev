import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/song.dart';
import '/styles/text_styles.dart';

class SongDetails extends StatelessWidget {
	final Song song;

	const SongDetails({
		super.key,
		required this.song
	});

	@override
	Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              song.artist,
              style: AppTextStyles.subtitle2,
            ),
             Text(
              " - ",
              style: AppTextStyles.body2,
            ),
            Text(
              song.album,
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../song_model.dart';
import '/styles/text_styles.dart';

class SongDetails extends StatelessWidget {
	final Song? song;

	const SongDetails({
		super.key,
		this.song
	});

	@override
	Widget build(BuildContext context) {
		if (song == null) {
			return Text(
				"Loading...",
				style: AppTextStyles.subtitle,
			);
		}

    SongMetadata metadata = song!.metadata;
    String title = metadata.title ?? "Unknown";
    String artist = metadata.trackArtist ?? "Unknown";
    String album = metadata.album ?? "Unknown";

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
             Text(
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
}
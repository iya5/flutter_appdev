import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/song.dart';

class SongCover extends StatelessWidget {
	final Song song;
	final double size;

	const SongCover({super.key, required this.song, this.size = 200});

	@override
	Widget build(BuildContext context)
	{
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: size,
        height: size,
        child: song.cover,
      )

		);
	}
}
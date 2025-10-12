import 'package:flutter/material.dart';
import 'song_model.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import '/styles/app_sizes.dart';

class SongListPage extends StatefulWidget {
  final List<Song> songs;
  final void Function(int) onSongTap;

  const SongListPage({
    super.key,
    required this.songs,
    required this.onSongTap,
  });

  @override
  _SongListWidgetState createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListPage> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);

    return ListView.builder(
      itemCount: widget.songs.length,
      itemBuilder: (context, index) {
        final song = widget.songs[index];
        final songName = song.metadata.title ??
            song.path.split("/").last.replaceAll(".mp3", "");
        final artistName = song.metadata.trackArtist ?? "Unknown";

        Widget songImage;
        if (song.metadata.picture != null) {
          songImage = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              song.metadata.picture!.bytes,
              width: sizes.songImageSize,
              height: sizes.songImageSize,
              fit: BoxFit.cover,
            ),
          );
        } else {
          songImage = Container(
            width: sizes.songImageSize,
            height: sizes.songImageSize,
            color: ColorPalette.musicPlayerBG,
            child: const Icon(Icons.music_note, color: ColorPalette.iconInactive),
          );
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: GestureDetector(
            onTap: () => widget.onSongTap(index),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: sizes.verticalMargin),
              padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _hoveredIndex == index
                      ? ColorPalette.hoveredList
                      : ColorPalette.musicPlayerBG,
                  borderRadius: BorderRadius.circular(4),
                ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  songImage,
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: AppTextStyles.body,
                        ),
                        Text(
                          artistName,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
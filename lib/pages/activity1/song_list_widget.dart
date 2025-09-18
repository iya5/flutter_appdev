import 'package:flutter/material.dart';
import 'song_model.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';

class SongListWidget extends StatefulWidget {
  final List<Song> songs;
  final Function(int) onSongTap;

  const SongListWidget({
    super.key,
    required this.songs,
    required this.onSongTap,
  });

  @override
  _SongListWidgetState createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  int? _hoveredIndex; 

  @override
  Widget build(BuildContext context) {
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
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          );
        } else {
          songImage = Container(
            width: 50,
            height: 50,
            color: ColorPalette.background,
            child: const Icon(Icons.music_note, color: ColorPalette.iconInactive),
          );
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: GestureDetector(
            onTap: () => widget.onSongTap(index),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _hoveredIndex == index
                      ? ColorPalette.hoveredList
                      : ColorPalette.background,
                  borderRadius: BorderRadius.circular(4),
                ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  songImage,
                  const SizedBox(width: 10),
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

import 'package:flutter/material.dart';
import 'song_model.dart';

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
  int? _hoveredIndex; // track which item is hovered

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.songs.length,
      itemBuilder: (context, index) {
        final song = widget.songs[index];
        final songName = song.metadata.title ??
            song.path.split("/").last.replaceAll(".mp3", "");
        final artistName = song.metadata.trackArtist ?? "Unknown";

        // Image for the song
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
            color: const Color.fromARGB(255, 0, 0, 0),
            child: const Icon(Icons.music_note, color: Colors.white),
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
                      ? const Color.fromARGB(29, 234, 234, 234)
                      : const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(4),
                ),
              child: Row(
                children: [
                  songImage,
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          artistName,
                          style: const TextStyle(
                            color: Color.fromARGB(150, 255, 255, 255),
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
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

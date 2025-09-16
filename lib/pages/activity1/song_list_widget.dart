import 'package:flutter/material.dart';
import 'song_model.dart';

class SongListWidget extends StatelessWidget {
  final List<Song> songs;
  final Function(int) onSongTap;

  const SongListWidget({
    super.key,
    required this.songs,
    required this.onSongTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        String songName = songs[index].metadata.title ??
            songs[index].path.split("/").last.replaceAll(".mp3", "");
        return ListTile(
          title: Text(songName, style: TextStyle(color: Color.fromARGB(197, 255, 255, 255)),),
          onTap: () => onSongTap(index),
        );
      },
    );
  }
}

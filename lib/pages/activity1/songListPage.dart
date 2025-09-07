import 'package:flutter/material.dart';

class SongListPage extends StatelessWidget {
  final List<String> songs;
  final Function(int) onSongSelected;

  const SongListPage({super.key, required this.songs, required this.onSongSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Song List")),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          String songName = songs[index].split("/").last.replaceAll(".mp3", "");
          return ListTile(
            title: Text(songName),
            onTap: () {
              onSongSelected(index);

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
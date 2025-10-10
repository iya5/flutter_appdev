import 'package:audiotags/audiotags.dart';
import '../song_model.dart';

class SongService {
  static Future<List<Song>> loadSongs(List<String> songPaths) async {
    List<Song> songs = [];

    for (int i = 0; i < songPaths.length; i++) {
      try {
        Tag? tag = await AudioTags.read(songPaths[i]);

        if (tag == null) continue;

        SongMetadata metadata = SongMetadata(
          tag.title,
          tag.trackArtist,
          tag.album,
          tag.year,
          tag.pictures.isNotEmpty ? tag.pictures[0] : null,
        );

        Song song = Song(
          metadata,
          songPaths[i].replaceFirst("assets/", ""),
        );

        songs.add(song);
      } catch (e) {
        continue; 
      }
    }

    return songs;
  }
}

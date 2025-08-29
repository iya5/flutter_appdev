import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class Activity1 extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<Activity1>{
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isPlaying = false;

  List<String> songs = [
    "assets/music/After LIKE.mp3",
    "assets/music/Alcohol-Free.mp3",
    "assets/music/FANCY.mp3",
    "assets/music/KNOCK KNOCK.mp3",
    "assets/music/Mi Destino.mp3",
    "assets/music/OtroAtardecer.mp3",
    "assets/music/Red Velvet Psycho.mp3",
    "assets/music/Red Velvet Red Flavor.mp3",
    "assets/music/Soledad y El Mar.mp3",
    "assets/music/Tu Falta De Querer.mp3",
  ];

  Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].replaceFirst("assets/", "")));
    setState(() {
      _currentIndex = index;
      _isPlaying = true;
    });
  }

  Future<void> _togglePlayPause() async {
      if (_isPlaying){
        await _audioPlayer.pause();
      }else{
        await _audioPlayer.resume();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }

  void _nextSong(){
    int i = (_currentIndex + 1) % songs.length;
    _playSong(i);
  }

  void _prevSong(){
    int i = (_currentIndex - 1) % songs.length;
    _playSong(i);
  }
  
  void _shuffleSong(){
    int i = Random().nextInt(songs.length);
    _playSong(i);
  }

  void _dispose(){
    setState(() {
      _audioPlayer.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player")
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.accessibility, size: 100, color: Colors.blue),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.library_music),
                    iconSize: 25,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongListPage(songs: songs, onSongSelected: _playSong,),
                        ),
                      ),
                    },),
                  IconButton(icon: Icon(Icons.skip_previous), iconSize: 25, onPressed: _prevSong,),
                  IconButton(icon: Icon(Icons.play_circle), iconSize: 25, onPressed: _togglePlayPause,),
                  IconButton(icon: Icon(Icons.skip_next), iconSize: 25, onPressed: _nextSong,),
                  IconButton(icon: Icon(Icons.shuffle), iconSize: 25, onPressed: _shuffleSong,),

                ]
              
              )
            ],
          ),
        ),
    );
  }

}

class SongListPage extends StatelessWidget{
  final List<String> songs;
  final Function(int) onSongSelected;

  SongListPage({required this.songs, required this.onSongSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index){
          String songName = songs[index].split("/").last;

          return ListTile(
            title: Text(songName),
            onTap: () => onSongSelected(index),
          );

        }
     )
    );
  }
}
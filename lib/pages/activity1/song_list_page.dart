import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/music_service.dart';
import 'package:flutter_appdev/pages/activity1/widgets/song_cover.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';
import '/styles/app_sizes.dart';

class SongListPage extends StatefulWidget {
  final Mp3Player player;
  final VoidCallback updateParentWidget;
  final bool lightMode;

  const SongListPage({
    super.key,
    required this.player,
    required this.lightMode,
    required this.updateParentWidget,
  });

  @override
  SongListWidgetState createState() => SongListWidgetState();
}

class SongListWidgetState extends State<SongListPage> {
  int? hoveredIndex;
  
  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
  final palette = widget.lightMode ? ColorPalette.light : ColorPalette.dark;

    return ListView.builder(
      itemCount: widget.player.songs.length,
      itemBuilder: (context, index) {
        final song = widget.player.songs[index];
        
        Widget songCover = SongCover(song: song);

        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          child: GestureDetector(
            onTap: () async {
              await widget.player.play(index);
              widget.updateParentWidget();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: sizes.verticalMargin),
              padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: hoveredIndex == index
                      ? palette.hoveredList
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: songCover
                  )
                  ,
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: AppTextStyles.body(palette: palette),
                        ),
                        Text(
                          song.artist,
                          style: AppTextStyles.caption(palette: palette),
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
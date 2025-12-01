import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/music_player.dart';
import 'package:flutter_appdev/pages/activity2/activity2.dart';
import 'package:flutter_appdev/pages/unused_pages/activity3.dart';
import 'package:flutter_appdev/pages/unused_pages/activity4.dart';
import 'package:flutter_appdev/components/activitycards.dart';
import '/styles/text_styles.dart';
import '/styles/color_palette.dart';

// https://docs.flutter.dev/ui/adaptive-responsive

class Homepage extends StatelessWidget {
  const Homepage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.dark; 
    const String appTitle = 'lab_home_c';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,

      // ---------------------
      home: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: palette.background,
          toolbarHeight: 200,
          toolbarOpacity: 0.5,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Development',
                      style: AppTextStyles.headline(palette: palette),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Cruz, N. - CS302',
                      style: AppTextStyles.subtitle(palette: palette),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: GridView.extent(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    maxCrossAxisExtent: 800,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 2,
                    children: [
                      ActivityCard(
                        "Music Player",
                        "activity 1",
                        const Color(0xFFD60017),
                        "assets/images/revefinale.jpg",
                        () => Activity1(),
                        palette: palette,
                      ),
                      ActivityCard(
                        "Dino Game",
                        "activity 2",
                        Colors.purple,
                        "assets/images/bee.jpg",
                        () => GamePage(),
                        palette: palette,
                      ),
                      ActivityCard(
                        "Activity 3",
                        "hallaw",
                        Colors.orange,
                        "assets/images/bee.jpg",
                        () => Activity3(),
                        palette: palette,
                      ),
                      ActivityCard(
                        "Activity 4",
                        "shimi shimi",
                        Colors.green,
                        "assets/images/bee.jpg",
                        () => Activity4(),
                        palette: palette,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}


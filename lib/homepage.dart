import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1/music_player.dart';
import 'package:flutter_appdev/pages/unused%20pages/activity2.dart';
import 'package:flutter_appdev/pages/unused%20pages/activity3.dart';
import 'package:flutter_appdev/pages/unused%20pages/activity4.dart';
import 'package:flutter_appdev/components/activitycards.dart';
import '/styles/text_styles.dart';

// https://docs.flutter.dev/ui/adaptive-responsive

class Homepage extends StatelessWidget {
  const Homepage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'lab_home_c';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,

      /************
      ****AppBar***
      *************/
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
                      style: AppTextStyles.headline,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'C - CS302',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      // ================= BODY
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
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
                      ),
                      ActivityCard(
                        "Activity 2",
                        "wow",
                        Colors.purple,
                        "assets/images/bee.jpg",
                        () => Activity2(),
                      ),
                      ActivityCard(
                        "Activity 3",
                        "hallaw",
                        Colors.orange,
                        "assets/images/bee.jpg",
                        () => Activity3(),
                      ),
                      ActivityCard(
                        "Activity 4",
                        "shimi shimi",
                        Colors.green,
                        "assets/images/bee.jpg",
                        () => Activity4(),
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


import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1.dart';
import 'package:flutter_appdev/pages/activity2.dart';
import 'package:flutter_appdev/pages/activity3.dart';
import 'package:flutter_appdev/pages/activity4.dart';
import 'package:flutter_appdev/components/activitycards.dart';

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
        backgroundColor: const Color.fromARGB(255,17,191,255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255,17,191,255),
          toolbarHeight: 190,
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
                        print("Drawer tapped");
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        print("Settings tapped");
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'App Development',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'C - CS302',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      /************
      *****BODY****
      *************/
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                25,
              ),
              topLeft: Radius.circular(
                25,
              ),
            ),
          ),

          child: Center(
            child: GridView.extent(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              maxCrossAxisExtent: 500,
              childAspectRatio: 1.5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: [
                ActivityCard(
                  "Activity 1",
                  Colors.red,
                  () => Activity1(),
                ),
                ActivityCard(
                  "Activity 2", 
                  Colors.purple,
                  () => Activity2()
                ),
                ActivityCard(
                  "Activity 3", 
                  Colors.orange,
                  () => Activity3()
                ),
                ActivityCard(
                  "Activity 4", 
                  Colors.green,
                  () => Activity4()
                ), 
              ],
            ),
          )

        ),
      ),
    );
  }
}


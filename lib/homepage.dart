import 'package:flutter/material.dart';
import 'package:flutter_appdev/pages/activity1.dart';
import 'package:flutter_appdev/pages/activity2.dart';
import 'package:flutter_appdev/pages/activity3.dart';
import 'package:flutter_appdev/pages/activity4.dart';
//import 'package:flutter_appdev/components/cards.dart';

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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Development',
                    style: TextStyle(color: Colors.white),
              ),
              const Divider(color: Color.fromARGB(255,17,191,255)),
              Text('C - CS302',
                    style: TextStyle(color: Colors.white,fontSize: 14.0, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255,17,191,255),
          toolbarHeight: 120,
          toolbarOpacity: 0.5,
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
              padding: const EdgeInsets.all(10),
              maxCrossAxisExtent: 240,
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

class ActivityCard extends StatelessWidget{
  final String name;
  final Color cardColor;
  final Widget Function() activityLink;

  const ActivityCard(this.name, this.cardColor, this.activityLink, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // won't render the card if it's too small
        if (constraints.maxWidth < 100 || constraints.maxHeight < 90) {
          return const SizedBox(); 
        }

      return Card(
        elevation: 8,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.all(16.0),
        
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.white.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  activityLink()));
          },

        child: Padding(
          padding: EdgeInsetsGeometry.all(16.5),
          child: Text(name,style: TextStyle(color: Colors.white),),
        )

        ),
      );

    }
    );
  }
}
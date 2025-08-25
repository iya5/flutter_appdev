import 'package:flutter/material.dart';

class Activity1 extends StatelessWidget {
  const Activity1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity 1',
                  style: TextStyle(color: Colors.white),
            ),
            Text('halo halo',
                  style: TextStyle(color: Colors.white,fontSize: 14.0, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        toolbarHeight: 80,
        toolbarOpacity: 0.5,
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              30,
            ),
            topLeft: Radius.circular(
              30,
            ),
          ),
        ),
        child: Center(child: Text("Welcome to Activity 1")),
      )
    );
  }
}

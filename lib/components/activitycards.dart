import 'package:flutter/material.dart';

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
        //if (constraints.maxWidth < 100 || constraints.maxHeight < 90) {
        //  return const SizedBox(); 
        //}

      return Card(
        elevation: 8,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.all(16.0),

        
        clipBehavior: Clip.antiAlias,
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

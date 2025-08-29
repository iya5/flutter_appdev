import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget{
  final String name;
  final Color cardColor;
  final Widget Function() activityLink;

  const ActivityCard(this.name, this.cardColor, this.activityLink, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 500,    // fixed width
      //height: 150,  // fixed height
      child: Card(
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
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/sample.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,),
              ),
              Text(
                "subtitle",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,),
              )
            ],
          ), 
          
        )

        ),
      ),
    );
  }
}

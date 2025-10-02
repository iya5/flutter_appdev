import 'package:flutter/material.dart';
import '/styles/text_styles.dart';

class ActivityCard extends StatelessWidget {
  final String actTitle, subtitle, cardImage;
  final Color cardColor;
  final Widget Function() activityLink;

  const ActivityCard(
    this.actTitle,
    this.subtitle,
    this.cardColor,
    this.cardImage,
    this.activityLink, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    final double cardMargin = (screenWidth * 0.04).clamp(8.0, 24.0);
    final double cardPadding = (screenWidth * 0.04).clamp(8.0, 20.0);

    final double imageWidth = (screenWidth * 0.45).clamp(100.0, 200.0);
    final double imageBorderRadius = (screenWidth * 0.02).clamp(6.0, 12.0);


    final double spacing = (screenWidth * 0.05).clamp(10.0, 24.0);

    return SizedBox(
      child: Card(
        elevation: 8,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.all(cardMargin),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.white.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => activityLink(),
              ),
            );
          },


          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: imageWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageBorderRadius),
                    image: DecorationImage(
                      image: AssetImage(cardImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actTitle,
                        style: AppTextStyles.body,
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption2,
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

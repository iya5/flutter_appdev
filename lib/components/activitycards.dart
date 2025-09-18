import 'package:flutter/material.dart';
import 'package:flutter_appdev/styles/color_palette.dart';
import 'package:flutter_appdev/styles/text_styles.dart';

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
    return SizedBox(
      child: Card(
        elevation: 8,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(16.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor:  ColorPalette.splash.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => activityLink(),
              ),
            );
          },


          child: Padding(
            padding: const EdgeInsets.all(16.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: 170,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(cardImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        actTitle,
                        style: AppTextStyles.body,
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption2,
                      ),
                      const SizedBox(height: 10),
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

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final kBorderRadius = BorderRadius.all(Radius.circular(14.0));

  final kInfoCardTitle = TextStyle(
    color: Colors.black54,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  final kInfoCardInfoText = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 20,
  );

  InfoCard({
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      elevation: 0, //ThemeColors.isDark ? 0 : 1, //only elevate if not dark mode
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                title,
                style: kInfoCardTitle.copyWith(color: Colors.black)
            ),
            SizedBox(
              height: 2,
            ),
            Text(
                value == "null" ? "-" : value,
                style: kInfoCardInfoText.copyWith(color: Colors.white)
            ),
          ],
        ),
      ),
    );
  }
}
import 'extension.dart';
import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  final Color subColor;
  final String mainText;
  final String subText;
  final Color mainColor;
  final bool? load;
  const MyRichText(
      {super.key,
      required this.subColor,
      required this.mainText,
      required this.mainColor,
      required this.subText,
      this.load});

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: mainText,
          style: TextStyle(color: mainColor, fontSize: 16),
          children: [
            TextSpan(
              text: subText,
              style: TextStyle(
                color: subColor,
              ),
            )
          ],
        ),
      ).hPadding9;
}



class MyRichText2 extends StatelessWidget {
  final Color subColor;
  final String mainText;
  final String subText;
  final Color mainColor;
  final bool? load;
  const MyRichText2(
      {super.key,
      required this.subColor,
      required this.mainText,
      required this.mainColor,
      required this.subText,
      this.load});

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: mainText,
          style: TextStyle(color: mainColor, fontSize: 16),
          children: [
            TextSpan(
              text: subText,
              style: TextStyle(
                color: subColor,
              ),
            )
          ],
        ),
      );
}

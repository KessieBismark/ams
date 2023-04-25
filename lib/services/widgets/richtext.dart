import 'extension.dart';
import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  final Color subColor;
  final String mainText;
  final String subText;
  final bool? load;
  const MyRichText(
      {Key? key,
      required this.subColor,
      required this.mainText,
      required this.subText,
      this.load})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: mainText,
          style: const TextStyle(color: Colors.black, fontSize: 16),
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

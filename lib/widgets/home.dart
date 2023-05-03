import 'package:flutter/material.dart';
import '../pages/layout/drawer.dart';
import '../pages/layout/responsive.dart';
import '../pages/layout/tab_panel.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Responsive.isDesktop(context)|| Responsive.isTablet(context)
            ? const Expanded(child: MyDrawer())
            : Container(),
        const Expanded(
          flex: 5,
          child: Home(),
        ),
      ],
    );
  }
}

  // void _closeDrawer(context) {
  //   Navigator.of(context).pop();
  // }
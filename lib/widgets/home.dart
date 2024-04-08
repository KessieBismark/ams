import 'package:ams/pages/layout/component/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/layout/drawer.dart';
import '../pages/layout/responsive.dart';
import '../pages/layout/tab_panel.dart';

final con = Get.put(HomeController());

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return
        //  MouseRegion(
        //  onHover : (event) => con.resetIdleTimer(),
        //   child: GestureDetector(
        //     onTap: () {
        //       // Handle other user interactions if needed
        //       con.resetIdleTimer();
        //     },
        //     child:
        Row(
      children: [
        Responsive.isDesktop(context) || Responsive.isTablet(context)
            ? const Expanded(child: MyDrawer())
            : Container(),
        const Expanded(
          flex: 5,
          child: Home(),
        ),
      ],
    );
    //),
    // );
  }
}

  // void _closeDrawer(context) {
  //   Navigator.of(context).pop();
  // }
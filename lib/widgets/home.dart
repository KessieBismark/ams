import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../pages/layout/drawer.dart';
import '../pages/layout/responsive.dart';
import '../pages/layout/tab_panel.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(elevation: 1, backgroundColor: Colors.grey.withAlpha(200)),
      drawer: Responsive.isDesktop(context) ? null : const MyDrawer(),
      body: fluent.Row(
        children: [
          Responsive.isDesktop(context)
              ? const Expanded(child: MyDrawer())
              : Container(),
          const Expanded(
            flex: 5,
            child: fluent.FluentApp(
              debugShowCheckedModeBanner: false,
              home: Home(),
            ),
          ),
        ],
      ),
    );
  }
}

  // void _closeDrawer(context) {
  //   Navigator.of(context).pop();
  // }
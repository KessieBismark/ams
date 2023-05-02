import 'package:ams/pages/layout/drawer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../pages/layout/component/controller/controller.dart';
import '../pages/layout/component/model/side_model.dart';
import '../services/constants/color.dart';
import '../services/utils/helpers.dart';

class MobileHome extends GetView<HomeController> {
  const MobileHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
        length: controller.tabLength.value,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Utils.isLightTheme.value ? lightGrey : null,
              toolbarHeight: 0, // set the height of the AppBar
              bottom: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                labelPadding: const EdgeInsets.only(left: 16.0),
                controller: controller.tabController,
                tabs: controller.tabs.map((tab) {
                  return Tab(
                    child: tab.id != '2322'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                tab.icon,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(tab.title),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  controller.removeTab(tab);
                                },
                              ),
                            ],
                          )
                        : Container(),
                  );
                }).toList(),
              )),
          drawer: const MyDrawer(),
          body: TabBarView(
            controller: controller.tabController,
            children: controller.tabs.map((SearchableModel tab) {
              return tab.widget;
            }).toList(),
          ),

          // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }
}

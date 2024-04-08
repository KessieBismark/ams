import 'package:ams/services/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../responsive.dart';
import '../../services/utils/helpers.dart';
import 'component/controller/controller.dart';
import 'component/model/side_model.dart';
import 'drawer.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: controller.tabLength.value,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Utils.isLightTheme.value ? lightGrey : null,
            toolbarHeight: Responsive.isMobile(context)
                ? 30
                : 0, // set the height of the AppBar
            bottom: TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5,
              labelPadding: const EdgeInsets.only(left: 16.0),
              controller: Utils.tabController,
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
            ),
          ),
          drawer: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? null
              : const MyDrawer(),
          body: TabBarView(
            controller: Utils.tabController,
            children: controller.tabs.map((SearchableModel tab) {
              return tab.widget;
            }).toList(),
          ),
        ),
      ),
    );
  }
}

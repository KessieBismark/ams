import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'component/controller/controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    controller.tabs ??= List.generate(
      0,
      (index) => controller.generateTab(index, Container()),
    );
    return Obx(
      () => fluent.TabView(
        tabs: controller.tabs!,
        currentIndex: controller.currentIndex.value,
        onChanged: (index) => controller.currentIndex.value = index,
        tabWidthBehavior: controller.tabWidthBehavior,
        closeButtonVisibility: controller.closeButtonVisibilityMode,
        showScrollButtons: controller.showScrollButtons,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = controller.tabs!.removeAt(oldIndex);
          controller.tabs!.insert(newIndex, item);
          if (controller.currentIndex.value == newIndex) {
            controller.currentIndex.value = oldIndex;
          } else if (controller.currentIndex.value == oldIndex) {
            controller.currentIndex.value = newIndex;
          }
        },
      ),
    );
  }
}

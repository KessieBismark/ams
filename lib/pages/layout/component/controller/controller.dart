import 'package:ams/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../../../services/utils/helpers.dart';


class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isAdd = false.obs;
  List<fluent.Tab>? tabs;
  var tabCount = 0.obs;

  fluent.TabWidthBehavior tabWidthBehavior = fluent.TabWidthBehavior.equal;
  fluent.CloseButtonVisibilityMode closeButtonVisibilityMode =
      fluent.CloseButtonVisibilityMode.always;
     
  bool showScrollButtons = true;
  bool wheelScroll = false;

  fluent.Tab generateTab(index, dynamic data) {
    late fluent.Tab tab;
    tab = fluent.Tab(
      text: data.title.toString().toAutoLabel(),
      icon: Icon(
        data.icon,
      ),
      body: data.widget,   
      onClosed: () {
        tabs!.remove(tab);
        tabCount.value--;
        if (currentIndex.value > 0) currentIndex.value--;
        Utils.activeMenus.remove(data.id);
      },
    );
    return tab;
  }
}

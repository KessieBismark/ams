import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/utils/helpers.dart';
import '../model/side_model.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  var tabLength = 0.obs;
  List<SearchableModel> tabs = [];
  SearchableModel? selectedItem;
  final Duration idleDuration =
      const Duration(minutes: 1); // Set your desired idle duration here
  Timer? idleTimer;

  @override
  onInit() {
    super.onInit();
   // resetIdleTimer();
    tabs.add(SearchableModel(id: '2322', title: 'title', widget: Container()));
    Utils.tabController = TabController(length: tabs.length, vsync: this);

    getDrawerList();
  }

  @override
  void onClose() {
    Utils.tabController!.dispose();
    super.onClose();
  }

  // void startIdleTimer() {
  //   idleTimer = Timer(idleDuration, logoutUser);
  // }

  // void resetIdleTimer() {
  //   idleTimer?.cancel();
  //   print("mouse moved");
  //   idleTimer = Timer(idleDuration, logoutUser);
  // }
  // void resetIdleTimer() {
  //   if (idleTimer != null && idleTimer!.isActive) {
  //     idleTimer!.cancel();
  //   }
  //   print("Mouse moved");
  //   startIdleTimer();
  // }

  // void logoutUser() {
  //   // Add your logout logic here

  //   print('User is logged out due to inactivity');
  //   Utils.logOut();
  //   // For example, you can navigate to the login screen or perform a logout action.
  // }

  @override
  void dispose() {
    Utils.tabController!.dispose();
    super.dispose();
  }

  getDrawerList() {
    Utils.drawerItems = [];
    for (int i = 0; i < MenuHeader.data.length; i++) {
      for (int j = 0; j < MenuHeader.data[i].menus.length; j++) {
        if (MenuHeader.data[i].menus[j].subMenu.isEmpty) {
          Utils.drawerItems.add(SearchableModel(
              id: MenuHeader.data[i].menus[j].id,
              title: MenuHeader.data[i].menus[j].title,
              icon: MenuHeader.data[i].menus[j].icon,
              widget: MenuHeader.data[i].menus[j].widget!));
        } else {
          for (int q = 0; q < MenuHeader.data[i].menus[j].subMenu.length; q++) {
            Utils.drawerItems.add(SearchableModel(
                id: MenuHeader.data[i].menus[j].subMenu[q].id,
                title: MenuHeader.data[i].menus[j].subMenu[q].title,
                icon: MenuHeader.data[i].menus[j].subMenu[q].icon,
                widget: MenuHeader.data[i].menus[j].subMenu[q].widget));
          }
        }
      }
    }
  }

  generateTab(SearchableModel data) {
    tabs.add(data);
    Utils.tabController = TabController(length: tabs.length, vsync: this);
    Utils.tabController!.animateTo(tabs.length - 1);

    tabLength.value++;
    update();
  }

  removeTab(SearchableModel data) {
    if (tabLength.value == 1) {
      tabs.remove(data);
      Utils.tabController = TabController(length: tabs.length, vsync: this);
      if (tabs.isNotEmpty && tabLength.value != 0) {}
    } else {
      tabs.remove(data);
      Utils.tabController = TabController(length: tabs.length, vsync: this);
      if (tabs.isNotEmpty && tabLength.value != 0) {
        Utils.tabController!.animateTo(tabs.length - 1);
      }
    }

    Utils.activeMenus.remove(data.id);
    tabLength.value--;
    update();
  }
}

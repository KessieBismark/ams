import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/utils/helpers.dart';
import '../model/side_model.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  var tabLength = 0.obs;
  var isAdd = false.obs;
  List<SearchableModel> tabs = [];
  SearchableModel? selectedItem;
  TabController? tabController;
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  @override
  onInit() {
    super.onInit();
    tabs.add(SearchableModel(id: '2322', title: 'title', widget: Container()));
    tabController = TabController(length: tabs.length, vsync: this);
    getDrawerList();
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    tabController!.dispose();
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
    tabController = TabController(length: tabs.length, vsync: this);
    tabController!.animateTo(tabs.length - 1);

    tabLength.value++;
    update();
  }

  removeTab(SearchableModel data) {
    if (tabLength.value == 1) {
      tabs.remove(data);
      tabController = TabController(length: tabs.length, vsync: this);
      if (tabs.isNotEmpty && tabLength.value != 0) {
        print("animate: ${tabs.length - 1}");
      }
    } else {
      tabs.remove(data);
      tabController = TabController(length: tabs.length, vsync: this);
      if (tabs.isNotEmpty && tabLength.value != 0) {
        tabController!.animateTo(tabs.length - 1);
      }
    }
    // tabs.remove(data);
    // tabLength.value--;
    // tabController = TabController(length: tabs.length, vsync: this);
    // if (tabs.isNotEmpty && tabLength.value != 0) {
    //   tabController!.animateTo(tabs.length - 1);
    // }
    Utils.activeMenus.remove(data.id);
    tabLength.value--;
    update();
  }
}

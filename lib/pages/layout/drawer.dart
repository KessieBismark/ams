import 'package:ams/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/drawer_list.dart';
import '../../services/widgets/expanded_list.dart';
import '../../services/widgets/richtext_two.dart';
import 'component/controller/controller.dart';
import 'component/model/side_model.dart';
import 'responsive.dart';

class MyDrawer extends GetView<HomeController> {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Column(
        children: [
          DrawerHeader(
            curve: Curves.easeIn,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/logo.png",
                      height: 40,
                    ).padding3,
                    appName.toLabel(
                        bold: true,
                        fontsize: 30,
                        color: const Color.fromARGB(182, 75, 184, 187))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                "Welcome ${Utils.userName.capitalizeFirst}"
                    .toLabel(fontsize: 15),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: "Logout".toAutoLabel(
                      color: const Color.fromARGB(182, 75, 184, 187)),
                  onTap: () => Utils.logOut(),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: MenuHeader.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: MenuHeader.data[index].header
                          .toUpperCase()
                          .toLabel(bold: true, color: lightGrey, fontsize: 12),
                    ).vPadding9.hPadding9.hMargin9,
                    for (int i = 0;
                        i < MenuHeader.data[index].menus.length;
                        i++)
                      MenuHeader.data[index].menus[i].subMenu.isEmpty
                          ? DrawerItem(
                              leading: Utils.activeMenus.contains(
                                      MenuHeader.data[index].menus[i].id)
                                  ? Icon(
                                      MenuHeader.data[index].menus[i].icon,
                                    )
                                  : Icon(
                                      MenuHeader.data[index].menus[i].icon,
                                      color: Colors.grey.shade400,
                                    ),
                              selected: Utils.activeMenus.contains(
                                      MenuHeader.data[index].menus[i].id)
                                  ? true
                                  : false,
                              onTap: () {
                                if (!Utils.activeMenus.contains(
                                    MenuHeader.data[index].menus[i].id)) {
                                  if (controller.currentIndex.value == 0) {
                                    controller.currentIndex.value++;
                                    controller.currentIndex.value--;
                                  } else {
                                    controller.currentIndex.value++;
                                  }
                                  Utils.activeMenus
                                      .add(MenuHeader.data[index].menus[i].id);

                                  final tabIndex = controller.tabs!.length + 1;
                                  final tab = controller.generateTab(tabIndex,
                                      MenuHeader.data[index].menus[i]);
                                  controller.tabs!.add(tab);
                                  controller.currentIndex.value =
                                      controller.tabs!.length;
                                  if (Responsive.isMobile(context)) {
                                    closeDrawer(context);
                                  }
                                } else {
                                  if (Utils.activeMenus.contains(
                                      MenuHeader.data[index].menus[i].id)) {
                                    controller.currentIndex.value =
                                        Utils.activeMenus.indexWhere((id) =>
                                            id ==
                                            MenuHeader.data[index].menus[i].id);
                                  }
                                }
                              },
                              title: MenuHeader
                                  .data[index].menus[i].title.capitalizeFirst!
                                  .toLabel(fontsize: 13),
                            )
                          : ExpandItems(
                              drawerContext: context,
                              leading: MenuHeader.data[index].menus[i].icon,
                              title: MenuHeader.data[index].menus[i].title
                                  .toUpperCase(),
                              subMenus: MenuHeader.data[index].menus[i].subMenu,
                            )
                  ],
                );
              },
            ),
          ),
          InkWell(
            onTap: _launchURL,
            child: MyRichTextTwo(
              mainText: "Developed by ",
              subText: "BISTECH GHANA",
              mainStyle: TextStyle(color: lightGrey, fontSize: 14),
              subStyle: const TextStyle(
                  color: Color.fromARGB(182, 75, 184, 187), fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://bistechgh.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

void closeDrawer(context) {
  Navigator.of(context).pop();
}

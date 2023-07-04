import 'package:ams/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/utils/themes.dart';
import '../../services/widgets/drawer_list.dart';
import '../../services/widgets/dropdowntext2.dart';
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
          DrawerSearch(
            hint: "Search menu items",
            label: "Search menu items",
            controller: controller.selectedItem,
            list: Utils.drawerItems,
            onChange: (val) {
              if (!Utils.activeMenus.contains(val!.id)) {
                Utils.activeMenus.add(val.id);
                controller.generateTab(SearchableModel(
                    id: val.id, title: val.title, widget: val.widget));

                if (Responsive.isMobile(context)) {
                  closeDrawer(context);
                }
              } else {
                if (Utils.activeMenus.contains(val.id)) {
                  Utils.tabController!
                      .animateTo(Utils.activeMenus.indexOf(val.id) + 1);
                }
              }
            },
          ).hMargin9,
          const SizedBox(
            height: 10,
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
                                  Utils.activeMenus
                                      .add(MenuHeader.data[index].menus[i].id);

                                  controller.generateTab(SearchableModel(
                                      id: MenuHeader.data[index].menus[i].id,
                                      icon:
                                          MenuHeader.data[index].menus[i].icon,
                                      title:
                                          MenuHeader.data[index].menus[i].title,
                                      widget: MenuHeader
                                          .data[index].menus[i].widget!));

                                  if (Responsive.isMobile(context)) {
                                    closeDrawer(context);
                                  }
                                } else {
                                  if (Utils.activeMenus.contains(
                                      MenuHeader.data[index].menus[i].id)) {
                                    Utils.tabController!.animateTo(
                                        Utils.activeMenus.indexOf(MenuHeader
                                                .data[index].menus[i].id) +
                                            1);
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
          Row(
            children: [
              const Text("Theme: "),
              Obx(
                () => IconButton(
                        onPressed: () {
                          Utils.isLightTheme.toggle();
                          Get.changeThemeMode(
                            Utils.isLightTheme.value
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );

                          ThemeController().saveThemeStatus();
                        },
                        icon: Utils.isLightTheme.value
                            ? const Icon(FontAwesomeIcons.solidMoon)
                            : const Icon(Icons.wb_sunny))
                    .hPadding9,
              ),
            ],
          ).hPadding9,
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

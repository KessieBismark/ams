import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';

import '../../pages/layout/component/controller/controller.dart';
import '../../pages/layout/component/model/side_model.dart';
import '../../pages/layout/responsive.dart';
import '../utils/helpers.dart';
import 'extension.dart';

// class SubItem extends StatelessWidget {
//   final String title;
//   final String? selected;
//   const SubItem({
//     Key? key,
//     required this.title,
//     this.selected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List list = title.split("-");
//     return ListTile(
//       title: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,

//         children: [
//           const Icon(Entypo.dot),
//           Text(list[0].toString().capitalize!,
//               style: const TextStyle(
//                   overflow: TextOverflow.ellipsis, fontSize: 13))
//         ],
//       ).hPadding6,
//       // selected: list[1] == selected ? true : false,
//       onTap: () => Get.offNamed(list[1]),
//     );
//   }
// }

class SubItem extends GetView<HomeController> {
  final SubMenu subMenu;
  final String? selected;
  final BuildContext drawerContext;
  const SubItem({
    super.key,
    required this.subMenu,
    this.selected,
    required this.drawerContext,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(

        children: [
          const Icon(Entypo.dot),
          Text(subMenu.title.toString().capitalize!,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, fontSize: 15))
        ],
      ).hPadding6,
      onTap: () {
        if (!Utils.activeMenus.contains(subMenu.id)) {
          Utils.activeMenus.add(subMenu.id);
          controller.generateTab(SearchableModel(
              id: subMenu.id,
              title: subMenu.title,
              widget: subMenu.widget,
              icon: subMenu.icon));
          if (Responsive.isMobile(context)) {
            closeDrawer(drawerContext);
          }
        } else {
          if (Utils.activeMenus.contains(subMenu.id)) {
            Utils.tabController!
                .animateTo(Utils.activeMenus.indexOf(subMenu.id) + 1);
          }
        }
      },
    );
  }
}

void closeDrawer(context) {
  Navigator.of(context).pop();
}

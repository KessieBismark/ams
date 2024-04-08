import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';

class Header extends StatelessWidget {
  const Header({
    required this.pageName,
    this.searchBar,
    //  required this.search,
    super.key,
  });
  final Widget? searchBar;
  final String pageName;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        // if (!Responsive.isDesktop(context))
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: context.read<MyMenuController>().controlMenu,
        //   ),
        if (Responsive.isTablet(context) || Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Text(
              pageName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        if (Responsive.isDesktop(context)) Expanded(child: searchBar!),
        if (Responsive.isTablet(context)) const Spacer(),
        if (Responsive.isTablet(context))
          SizedBox(width: 300, child: Expanded(child: searchBar!)),
        if (Responsive.isMobile(context)) Expanded(child: searchBar!),
        // const ProfileCard(),
        // IconButton(
        //         onPressed: () {
        //           Utils.isLightTheme.toggle();
        //           Get.changeThemeMode(
        //             Utils.isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
        //           );

        //           ThemeController().saveThemeStatus();
        //         },
        //         icon: Utils.isLightTheme.value
        //             ? const Icon(FontAwesomeIcons.solidMoon)
        //             : const Icon(Icons.wb_sunny))
        //     .hPadding9
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Utils.userNameinitials(Utils.userName.trim())
            .toString()
            .toAutoLabel(
                color: const Color.fromARGB(182, 75, 184, 187), bold: true));
  }
}

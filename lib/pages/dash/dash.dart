import 'package:ams/services/constants/constant.dart';
import 'package:ams/services/widgets/extension.dart';
import 'package:ams/services/widgets/waiting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/extensions/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../responsive.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/stacked_info.dart';
import '../../widgets/header/header.dart';
import 'component/att_summary.dart';
import 'component/controller.dart';

class Dashboard extends GetView<DashCon> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Header(
                pageName: "Dashboard",
                searchBar: Container(),
              ),
              const SizedBox(
                height: 10,
              ),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                topSection(context),
              if (Responsive.isMobile(context)) topSectionMbile(context),
              const SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  Obx(() => Row(
                        children: [
                          MTextButton(
                            onTap: () {
                              controller.bday.value = true;
                              controller.bweek.value = false;
                              controller.bmonth.value = false;
                              controller.byear.value = false;
                              controller.getAttSummary("Day");
                            },
                            title: "Today",
                            active: controller.bday.value,
                          ),
                          MTextButton(
                            onTap: () {
                              controller.bday.value = false;
                              controller.bweek.value = true;
                              controller.bmonth.value = false;
                              controller.byear.value = false;
                              controller.getAttSummary("Week");
                            },
                            title: "Week",
                            active: controller.bweek.value,
                          ),
                          MTextButton(
                            onTap: () {
                              controller.bday.value = false;
                              controller.bmonth.value = true;
                              controller.byear.value = false;
                              controller.bweek.value = false;
                              controller.getAttSummary("Month");
                            },
                            title: "Month",
                            active: controller.bmonth.value,
                          ),
                          MTextButton(
                            onTap: () {
                              controller.bday.value = false;
                              controller.byear.value = true;
                              controller.bmonth.value = false;
                              controller.bweek.value = false;
                              controller.getAttSummary("Year");
                            },
                            title: "Year",
                            active: controller.byear.value,
                          ),
                        ],
                      )).hPadding3,
                  if (Responsive.isDesktop(context) ||
                      Responsive.isTablet(context))
                    Obx(() => controller.aLoad.value
                        ? const Padding(
                                padding: EdgeInsets.all(200), child: MWaiting())
                            .card
                        : Row(
                            children: [
                              Column(
                                children: [
                                  "Attendance".toAutoLabel(fontsize: 18.0),
                                  SizedBox(
                                    height: myHeight(context, 1.9),
                                    width: myWidth(context, 1.25),
                                    child: const AttSummary(),
                                  )
                                ],
                              ),
                            ],
                          )).card,
                  if (Responsive.isMobile(context))
                    Obx(() => controller.aLoad.value
                        ? const Padding(
                                padding: EdgeInsets.all(200), child: MWaiting())
                            .card
                        : Column(
                            children: [
                              SizedBox(
                                height: myHeight(context, 1.9),
                                width: myWidth(context, 1),
                                child: const AttSummary(),
                              )
                            ],
                          ))
                ],
              )
            ],
          )),
    );
  }

  Column topSectionMbile(BuildContext context) {
    return Column(
      children: [
        Obx(() => StackedInfoCard(
              title: "Employees",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.userGroup,
              value: controller.eTotal.value,
              iconBackColor: Colors.green,
            ).center.animate().fade(duration: 500.ms).scale(delay: 200.ms)),
        Obx(() => StackedInfoCard(
              title: "Early",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.userClock,
              value: controller.early.value,
              iconBackColor: const Color.fromARGB(255, 154, 180, 4),
            ).center.animate().fade(duration: 500.ms).scale(delay: 300.ms)),
        Obx(() => StackedInfoCard(
              title: "Late",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.bookOpen,
              value: controller.late.value,
              iconBackColor: const Color.fromARGB(255, 129, 11, 11),
            ).center.animate().fade(duration: 500.ms).scale(delay: 300.ms)),
      ],
    );
  }

  Row topSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => StackedInfoCard(
              title: "Employees",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: FontAwesomeIcons.userGroup,
              value: controller.eTotal.value,
              iconBackColor: Colors.green,
            )).animate().fade(duration: 500.ms).scale(delay: 200.ms),
        Obx(() => StackedInfoCard(
              title: "Early",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: FontAwesomeIcons.userClock,
              value: controller.early.value,
              iconBackColor: const Color.fromARGB(255, 154, 180, 4),
            )).animate().fade(duration: 500.ms).scale(delay: 300.ms),
        Obx(() => StackedInfoCard(
              title: "Late",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: Icons.assignment_late,
              value: controller.late.value,
              iconBackColor: const Color.fromARGB(255, 129, 11, 11),
            )).animate().fade(duration: 500.ms).scale(delay: 400.ms),
      ],
    );
  }
}

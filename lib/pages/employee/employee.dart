import 'component/controller.dart';
import 'component/table.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../responsive.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/richtext.dart';
import '../../widgets/header/header.dart';
import 'component/emp_input.dart';

class Employee extends GetView<EmployeeCon> {
  const Employee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                pageName: 'Employees',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    Future.delayed(const Duration(microseconds: 300))
                        .then((value) {
                      controller.employeeRecords =
                          controller.employee.where((data) {
                        var surname = data.surname.toLowerCase();
                        var middlename = data.middlename!.toLowerCase();
                        var firstname = data.firstname!.toLowerCase();
                        var staffID = data.staffID;
                        var branch = data.branch;
                        var department = data.department.toLowerCase();
                        return surname.contains(text.toLowerCase()) ||
                            department.contains(text.toLowerCase()) ||
                            middlename.contains(text.toLowerCase()) ||
                            firstname.contains(text.toLowerCase()) ||
                            branch.contains(text.toLowerCase()) ||
                            staffID.toString().contains(text);
                      }).toList();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    // fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            if (Responsive.isDesktop(context) ||
                                Responsive.isTablet(context))
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (Utils.access
                                      .contains(Utils.initials("employee", 1)))
                                    Row(
                                      children: [
                                        MButton(
                                          onTap: () {
                                            if (Responsive.isMobile(context)) {
                                              controller.on.value = true;
                                              controller.getMaxId();

                                              Get.toNamed('/empInput');
                                            } else {
                                              controller.on.value = true;
                                              controller.clearText();
                                              controller.getMaxId();
                                              controller.input.value = true;
                                            }
                                          },
                                          type: ButtonType.add,
                                        ).hPadding9,
                                        if (Utils.access.contains(
                                                Utils.initials(
                                                    "Synchronization", 0)) &&
                                            GetPlatform.isWindows)
                                          MButton(
                                            onTap: () async {
                                              if (!await launchUrl(
                                                  controller.sync)) {
                                                throw 'Could not launch app';
                                              }
                                            },
                                            title: "Sync",
                                            icon: const Icon(
                                              Icons.sync,
                                              size: 18,
                                            ),
                                            color: greenfade,
                                          ).hPadding9,
                                        if (Utils.access.contains(
                                                Utils.initials(
                                                    "Enroll Fingerprint", 0)) &&
                                            GetPlatform.isWindows)
                                          MButton(
                                            onTap: () async {
                                              if (!await launchUrl(
                                                  controller.enroll)) {
                                                throw 'Could not launch app';
                                              }
                                            },
                                            title: "Enroll fingerprint",
                                            icon: const Icon(Icons.fingerprint,
                                                size: 18),
                                            color: const Color.fromARGB(
                                                255, 56, 83, 77),
                                          ).hPadding9,
                                      ],
                                    ).hPadding9,
                                  Obx(() => MyRichText(
                                      load: controller.getData.value,
                                      mainColor: Utils.isLightTheme.value
                                          ? dark
                                          : light,
                                      subColor: Colors.red,
                                      mainText: "Employee Table ",
                                      subText:
                                          "(${controller.employeeRecords.length})")),
                                  Row(
                                    children: [
                                      if (Utils.access.contains(
                                          Utils.initials("employee", 4)))
                                        IconButton(
                                                onPressed: () async {
                                                  controller.generateCsv(
                                                      controller
                                                          .employeeRecords);
                                                },
                                                icon: const Icon(
                                                    FontAwesome.file_excel))
                                            .hPadding9,
                                      IconButton(
                                              onPressed: () =>
                                                  controller.reload(),
                                              icon: const Icon(Icons.refresh))
                                          .hPadding9,
                                    ],
                                  )
                                ],
                              ).padding3.card,
                            if (Responsive.isMobile(context))
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => MyRichText(
                                      load: controller.loadData.value,
                                      mainColor: Utils.isLightTheme.value
                                          ? dark
                                          : light,
                                      subColor: Colors.red,
                                      mainText: "Employee Table ",
                                      subText:
                                          "(${controller.employeeRecords.length})")),
                                  PopupMenuButton<String>(
                                    elevation: 20.0,
                                    onSelected: (String newValue) async {
                                      if (newValue == "Add New") {
                                        if (Utils.access.contains(
                                            Utils.initials("employee", 1))) {
                                          if (Responsive.isMobile(context)) {
                                            controller.getMaxId();
                                            controller.on.value = true;
                                            Get.toNamed('/empInput');
                                          } else {
                                            controller.on.value = true;
                                            controller.clearText();
                                            controller.getMaxId();
                                            controller.input.value = true;
                                          }
                                        } else {
                                          Utils().showError(
                                              "You do not have the permissions to access this ection");
                                        }
                                      } else if (newValue == "Sync") {
                                        if (Utils.access.contains(
                                                Utils.initials(
                                                    "Synchronization", 0)) &&
                                            GetPlatform.isWindows) {
                                          if (!await launchUrl(
                                              controller.sync)) {
                                            throw 'Could not launch app';
                                          }
                                        } else {
                                          Utils().showError(
                                              "You do not have the permissions to access this ection");
                                        }
                                      } else if (newValue ==
                                          "Enroll fingerprint") {
                                        if (Utils.access.contains(
                                                Utils.initials(
                                                    "Enroll Fingerprint", 0)) &&
                                            GetPlatform.isWindows) {
                                          if (!await launchUrl(
                                              controller.enroll)) {
                                            throw 'Could not launch app';
                                          }
                                        } else {
                                          Utils().showError(
                                              "You do not have the permissions to access this ection");
                                        }
                                      } else if (newValue == "Refresh") {
                                        controller.reload();
                                      } else if (newValue == "Export") {
                                        if (Utils.access.contains(
                                            Utils.initials("employee", 4))) {
                                          controller.generateCsv(
                                              controller.employeeRecords);
                                        } else {
                                          Utils().showError(
                                              "You do not have the permissions to access this ection");
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        controller.popUpMenuItems,
                                  ),
                                ],
                              ).padding3.card,
                            if (Utils.access
                                .contains(Utils.initials("employee", 0)))
                              SizedBox(
                                  height: myHeight(context, 1.19),
                                  child: const EmployeeTable())
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.input.value == true) {
                      return const EmployInput();
                    } else {
                      return Container();
                    }
                  }),
                  Obx(() {
                    if (controller.updateEmployee.value) {
                      return const UpdateEmployInput();
                    } else {
                      return Container();
                    }
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import '../../services/utils/model.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../responsive.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dialogs.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/richtext.dart';
import '../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/printing/print_pdf.dart';
import 'component/table.dart';

class Lunch extends GetView<LunchCon> {
  const Lunch({super.key});

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
                pageName: 'Lunch Break',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    Future.delayed(const Duration(microseconds: 300))
                        .then((value) {
                      controller.dailyDisplayData =
                          controller.daily.where((data) {
                        var surname = data.surname.toLowerCase();
                        var middlename = data.middlename!.toLowerCase();
                        var firstname = data.firstname!.toLowerCase();
                        var branch = data.branch.toLowerCase();
                        var staffID = data.staffID;
                        var department = data.department.toLowerCase();
                        return surname.contains(text.toLowerCase()) ||
                            department.contains(text.toLowerCase()) ||
                            middlename.contains(text.toLowerCase()) ||
                            branch.contains(text.toLowerCase()) ||
                            firstname.contains(text.toLowerCase()) ||
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (Utils.access
                                  .contains(Utils.initials("Lunch Break", 1)))
                                Row(
                                  children: [
                                    MButton(
                                      onTap: () {
                                        controller.getBranches();
                                        add(context);
                                      },
                                      type: ButtonType.search,
                                    ).hPadding9,
                                    MButton(
                                      onTap: () async {
                                        if (!await launchUrl(
                                            controller.download)) {
                                          throw 'Could not launch app';
                                        }
                                      },
                                      title: "Download Attendance",
                                      icon:
                                          const Icon(Icons.download, size: 18),
                                      color:
                                          const Color.fromARGB(255, 56, 83, 77),
                                    ).hPadding9,
                                  ],
                                ),
                              Obx(
                                () => MyRichText(
                                  load: controller.getData.value,
                                   mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: "Lunch Table ",
                                  subText:
                                      "(${controller.dailyDisplayData.length})",
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                          onPressed: () =>
                                              controller.getBranches(),
                                          icon: const Icon(Icons.refresh))
                                      .hPadding9,
                                  IconButton(
                                    onPressed: () async {
                                      controller.generateCsv(
                                          controller.dailyDisplayData);
                                    },
                                    icon: const Icon(
                                      FontAwesome.file_excel,
                                    ),
                                  ).hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("Lunch Break", 1)))
                                    IconButton(
                                      onPressed: () {
                                        if (controller
                                            .dailyDisplayData.isNotEmpty) {
                                          Get.to(
                                            () => LunchPrint(
                                              attendanceList:
                                                  controller.dailyDisplayData,
                                              title:
                                                  "Lunch Break record on ${controller.dailyDate}",
                                            ),
                                          );
                                        } else {
                                          Utils().showError(
                                              "There are no record to print.");
                                        }
                                      },
                                      icon: const Icon(Icons.print),
                                    ).hPadding9,
                                ],
                              )
                            ],
                          ).padding3.card,
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => MyRichText(
                                  load: controller.getData.value,
                                   mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: "Lunch Break Table ",
                                  subText:
                                      "(${controller.dailyDisplayData.length})",
                                ),
                              ),
                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "Search record") {
                                    if (Utils.access.contains(
                                        Utils.initials("Lunch Break", 1))) {
                                      controller.getBranches();
                                      add(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue ==
                                      "Download attendance") {
                                    if (Utils.access.contains(
                                        Utils.initials("Get Attendance", 1))) {
                                      if (!await launchUrl(
                                          controller.download)) {
                                        throw 'Could not launch app';
                                      }
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("Lunch Break", 1))) {
                                      if (controller
                                          .dailyDisplayData.isNotEmpty) {
                                        Get.to(() => LunchPrint(
                                              attendanceList:
                                                  controller.dailyDisplayData,
                                              title:
                                                  "Lunch Break record on ${controller.dailyDate}",
                                            ));
                                      } else {
                                        Utils().showError(
                                            "There are no record to print.");
                                      }
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "Export") {
                                    if (Utils.access.contains(
                                        Utils.initials("Lunch Break", 1))) {
                                      controller.generateCsv(
                                          controller.dailyDisplayData);
                                    }
                                  } else {
                                    Utils().showError(
                                        "You do not have the permissions to access this ection");
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    controller.popUpMenuItems,
                              ),
                            ],
                          ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("Lunch Break", 0)))
                          SizedBox(
                            height: myHeight(context, 1.28),
                            child: const LunchTable(),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  add(context) {
    return Dialogs.dialog(
      context,
      "Search Attendance",
      false,
      0.0,
      0.0,
      SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Utils.branchID == '0'
                  ? Obx(() => DropDownText2(
                      hint: "Select branch",
                      label: "Select branch",
                      controller: controller.selBranch,
                      isLoading: controller.isB.value,
                      validate: true,
                      list: controller.bList,
                      onChange: (DropDownModel? data) {
                        controller.branch.text = data!.id.toString();
                        controller.selBranch = data;
                        controller.getDepartment(controller.branch.text);
                      }).padding9)
                  : Container(),
              Obx(() => DropDownText2(
                  hint: "Select department",
                  label: "Select department",
                  controller: controller.selDepartment,
                  isLoading: controller.depLoading.value,
                  validate: true,
                  list: controller.departmentList,
                  onChange: (DropDownModel? data) {
                    controller.depText.text = data!.id.toString();
                    controller.selDepartment = data;

                    controller.getEmployees(
                        controller.branch.text, data.id.toString());
                    // controller.selEmployee = null;
                    // controller.empLoading.value = true;
                    // controller.empLoading.value = false;
                  }).padding9),
              Obx(() => DropDownText2(
                  hint: "Select employee",
                  label: "Select employee",
                  controller: controller.selEmployee,
                  isLoading: controller.empLoading.value,
                  validate: true,
                  list: controller.employeesList,
                  onChange: (DropDownModel? data) {
                    controller.empName.text = data!.id.toString();
                  }).padding9),
              Obx(() => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(
                            controller.dateText.text), // Refer step 1
                        firstDate: DateTime.parse('2021-01-01'),
                        lastDate:DateTime.parse('2024-07-26'),
                      );
                      if (picked != null) {
                        controller.today = picked;

                        // controller.dateText.text = picked.toString();
                        controller.dateText.text = Utils.dateOnly(picked);
                        controller.setDate.value = true;
                        controller.dailyDate =
                            DateFormat.yMMMMd().format(picked);
                      }
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.calendar_today, color: voilet),
                      title: controller.setDate.value
                          ? "Selected date: ${controller.dateText.text}"
                              .toLabel()
                          : "Click here to select date".toLabel(),
                    ).vPadding3,
                  ).padding9),
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => MButton(
                      onTap: () {
                        controller.getAttendance();
                        Get.back();
                      },
                      isLoading: controller.getData.value,
                      type: ButtonType.search)),
                  MButton(
                    onTap: () {
                    //  controller.clearText();
                      Get.back();
                    },
                    type: ButtonType.cancel,
                  ),
                ],
              ).padding9
            ],
          ),
        ),
      ),
    );
  }
}

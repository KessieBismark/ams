import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../responsive.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/utils/model.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dialogs.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/richtext.dart';
import '../../widgets/header/header.dart';
import 'component/controller.dart';
import 'component/table/person_table.dart';
import 'component/table/time_table.dart';
import 'printing/person_pdf.dart';
import 'printing/time_pdf.dart';

class MonthlyReport extends GetView<MonthlyReportCon> {
  const MonthlyReport({super.key});

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
                pageName: 'Monthly Attendance Report',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    if (controller.byPerson.value) {
                      controller.mReportDisplayData = controller.mReport.where(
                        (data) {
                          var surname = data.surname.toLowerCase();
                          var middlename = data.middlename!.toLowerCase();
                          var firstname = data.firstname!.toLowerCase();
                          var department = data.department.toLowerCase();
                          var branch = data.branch.toLowerCase();
                          return surname.contains(text.toLowerCase()) ||
                              department.contains(text.toLowerCase()) ||
                              middlename.contains(text.toLowerCase()) ||
                              branch.contains(text.toLowerCase()) ||
                              firstname.contains(text.toLowerCase());
                        },
                      ).toList();
                    } else {}
                    controller.dailyDisplayData = controller.daily.where(
                      (data) {
                        var surname = data.surname.toLowerCase();
                        var middlename = data.middlename!.toLowerCase();
                        var firstname = data.firstname!.toLowerCase();
                        var department = data.department.toLowerCase();
                        var branch = data.branch.toLowerCase();
                        return surname.contains(text.toLowerCase()) ||
                            department.contains(text.toLowerCase()) ||
                            middlename.contains(text.toLowerCase()) ||
                            branch.contains(text.toLowerCase()) ||
                            firstname.contains(text.toLowerCase());
                      },
                    ).toList();
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
                              if (Utils.access.contains(
                                  Utils.initials("monthly report", 1)))
                                Row(
                                  children: [
                                    MButton(
                                      color: primaryColor,
                                      onTap: () {
                                        //   controller.clearText();
                                        controller.getBranches();
                                        showDialog(context);
                                      },
                                      title: "By date",
                                      icon: const Icon(Icons.search_rounded),
                                    ).hPadding9,
                                    MButton(
                                      onTap: () {
                                        controller.wkdBool.value = false;
                                        controller.inTime.value = false;
                                        controller.outTime.value = false;
                                        //  controller.clearText();
                                        controller.getBranches();
                                        byTimeDialog(context);
                                      },
                                      title: "By time",
                                      color: secondary,
                                      icon: const Icon(Icons.search_rounded),
                                    ).hPadding9,
                                  ],
                                ),
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                  mainColor: Utils.isLightTheme.value
                                      ? Colors.black
                                      : light,
                                  subColor: Colors.red,
                                  mainText: "Record Table ",
                                  subText: controller.byPerson.value
                                      ? "(${controller.mReportDisplayData.length})"
                                      : "(${controller.dailyDisplayData.length})")),
                              Row(
                                children: [
                                  IconButton(
                                          onPressed: () =>
                                              controller.getBranches(),
                                          icon: const Icon(Icons.refresh))
                                      .hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("monthly report", 1)))
                                    IconButton(
                                            onPressed: () async {
                                              if (controller.byPerson.value) {
                                                controller.generateMonthCsv(
                                                    controller
                                                        .mReportDisplayData);
                                              } else {
                                                controller.generateTimeCsv(
                                                    controller
                                                        .dailyDisplayData);
                                              }
                                            },
                                            icon: const Icon(
                                                FontAwesome.file_excel))
                                        .hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("monthly report", 1)))
                                    IconButton(
                                            onPressed: () {
                                              if (controller.byPerson.value) {
                                                if (controller
                                                    .mReportDisplayData
                                                    .isNotEmpty) {
                                                  Get.to(() => PersonPrint(
                                                        attendanceList: controller
                                                            .mReportDisplayData,
                                                        title:
                                                            "Summary report on ${controller.selectedDate}",
                                                      ));
                                                } else {
                                                  Utils().showError(
                                                      "There are no record to print.");
                                                }
                                              } else {
                                                if (controller.dailyDisplayData
                                                    .isNotEmpty) {
                                                  Get.to(() => TimePrint(
                                                        attendanceList: controller
                                                            .dailyDisplayData,
                                                        title:
                                                            "${controller.time.text} time report from ${controller.selectedDate}",
                                                      ));
                                                } else {
                                                  Utils().showError(
                                                      "There are no record to print.");
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.print))
                                        .hPadding9,
                                ],
                              )
                            ],
                          ).padding3.card,
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                  mainColor: Utils.isLightTheme.value
                                      ? Colors.black
                                      : light,
                                  subColor: Colors.red,
                                  mainText: "Monthly Report Table ",
                                  subText: controller.byPerson.value
                                      ? "(${controller.mReportDisplayData.length})"
                                      : "(${controller.dailyDisplayData.length})")),
                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "By time") {
                                    if (Utils.access.contains(
                                        Utils.initials("monthly report", 1))) {
                                      // controller.clearText();
                                      controller.getBranches();
                                      byTimeDialog(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "By date") {
                                    if (Utils.access.contains(
                                        Utils.initials("monthly report", 1))) {
                                      // controller.clearText();
                                      controller.getBranches();
                                      showDialog(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("monthly report", 1))) {
                                      if (controller.byPerson.value) {
                                        if (controller
                                            .mReportDisplayData.isNotEmpty) {
                                          Get.to(
                                            () => PersonPrint(
                                              attendanceList:
                                                  controller.mReportDisplayData,
                                              title:
                                                  "Summary report on ${controller.selectedDate}",
                                            ),
                                          );
                                        } else {
                                          Utils().showError(
                                              "There are no record to print.");
                                        }
                                      } else {
                                        Utils().showError(
                                            "You do not have the permissions to access this ection");
                                      }
                                    } else {
                                      if (Utils.access.contains(Utils.initials(
                                          "monthly report", 1))) {
                                        if (controller
                                            .dailyDisplayData.isNotEmpty) {
                                          Get.to(() => TimePrint(
                                                attendanceList:
                                                    controller.dailyDisplayData,
                                                title:
                                                    "${controller.time.text} time report from ${controller.selectedDate}",
                                              ));
                                        } else {
                                          Utils().showError(
                                              "There are no record to print.");
                                        }
                                      } else {
                                        Utils().showError(
                                            "You do not have the permissions to access this ection");
                                      }
                                    }
                                  } else if (newValue == "Export") {
                                    if (Utils.access.contains(
                                        Utils.initials("monthly report", 1))) {
                                      if (controller.byPerson.value) {
                                        controller.generateMonthCsv(
                                            controller.mReportDisplayData);
                                      } else {
                                        controller.generateTimeCsv(
                                            controller.dailyDisplayData);
                                      }
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
                            .contains(Utils.initials("monthly report", 0)))
                          SizedBox(
                            height: myHeight(context, 1.28),
                            child: Obx(
                              () => controller.byPerson.value
                                  ? const PersonTable()
                                  : const MTimeTable(),
                            ),
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

  showDialog(context) {
    return Dialogs.dialog(
      context,
      "Search by date",
      false,
      0.0,
      0.0,
      SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Utils.branchID == '0'
                  ? Obx(
                      () => DropDownText2(
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
                        },
                      ).padding9,
                    )
                  : Container(),
              Obx(
                () => DropDownText2(
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
                  },
                ).padding9,
              ),
              Obx(
                () => DropDownText2(
                  hint: "Select employee",
                  label: "Select employee",
                  controller: controller.selEmployee,
                  isLoading: controller.empLoading.value,
                  validate: true,
                  list: controller.employeesList,
                  onChange: (DropDownModel? data) {
                    controller.empName.text = data!.id.toString();
                  },
                ).padding9,
              ),
              Obx(
                () => InkWell(
                  onTap: () {
                    showDateRangePicker(
                            context: context,
                            firstDate: controller.today,
                            lastDate: DateTime.parse('2024-07-26'))
                        .then(
                      (value) {
                        if (value != null) {
                          DateTimeRange fromRange = DateTimeRange(
                              start: DateTime.now(), end: DateTime.now());
                          fromRange = value;
                          controller.selectedDate =
                              "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                          controller.sdateText.text =
                              DateFormat.yMMMd().format(fromRange.start);
                          controller.edateText.text =
                              DateFormat.yMMMd().format(fromRange.end);
                        }

                        controller.setDate1.value = true;
                      },
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Icon(Icons.calendar_today, color: voilet),
                    title: controller.setDate1.value
                        ? "Selected date: ${controller.selectedDate}".toLabel()
                        : "Click on the icon to select date range".toLabel(),
                  ).vPadding3,
                ).padding9,
              ),
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MButton(
                    onTap: () {
                      controller.getByDate();
                      Get.back();
                    },
                    title: "Search",
                    isLoading: controller.getData.value,
                    icon: const Icon(Icons.search_rounded),
                  ),
                  MButton(
                    onTap: () {
                      // controller.clearText();
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

  byTimeDialog(context) {
    return Dialogs.dialog(
      context,
      "Search by time",
      false,
      1.5,
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
                    controller.selEmployee = data;
                  }).padding9),
              Obx(() => InkWell(
                    onTap: () {
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: controller.now.hour,
                                  minute: controller.now.minute))
                          .then(
                        (TimeOfDay? value) {
                          if (value != null) {
                            controller.time.text = value.format(context);
                            controller.wkdBool.value = true;
                          }
                        },
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.access_time,
                        color: voilet,
                      ),
                      title: controller.wkdBool.value
                          ? "Selected time: ${controller.time.text}".toLabel()
                          : "Click on the icon to select time".toLabel(),
                    ).vPadding3,
                  ).padding9),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.inTime.value,
                        onChanged: (value) {
                          controller.inTime.value = value!;
                          controller.outTime.value = false;
                        },
                      ),
                      "In Time".toLabel(),
                      const Spacer(),
                      Checkbox(
                        value: controller.outTime.value,
                        onChanged: (value) {
                          controller.outTime.value = value!;
                          controller.inTime.value = false;
                        },
                      ),
                      "Out Time".toLabel()
                    ],
                  ).padding9),
              Obx(() => InkWell(
                    onTap: () {
                      showDateRangePicker(
                              context: context,
                              firstDate: controller.today,
                              lastDate: DateTime.parse('2024-07-26'))
                          .then((value) {
                        if (value != null) {
                          DateTimeRange fromRange = DateTimeRange(
                              start: DateTime.now(), end: DateTime.now());
                          fromRange = value;
                          controller.selectedDate =
                              "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                          controller.sdateText.text =
                              DateFormat.yMMMd().format(fromRange.start);
                          controller.edateText.text =
                              DateFormat.yMMMd().format(fromRange.end);
                        }

                        controller.setDate2.value = true;
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.calendar_today, color: voilet),
                      title: controller.setDate2.value
                          ? "Selected date: ${controller.selectedDate}"
                              .toLabel()
                          : "Click on the icon to select date range".toLabel(),
                    ).vPadding3,
                  ).padding9),
              DropDownText(
                hint: "Select report type",
                label: "Select report type",
                controller: controller.reportType,
                list: const ['Summary', 'Detailed'],
                onChange: (val) => controller.reportType.text = val!,
              ).padding9,
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MButton(
                    onTap: () {
                      controller.getByTime();
                      Get.back();
                    },
                    title: "Search",
                    isLoading: controller.getData.value,
                    icon: const Icon(Icons.search_rounded),
                  ),
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

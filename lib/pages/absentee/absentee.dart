import 'component/controller/controller.dart';
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
import 'component/model/absentee_model.dart';
import 'component/printing/absent_pdf.dart';
import 'component/table.dart';

class Absentee extends GetView<AbsenteeCon> {
  const Absentee({super.key});

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
                pageName: 'Absentees',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    controller.absentDisplayData =
                        controller.absent.where((data) {
                      var surname = data.surname.toLowerCase();
                      var middlename = data.middlename!.toLowerCase();
                      var firstname = data.firstname!.toLowerCase();
                      var staffID = data.staffID;
                      var department = data.department.toLowerCase();
                      return surname.contains(text.toLowerCase()) ||
                          department.contains(text.toLowerCase()) ||
                          middlename.contains(text.toLowerCase()) ||
                          firstname.contains(text.toLowerCase()) ||
                          staffID.toString().contains(text);
                    }).toList();
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
                                  .contains(Utils.initials("absentees", 1)))
                                MButton(
                                  onTap: () {
                                    controller.clearText();
                                    add(context);
                                  },
                                  type: ButtonType.search,
                                ).hPadding9,
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                               
                                  subColor: Colors.red,
                                  mainText: "Absentees Table ",
                                  subText:
                                      "(${controller.absentDisplayData.length})")),
                              Row(
                                children: [
                                  IconButton(
                                          onPressed: () =>
                                              controller.getBranches(),
                                          icon: const Icon(Icons.refresh))
                                      .hPadding9,
                                  if (Utils.access
                                      .contains(Utils.initials("absentees", 1)))
                                    IconButton(
                                            onPressed: () async {
                                              controller.generateCsv(
                                                  controller.absentDisplayData);
                                            },
                                            icon: const Icon(
                                                FontAwesome.file_excel))
                                        .hPadding9,
                                  if (Utils.access
                                      .contains(Utils.initials("absentees", 1)))
                                    IconButton(
                                            onPressed: () {
                                              if (controller.absentDisplayData
                                                  .isNotEmpty) {
                                                Get.to(() => DailyAbsentPrint(
                                                      attendanceList: controller
                                                          .absentDisplayData,
                                                      title:
                                                          "Absent report on ${controller.rdate}",
                                                    ));
                                              } else {
                                                Utils().showError(
                                                    "There are no record to print.");
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
                                 
                                  subColor: Colors.red,
                                  mainText: "Absentees Table ",
                                  subText:
                                      "(${controller.absentDisplayData.length})")),
                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) {
                                  if (newValue == "Search record") {
                                    if (Utils.access.contains(
                                        Utils.initials("absentees", 1))) {
                                      controller.clearText();
                                      add(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("absentees", 1))) {
                                      if (controller
                                          .absentDisplayData.isNotEmpty) {
                                        Get.to(() => DailyAbsentPrint(
                                              attendanceList:
                                                  controller.absentDisplayData,
                                              title:
                                                  "Absent report on ${controller.rdate}",
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
                                        Utils.initials("absentees", 1))) {
                                      controller.generateCsv(
                                          controller.absentDisplayData);
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
                            .contains(Utils.initials("absentees", 0)))
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const AbsentTable())
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
        "Search Absentees",
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
                        validate:true,
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
                    validate:true,
                    list: controller.employeesList,
                    onChange: (DropDownModel? data) {
                      controller.empName.text = data!.id.toString();
                    }).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), // Refer step 1
                          firstDate: DateTime.parse('2021-01-01'),
                          lastDate: DateTime(9999),
                        );
                        if (picked != null) {
                          controller.today = picked;
                          controller.dateText.text = Utils.dateOnly(picked);
                          controller.setDate.value = true;
                          controller.rdate = DateFormat.yMMMMd().format(picked);
                        }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const Icon(Icons.calendar_today,
                            color: secondaryColor),
                        title: controller.setDate.value
                            ? "Selected date: ${controller.dateText.text}"
                                .toLabel()
                            : "Click on the icon to select date".toLabel(),
                      ).vPadding3,
                    ).padding9),
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MButton(
                      onTap: () {
                        controller.getAttendance(
                            controller.depText.text,
                            controller.empName.text,
                            controller.dateText.text,
                            controller.branch.text);
                        Get.back();
                      },
                      title: "Search",
                      isLoading: controller.getData.value,
                      icon: const Icon(Icons.search_rounded),
                    ),
                    MButton(
                      onTap: () {
                        controller.clearText();
                        Get.back();
                      },
                      type: ButtonType.cancel,
                    ),
                  ],
                ).padding9
              ],
            ),
          ),
        ));
  }
}

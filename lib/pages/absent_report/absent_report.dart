import 'component/controller.dart';
import 'component/table.dart';
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
import 'component/printing/ab_pdf.dart';

class AbsentReport extends GetView<AbsentReportCon> {
  const AbsentReport({super.key});

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
                pageName: 'Absent Report',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loadData.value = true;
                    controller.loadData.value = false;
                    controller.dataList = controller.data.where((data) {
                      var name = data.surname.toLowerCase();
                      var fname = data.firstname!.toLowerCase();
                      var mname = data.middlename!.toLowerCase();
                      var staffID = data.staffID;
                      return name.contains(text.toLowerCase()) ||
                          fname.contains(text.toLowerCase()) ||
                          mname.contains(text.toLowerCase()) ||
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
                                  .contains(Utils.initials("absent Report", 1)))
                                MButton(
                                  onTap: () {
                                    // controller.clearText();
                                    add(context);
                                  },
                                  type: ButtonType.search,
                                ).hPadding9,
                              Obx(() => MyRichText(
                                  load: controller.loadData.value,
                                  mainColor: Utils.isLightTheme.value
                                      ? Colors.black
                                      : light,
                                  subColor: Colors.red,
                                  mainText: "Absent Report ",
                                  subText: "(${controller.dataList.length})")),
                              if (Utils.access
                                  .contains(Utils.initials("absent Report", 1)))
                                Row(
                                  children: [
                                    IconButton(
                                            onPressed: () =>
                                                controller.reload(),
                                            icon: const Icon(Icons.refresh))
                                        .hPadding9,
                                    IconButton(
                                            onPressed: () async {
                                              controller.generateCsv(
                                                  controller.dataList);
                                            },
                                            icon: const Icon(
                                                FontAwesome.file_excel))
                                        .hPadding9,
                                    IconButton(
                                            onPressed: () {
                                              if (controller
                                                  .dataList.isNotEmpty) {
                                                Get.to(() => AbscentPrint(
                                                      attendanceList:
                                                          controller.dataList,
                                                      title:
                                                          "Absent record summary from ${controller.sdateText.text} to ${controller.edateText.text}",
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
                              // if (_fxn.access
                              //     .contains(_fxn.initials("Departments", 1)))

                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                  mainColor: Utils.isLightTheme.value
                                      ? Colors.black
                                      : light,
                                  subColor: Colors.red,
                                  mainText: "Absent Table ",
                                  subText: "(${controller.dataList.length})")),

                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "Search record") {
                                    if (Utils.access.contains(
                                        Utils.initials("absent Report", 1))) {
                                      //  controller.clearText();
                                      add(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have the permissions to access this ection");
                                    }
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("absent Report", 1))) {
                                      if (controller.dataList.isNotEmpty) {
                                        Get.to(() => AbscentPrint(
                                              attendanceList:
                                                  controller.dataList,
                                              title:
                                                  "Absent record summary from ${controller.sdateText.text} to ${controller.edateText.text}",
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
                                        Utils.initials("absent Report", 1))) {
                                      controller
                                          .generateCsv(controller.dataList);
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
                            .contains(Utils.initials("absent Report", 0)))
                          SizedBox(
                              height: myHeight(context, 1.28),
                              child: const AbrTable())
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
        "Search Records",
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

                          controller.setDate.value = true;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const Icon(Icons.calendar_today,
                            color: secondaryColor),
                        title: controller.setDate.value
                            ? "Selected date: ${controller.selectedDate}"
                                .toLabel()
                            : "Click on the icon to select date range"
                                .toLabel(),
                      ),
                    )).padding9,
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MButton(
                      onTap: () {
                        controller.getAttendance();
                        Get.back();
                      },
                      title: "Search",
                      isLoading: controller.getData.value,
                      icon: const Icon(Icons.search_rounded),
                    ),
                    MButton(
                      onTap: () {
                        //controller.clearText();
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

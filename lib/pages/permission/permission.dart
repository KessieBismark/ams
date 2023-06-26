import '../../services/widgets/multi_select.dart';
import 'component/controller.dart';
import 'component/printing/print_pdf.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/textbox.dart';
import 'package:flutter/material.dart';
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
import '../absentee/component/printing/absent_pdf.dart';
import 'component/absent.dart';
import 'component/table.dart';

class Permission extends GetView<PermissionCon> {
  const Permission({super.key});

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
                pageName: 'Permission Request',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    controller.perDisplayData = controller.per.where((data) {
                      var surname = data.surname.toLowerCase();
                      var middlename = data.middlename!.toLowerCase();
                      var firstname = data.firstname!.toLowerCase();
                      var type = data.type.toLowerCase();
                      var department = data.department.toLowerCase();
                      return surname.contains(text.toLowerCase()) ||
                          department.contains(text.toLowerCase()) ||
                          middlename.contains(text.toLowerCase()) ||
                          type.contains(text.toLowerCase()) ||
                          firstname.contains(text.toLowerCase());
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
                              Row(
                                children: [
                                  if (Utils.access.contains(
                                      Utils.initials("Permission", 1)))
                                    MButton(
                                      onTap: () {
                                        // controller.clearTexts();
                                        add(context);
                                      },
                                      type: ButtonType.add,
                                    ).hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("Permission", 1)))
                                    MButton(
                                      onTap: () {
                                        // controller.clearTexts();
                                        perm(context);
                                      },
                                      title: "Give permission",
                                      color: Colors.grey,
                                    ).hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("Permission", 4)))
                                    MButton(
                                      onTap: () {
                                        controller.clearTexts();
                                        search(context);
                                      },
                                      type: ButtonType.search,
                                    ).hPadding9,
                                  MButton(
                                    onTap: () {
                                      controller.clearTexts();
                                      getAbsent(context);
                                    },
                                    color:
                                        const Color.fromARGB(255, 163, 100, 6),
                                    title: "Get Absentee",
                                  ).hPadding9
                                ],
                              ),
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                   mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: controller.isAbsent.value
                                      ? "Absentee Table "
                                      : "Request Table ",
                                  subText: controller.isAbsent.value
                                      ? "(${controller.absentDisplayData.length})"
                                      : "(${controller.perDisplayData.length})")),
                              Row(
                                children: [
                                  IconButton(
                                          onPressed: () {
                                            controller.isAbsent.value = false;
                                            controller.reload();
                                          },
                                          icon: const Icon(Icons.refresh))
                                      .hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("Permission", 4)))
                                    IconButton(
                                            onPressed: () {
                                              if (controller.isAbsent.value) {
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
                                              } else {
                                                if (controller.perDisplayData
                                                    .isNotEmpty) {
                                                  Get.to(() => PerimssionPrint(
                                                        attendanceList:
                                                            controller
                                                                .perDisplayData,
                                                        title:
                                                            "Permission Report",
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
                              ),
                            ],
                          ).padding3.card,
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                   mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: controller.isAbsent.value
                                      ? "Attendance Table "
                                      : "Request Table ",
                                  subText:
                                      "(${controller.perDisplayData.length})")),
                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "Add New") {
                                    if (Utils.access.contains(
                                        Utils.initials("Permission", 1))) {
                                      //controller.clearTexts();
                                      add(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have access to this section");
                                    }
                                  } else if (newValue == "Search record") {
                                    if (Utils.access.contains(
                                        Utils.initials("Permission", 4))) {
                                      // controller.clearTexts();
                                      search(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have access to this section");
                                    }
                                  } else if (newValue == "Search Absent") {
                                    if (Utils.access.contains(
                                        Utils.initials("Permission", 4))) {
                                      // controller.clearTexts();
                                      getAbsent(context);
                                    } else {
                                      Utils().showError(
                                          "You do not have access to this section");
                                    }
                                  } else if (newValue == "Reload") {
                                    controller.reload();
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("Permission", 4))) {
                                      if (controller
                                          .perDisplayData.isNotEmpty) {
                                        Get.to(() => PerimssionPrint(
                                              attendanceList:
                                                  controller.perDisplayData,
                                              title: "Permission Report",
                                            ));
                                      } else {
                                        Utils().showError(
                                            "There are no record to print.");
                                      }
                                    } else {
                                      Utils().showError(
                                          "You do not have access to this section");
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    controller.popUpMenuItems,
                              ),
                            ],
                          ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("Permission", 0)))
                          SizedBox(
                            height: myHeight(context, 1.28),
                              child: Obx(() => controller.isAbsent.value
                                  ? const AbsentTable()
                                  : const PermissionTable()))
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

  search(context) {
    return Dialogs.dialog(
        context,
        "Search Permissions",
        false,
        0,
        0,
        Column(
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
                  controller.getEmployees(
                      controller.branch.text, data.id.toString());
                }).padding9),
            InkWell(
                onTap: () async {
                  showDateRangePicker(
                          context: context,
                          firstDate: controller.now,
                          lastDate: DateTime(9999))
                      .then((value) {
                    if (value != null) {
                      controller.setDate.value = false;
                      DateTimeRange fromRange = DateTimeRange(
                          start: DateTime.now(), end: DateTime.now());
                      fromRange = value;
                      controller.selectedDate =
                          "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                      controller.sDateText.text =
                          DateFormat.yMMMd().format(fromRange.start);
                      controller.eDateText.text =
                          DateFormat.yMMMd().format(fromRange.end);
                      controller.sDate = fromRange.start;
                      controller.eDate = fromRange.end;
                    }

                    controller.setDate.value = true;
                  });
                },
                child: Obx(
                  () => ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Icon(Icons.calendar_today, color: voilet),
                    title: controller.setDate.value
                        ? "Selected period: ${controller.selectedDate}"
                            .toLabel()
                        : "Click on the icon to select permission period"
                            .toLabel(),
                  ).vPadding3,
                ).padding9),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => MButton(
                      onTap: () => controller.search(),
                      type: ButtonType.search,
                      isLoading: controller.isSearch.value,
                    )),
                MButton(
                  onTap: () => Get.back(),
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        ));
  }

  add(context) {
    return Dialogs.dialog(
      context,
      "Add New Permission",
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
                    controller.eListSelected.clear();
                    controller.selDepartment = data;
                    controller.empLoading.value = true;
                    controller.empLoading.value = false;

                    controller.getEmployees(
                        controller.branch.text, data.id.toString());
                  }).padding9),
              Obx(() => MultiSelectModel(
                      hint: "Select employee",
                      label: "Select employee",
                      isLoading: controller.empLoading.value,
                      validate: true,
                      onChange: (List<DropDownModel>? items) {
                        controller.eListSelected = items!;
                      },
                      controller: controller.eListSelected,
                      list: controller.eList)
                  .padding9),
              Row(
                children: [
                  "Permission type:".toLabel(),
                  const Spacer(),
                  Obx(
                    () => DropdownButton(
                      hint: 'Type'.toLabel(),
                      onChanged: (newValue) {
                        if (newValue == "Other") {
                          controller.isOther.value = true;
                        } else {
                          controller.reason.clear();
                          controller.isOther.value = false;
                        }

                        controller.setSelected(
                          newValue.toString(),
                        );
                      },
                      value: controller.typeSelected.value,
                      items: [
                        for (var data in controller.types)
                          DropdownMenuItem(
                            value: data,
                            child: Text(
                              data,
                            ),
                          )
                      ],
                    ),
                  ).padding9,
                ],
              ).padding9,
              Obx(() => controller.isOther.value
                  ? MEdit(
                      hint: "Enter reason",
                      maxLines: 2,
                      controller: controller.reason,
                      validate:
                          controller.isOther.value ? Utils.validator : null,
                    )
                  : Container()).padding9,
              InkWell(
                  onTap: () async {
                    showDateRangePicker(
                            context: context,
                            firstDate: controller.now,
                            lastDate: DateTime(9999))
                        .then((value) {
                      if (value != null) {
                        controller.setDate.value = false;
                        DateTimeRange fromRange = DateTimeRange(
                            start: DateTime.now(), end: DateTime.now());
                        fromRange = value;
                        controller.selectedDate =
                            "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                        controller.sDateText.text =
                            DateFormat.yMMMd().format(fromRange.start);
                        controller.eDateText.text =
                            DateFormat.yMMMd().format(fromRange.end);
                        controller.sDate = fromRange.start;
                        controller.eDate = fromRange.end;
                      }

                      controller.setDate.value = true;
                    });
                  },
                  child: Obx(
                    () => ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.calendar_today, color: voilet),
                      title: controller.setDate.value
                          ? "Selected period: ${controller.selectedDate}"
                              .toLabel()
                          : "Click on the icon to select permission period"
                              .toLabel(),
                    ).vPadding3,
                  ).padding9),
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => MButton(
                        onTap: () {
                          controller.insert();
                        },
                        isLoading: controller.loading.value,
                        type: ButtonType.save,
                      )),
                  MButton(
                    onTap: () {
                      controller.setDate.value = false;
                      controller.empName.text = '';
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

  perm(context) {
    return Dialogs.dialog(
      context,
      "Give permission",
      false,
      0.0,
      0.0,
      SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  "Permission type:".toLabel(),
                  const Spacer(),
                  Obx(
                    () => DropdownButton(
                      hint: 'Type'.toLabel(),
                      onChanged: (newValue) {
                        if (newValue == "Other") {
                          controller.isOther.value = true;
                        } else {
                          controller.reason.clear();
                          controller.isOther.value = false;
                        }

                        controller.setSelected(
                          newValue.toString(),
                        );
                      },
                      value: controller.typeSelected.value,
                      items: [
                        for (var data in controller.types)
                          DropdownMenuItem(
                            value: data,
                            child: Text(
                              data,
                            ),
                          )
                      ],
                    ),
                  ).padding9,
                ],
              ).padding9,
              Obx(() => controller.isOther.value
                  ? MEdit(
                      hint: "Enter reason",
                      maxLines: 2,
                      controller: controller.reason,
                      validate:
                          controller.isOther.value ? Utils.validator : null,
                    )
                  : Container()).padding9,
              InkWell(
                  onTap: () async {
                    showDateRangePicker(
                            context: context,
                            firstDate: controller.now,
                            lastDate: DateTime(9999))
                        .then((value) {
                      if (value != null) {
                        controller.setDate.value = false;
                        DateTimeRange fromRange = DateTimeRange(
                            start: DateTime.now(), end: DateTime.now());
                        fromRange = value;
                        controller.selectedDate =
                            "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                        controller.sDateText.text =
                            DateFormat.yMMMd().format(fromRange.start);
                        controller.eDateText.text =
                            DateFormat.yMMMd().format(fromRange.end);
                        controller.sDate = fromRange.start;
                        controller.eDate = fromRange.end;
                      }
                      controller.setDate.value = true;
                    });
                  },
                  child: Obx(
                    () => ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.calendar_today, color: voilet),
                      title: controller.setDate.value
                          ? "Selected period: ${controller.selectedDate}"
                              .toLabel()
                          : "Click on the icon to select permission period"
                              .toLabel(),
                    ).vPadding3,
                  ).padding9),
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => MButton(
                        onTap: () {
                          controller.insertPerm();
                        },
                        isLoading: controller.loading.value,
                        type: ButtonType.save,
                      )),
                  MButton(
                    onTap: () {
                      controller.setDate.value = false;
                      controller.empName.text = '';
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

  getAbsent(context) {
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
                    list: controller.empList,
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
                        controller.isChecked.value = [];
                        controller.getAbsent(controller.branch.text);

                        Get.back();
                      },
                      title: "Search",
                      isLoading: controller.isSave.value,
                      icon: const Icon(Icons.search_rounded),
                    ),
                    MButton(
                      onTap: () {
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

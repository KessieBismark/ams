import 'package:ams/services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/color.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/widgets/button.dart';
import '../../../../../services/widgets/dialogs.dart';
import '../../../../../services/widgets/textbox.dart';
import '../../../../../services/widgets/waiting.dart';
import '../../../services/utils/model.dart';
import '../../../services/widgets/dropdown.dart';
import '../../absentee/component/model/absentee_model.dart';
import 'controller/controller.dart';

class DepartmentTable extends GetView<DepartmentCon> {
  const DepartmentTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //setColumnSizeRatios(1, 2);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.getData.value
          ? DataTable2(
              columnSpacing: 12,
              horizontalMargin: 10,
              minWidth: 800,
              smRatio: 0.75,
              lmRatio: 1.5,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.black12),
              sortColumnIndex: controller.sortNameIndex.value,
              sortAscending: controller.sortNameAscending.value,
              columns: [
                DataColumn2(
                  fixedWidth: 50,
                  size: ColumnSize.S,
                  numeric: true,
                  label: '##'.toLabel(bold: true),
                  // numeric: true,
                ),
                DataColumn2(
                  label: "Name".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.depList.sort(
                          (item1, item2) => item1.name.compareTo(item2.name));
                    } else {
                      controller.depList.sort(
                          (item1, item2) => item2.name.compareTo(item1.name));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Weekend Start".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.depList.sort((item1, item2) =>
                            item1.weekendstart.compareTo(item2.weekendstart));
                      } else {
                        controller.depList.sort((item1, item2) =>
                            item2.weekendstart.compareTo(item1.weekendstart));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Weekend start time"),
                DataColumn2(
                    label: "Weekend End".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.depList.sort((item1, item2) =>
                            item1.weekend.compareTo(item2.weekend));
                      } else {
                        controller.depList.sort((item1, item2) =>
                            item2.weekend.compareTo(item1.weekend));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Weekend closing time"),
                DataColumn2(
                  label: "Week Start".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.depList.sort((item1, item2) =>
                          item1.weekstart.compareTo(item2.weekstart));
                    } else {
                      controller.depList.sort((item1, item2) =>
                          item2.weekstart.compareTo(item1.weekstart));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Week End".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.depList.sort((item1, item2) =>
                          item1.weekdays.compareTo(item2.weekdays));
                    } else {
                      controller.depList.sort((item1, item2) =>
                          item2.weekdays.compareTo(item1.weekdays));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.depList.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.depList.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: 'Aciton'.toLabel(bold: true),
                ),
              ],
              rows: List.generate(
                controller.depList.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(controller.depList[index].name.toAutoLabel()),
                    DataCell(
                        controller.depList[index].weekendstart.toAutoLabel()),
                    DataCell(
                        controller.depList[index].weekendstart.toAutoLabel()),
                    DataCell(controller.depList[index].weekdays.toAutoLabel()),
                    DataCell(controller.depList[index].weekend.toAutoLabel()),
                    DataCell(controller.depList[index].branch.toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access
                            .contains(Utils.initials("department", 2)))
                          IconButton(
                            onPressed: () {
                              controller.wkdBool.value = true;
                              controller.wknBool.value = true;
                              controller.swkdBool.value = true;
                              controller.swknBool.value = true;
                              controller.depName.text =
                                  controller.depList[index].name;
                              controller.swkdTime =
                                  controller.depList[index].weekstart;
                              controller.swknTime =
                                  controller.depList[index].weekendstart;

                              controller.wkdTime =
                                  controller.depList[index].weekdays;
                              controller.wknTime =
                                  controller.depList[index].weekend;

                              updateDialog(context,
                                  controller.depList[index].id.toString());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                      ],
                    ))
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }

  updateDialog(
    context,
    String id,
  ) {
    return Dialogs.dialog(
        context,
        "Edit Department",
        true,
        0.0,
        0.0,
        SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                MEdit(
                  hint: "Department Name",
                  controller: controller.depName,
                  validate: Utils.validator,
                ).padding9,
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
                        }).padding9)
                    : Container(),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.swkdTime = value.format(context);
                            controller.swkdBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: greenfade,
                        ),
                        title: controller.swkdBool.value
                            ? "Weekdays start time: ${controller.swkdTime}"
                                .toLabel()
                            : "Click on the icon to select weekdays start time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.wkdTime = value.format(context);
                            controller.wkdBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: voilet,
                        ),
                        title: controller.wkdBool.value
                            ? "Weekdays closing time: ${controller.wkdTime}"
                                .toLabel()
                            : "Click on the icon to select weekdays closing time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.swknTime = value.format(context);
                            controller.swknBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: greenfade,
                        ),
                        title: controller.swknBool.value
                            ? "Weekend start time: ${controller.swknTime}"
                                .toLabel()
                            : "Click on the icon to select weekend start time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((value) {
                          if (value != null) {
                            controller.wknTime = value.format(context);
                            controller.wknBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(Icons.access_time, color: voilet),
                        title: controller.wknBool.value
                            ? "Weekend closing time: ${controller.wknTime}"
                                .toLabel()
                            : "Click on the icon to select weekend closing time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => !controller.loading.value
                        ? MButton(
                            onTap: () {
                              controller.updateDepartment(id);
                            },
                            type: ButtonType.save,
                          )
                        : const MWaiting()),
                    MButton(
                      onTap: () => Get.back(),
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

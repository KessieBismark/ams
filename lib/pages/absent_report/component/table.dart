import 'controller.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/dialogs.dart';
import '../../../services/widgets/textbox.dart';

class AbrTable extends GetView<AbsentReportCon> {
  const AbrTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //setColumnSizeRatios(1, 2);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.getData.value
          ? DataTable2(
              columnSpacing: 12,
              horizontalMargin: 10,
              minWidth: 600,
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
                        controller.dataList.sort((item1, item2) =>
                            item1.surname.compareTo(item2.surname));
                      } else {
                        controller.dataList.sort((item1, item2) =>
                            item2.surname.compareTo(item1.surname));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Employee's Name"),
                DataColumn2(
                    label: "Department".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.dataList.sort((item1, item2) =>
                            item1.department.compareTo(item2.department));
                      } else {
                        controller.dataList.sort((item1, item2) =>
                            item2.department.compareTo(item1.department));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Department name"),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dataList.sort((item1, item2) =>
                          item1.department.compareTo(item2.department));
                    } else {
                      controller.dataList.sort((item1, item2) =>
                          item2.department.compareTo(item1.department));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Absent Days".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dataList.sort((item1, item2) =>
                          item1.abDays.compareTo(item2.abDays));
                    } else {
                      controller.dataList.sort((item1, item2) =>
                          item2.abDays.compareTo(item1.abDays));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Permissions".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dataList.sort((item1, item2) =>
                          item1.permission.compareTo(item2.permission));
                    } else {
                      controller.dataList.sort((item1, item2) =>
                          item2.permission.compareTo(item1.permission));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Dates".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dataList.sort(
                          (item1, item2) => item1.dates.compareTo(item2.dates));
                    } else {
                      controller.dataList.sort(
                          (item1, item2) => item2.dates.compareTo(item1.dates));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
              ],
              rows: List.generate(
                controller.dataList.length,
                (index) => DataRow(
                  onLongPress: () => showsDates(
                      context,
                      controller.dataList[index].staffID,
                      controller.dataList[index].dates,
                      controller.dataList[index].permission,
                      "${controller.dataList[index].surname}, ${controller.dataList[index].middlename} ${controller.dataList[index].firstname}"),
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.dataList[index].surname}, ${controller.dataList[index].middlename} ${controller.dataList[index].firstname}"
                            .toAutoLabel()),
                    DataCell(
                        controller.dataList[index].department.toAutoLabel()),
                    DataCell(controller.dataList[index].branch.toAutoLabel()),
                    DataCell(controller.dataList[index].abDays.toAutoLabel()),
                    DataCell(
                        controller.dataList[index].permission.toAutoLabel()),
                    DataCell(controller
                        .sortDate(controller.dataList[index].dates)
                        .toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }

  showsDates(context, String id, String date, String type, String name) {
    List<String> list = date.split(',');
    list.sort(((a, b) => a.compareTo(b)));
    Get.defaultDialog(
      title: '$name\'s absent days ($type)',
      content: Column(
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Obx(
                      () => controller.permDate.contains('$id-${list[index]}')
                          ? Container()
                          : ListTile(
                              trailing: IconButton(
                                  onPressed: () =>
                                      addPermission(context, id, list[index]),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                              title: Text(Utils.niceDateString(list[index])),
                              subtitle: null,
                            ));
                }),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: MButton(
              onTap: () => Get.back(),
              type: ButtonType.cancel,
            ),
          )
        ],
      ),
    );
  }

  addPermission(context, String id, var dateString) {
    return Dialogs.dialog(
      context,
      "Add Permission",
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
              Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("Date: ${Utils.niceDateString(dateString)}  "))
                  .padding9,
              const Divider().padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => MButton(
                        onTap: () {
                          controller.savePermission(id, dateString);
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

  showDates(context, String id, String date) {
    return Dialogs.dialog(
        context,
        'Absent Days',
        true,
        0.0,
        1.5,
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(date),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MButton(
                    onTap: () => Get.back(),
                    type: ButtonType.cancel,
                  )
                ],
              )
            ],
          ),
        ));
  }
}

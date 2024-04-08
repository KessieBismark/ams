import 'controller.dart';
import '../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';
import '../../../services/widgets/button.dart';

class PermissionTable extends GetView<PermissionCon> {
  const PermissionTable({super.key});

  @override
  Widget build(BuildContext context) {
    //setColumnSizeRatios(1, 2);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.getData.value
          ? DataTable2(
              columnSpacing: 12,
              horizontalMargin: 10,
              minWidth: 1200,
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
                  fixedWidth: 150,
                  label: "Name".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.perDisplayData.sort((item1, item2) =>
                          item2.surname.compareTo(item1.surname));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                  tooltip: "Employee's name",
                ),
                DataColumn2(
                  label: "Department".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort((item1, item2) =>
                          item1.department.compareTo(item2.department));
                    } else {
                      controller.perDisplayData.sort((item1, item2) =>
                          item2.department.compareTo(item1.department));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                   DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.perDisplayData.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Start Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort(
                          (item1, item2) => item1.sdate.compareTo(item2.sdate));
                    } else {
                      controller.perDisplayData.sort(
                          (item1, item2) => item2.sdate.compareTo(item1.sdate));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "End Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort(
                          (item1, item2) => item1.eDate.compareTo(item2.eDate));
                    } else {
                      controller.perDisplayData.sort(
                          (item1, item2) => item2.eDate.compareTo(item1.eDate));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Days".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort(
                          (item1, item2) => item1.days.compareTo(item2.days));
                    } else {
                      controller.perDisplayData.sort(
                          (item1, item2) => item2.days.compareTo(item1.days));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Hours".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort(
                          (item1, item2) => item1.hours.compareTo(item2.hours));
                    } else {
                      controller.perDisplayData.sort(
                          (item1, item2) => item2.hours.compareTo(item1.hours));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Type".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.perDisplayData.sort(
                            (item1, item2) => item1.type.compareTo(item2.type));
                      } else {
                        controller.perDisplayData.sort(
                            (item1, item2) => item2.type.compareTo(item1.type));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Permission type"),
                DataColumn2(
                  label: "Reason".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort((item1, item2) =>
                          item1.reason!.compareTo(item2.reason!));
                    } else {
                      controller.perDisplayData.sort((item1, item2) =>
                          item2.reason!.compareTo(item1.reason!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.perDisplayData.sort(
                          (item1, item2) => item1.date.compareTo(item2.date));
                    } else {
                      controller.perDisplayData.sort(
                          (item1, item2) => item2.date.compareTo(item1.date));
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
                controller.perDisplayData.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.perDisplayData[index].surname}, ${controller.perDisplayData[index].middlename} ${controller.perDisplayData[index].firstname}"
                            .toAutoLabel()),
                    DataCell(controller.perDisplayData[index].department
                        .toAutoLabel()),
                            DataCell(controller.perDisplayData[index].branch
                        .toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].sdate).toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].eDate).toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].days).toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].hours).toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].type).toAutoLabel()),
                    DataCell(
                        controller.perDisplayData[index].reason!.toAutoLabel()),
                    DataCell(
                        (controller.perDisplayData[index].date).toAutoLabel()),
                    DataCell(
                      // if (_fxn.access
                      //     .contains(_fxn.initials("Permissions", 3)))
                      Obx(
                        () => !controller.deleting.value ||
                                controller.perDisplayData[index].staffID !=
                                    controller.deleteID
                            ? IconButton(
                                tooltip: "Delete",
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Delete',
                                    content: Column(
                                      children: [
                                        "Are you sure you want to delete ${controller.perDisplayData[index].surname}, ${controller.perDisplayData[index].middlename} ${controller.perDisplayData[index].firstname} permission record"
                                            .toLabel()
                                            .padding9,
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MButton(
                                              onTap: () {
                                                controller.delete(controller
                                                    .perDisplayData[index].id);
                                                Get.back();
                                              },
                                              title: "Yes",
                                              color: Colors.redAccent,
                                            ),
                                            MButton(
                                              onTap: () => Get.back(),
                                              title: 'No',
                                              color: Colors.green.shade400,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ).center
                            : const MWaiting(),
                      ),
                    )
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/extension.dart';
import 'controller/controller.dart';

class OvertimeTable extends GetView<OvertimeCon> {
  const OvertimeTable({super.key});

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
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.overTimeDisplayData.sort((item1, item2) =>
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
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item1.department.compareTo(item2.department));
                    } else {
                      controller.overTimeDisplayData.sort((item1, item2) =>
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
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Total seconds".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item1.totalSeconds!.compareTo(item2.totalSeconds!));
                    } else {
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item2.totalSeconds!.compareTo(item1.totalSeconds!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                  tooltip: "Overtime in seconds",
                ),
                DataColumn2(
                  label: "Time".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item1.totalSeconds!.compareTo(item2.totalSeconds!));
                    } else {
                      controller.overTimeDisplayData.sort((item1, item2) =>
                          item2.totalSeconds!.compareTo(item1.totalSeconds!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
              ],
              rows: List.generate(
                controller.overTimeDisplayData.length,
                (index) => DataRow(
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.overTimeDisplayData[index].surname}, ${controller.overTimeDisplayData[index].middlename} ${controller.overTimeDisplayData[index].firstname}"
                            .toAutoLabel()),
                    DataCell(controller.overTimeDisplayData[index].department
                        .toAutoLabel()),  DataCell(controller.overTimeDisplayData[index].branch
                        .toAutoLabel()),
                    DataCell(
                        (controller.overTimeDisplayData[index].totalSeconds!)
                            .toAutoLabel()),
                    Utils.isNumeric(
                            controller.overTimeDisplayData[index].totalSeconds!)
                        ? DataCell((Utils.convertTime(int.parse(controller
                                    .overTimeDisplayData[index].totalSeconds!))
                                .toString())
                            .toAutoLabel())
                        : DataCell(controller
                            .overTimeDisplayData[index].totalSeconds!
                            .toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

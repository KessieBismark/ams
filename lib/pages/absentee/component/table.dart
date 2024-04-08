import 'controller/controller.dart';
import '../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';

class AbsentTable extends GetView<AbsenteeCon> {
  const AbsentTable({super.key});

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
                        controller.absentDisplayData.sort((item1, item2) =>
                            item1.surname.compareTo(item2.surname));
                      } else {
                        controller.absentDisplayData.sort((item1, item2) =>
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
                        controller.absentDisplayData.sort((item1, item2) =>
                            item1.department.compareTo(item2.department));
                      } else {
                        controller.absentDisplayData.sort((item1, item2) =>
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
                      controller.absentDisplayData.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.absentDisplayData.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
              ],
              rows: List.generate(
                controller.absentDisplayData.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.absentDisplayData[index].surname}, ${controller.absentDisplayData[index].middlename} ${controller.absentDisplayData[index].firstname}"
                            .toAutoLabel()),
                    DataCell(controller.absentDisplayData[index].department
                        .toAutoLabel()),
                    DataCell(controller.absentDisplayData[index].branch
                        .toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

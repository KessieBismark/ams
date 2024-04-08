import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/waiting.dart';
import 'controller.dart';

class AttSummary extends GetView<DashCon> {
  const AttSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => !controller.aLoad.value
        ? DataTable2(
            //   columnSpacing: 12,
            horizontalMargin: 12,
            // minWidth: 600,
            smRatio: 0.75,
            lmRatio: 1.5,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.black12),
            sortColumnIndex: controller.sortNameIndex.value,
            sortAscending: controller.sortNameAscending.value,
            columns: [
              DataColumn2(
                size: ColumnSize.S,
                label: '#'.toLabel(bold: true),
                // numeric: true,
              ),
              DataColumn(
                label: "Name".toLabel(bold: true),
                onSort: (int columnIndex, bool ascending) {
                  if (ascending) {
                    controller.aList.sort((item1, item2) =>
                        item1.surname.compareTo(item2.surname));
                  } else {
                    controller.aList.sort((item1, item2) =>
                        item2.surname.compareTo(item1.surname));
                  }
                  controller.sortNameAscending.value = ascending;
                  controller.sortNameIndex.value = columnIndex;
                },
              ),
              DataColumn(
                label: "Early".toLabel(bold: true),
                onSort: (int columnIndex, bool ascending) {
                  if (ascending) {
                    controller.aList.sort(
                        (item1, item2) => item1.early!.compareTo(item2.early!));
                  } else {
                    controller.aList.sort(
                        (item1, item2) => item2.early!.compareTo(item1.early!));
                  }
                  controller.sortNameAscending.value = ascending;
                  controller.sortNameIndex.value = columnIndex;
                },
              ),
              DataColumn(
                label: "Late".toLabel(bold: true),
                onSort: (int columnIndex, bool ascending) {
                  if (ascending) {
                    controller.aList.sort(
                        (item1, item2) => item1.late!.compareTo(item2.late!));
                  } else {
                    controller.aList.sort(
                        (item1, item2) => item2.late!.compareTo(item1.late!));
                  }
                  controller.sortNameAscending.value = ascending;
                  controller.sortNameIndex.value = columnIndex;
                },
              ),
            ],
            rows: List.generate(
              controller.aList.length,
              (index) => DataRow(
                color: index.isEven
                    ? MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(31, 167, 162, 162))
                    : null,
                cells: [
                  DataCell((index + 1).toString().toAutoLabel()),
                  DataCell(
                      "${controller.aList[index].surname}, ${controller.aList[index].middleName} ${controller.aList[index].firstName}"
                          .toAutoLabel()),
                  DataCell(controller.aList[index].early!.toAutoLabel()),
                  DataCell(controller.aList[index].late!.toAutoLabel()),
                ],
              ),
            ),
          ).padding6
        : const MWaiting());
  }
}

import 'package:ams/pages/monthly/component/controller.dart';
import 'package:ams/services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';

class MTimeTable extends GetView<MonthlyReportCon> {
  const MTimeTable({Key? key}) : super(key: key);

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
                      controller.dailyDisplayData.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.dailyDisplayData.sort((item1, item2) =>
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
                      controller.dailyDisplayData.sort((item1, item2) =>
                          item1.department.compareTo(item2.department));
                    } else {
                      controller.dailyDisplayData.sort((item1, item2) =>
                          item2.department.compareTo(item1.department));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Count".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dailyDisplayData.sort(
                          (item1, item2) => item1.count.compareTo(item2.count));
                    } else {
                      controller.dailyDisplayData.sort(
                          (item1, item2) => item2.count.compareTo(item1.count));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                  tooltip: "Number of occurrence",
                ),
                DataColumn2(
                  label: "Time".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.dailyDisplayData.sort(
                          (item1, item2) => item1.time.compareTo(item2.time));
                    } else {
                      controller.dailyDisplayData.sort(
                          (item1, item2) => item2.time.compareTo(item1.time));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Date".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.dailyDisplayData.sort(
                            (item1, item2) => item1.date.compareTo(item2.date));
                      } else {
                        controller.dailyDisplayData.sort(
                            (item1, item2) => item2.date.compareTo(item1.date));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Entry date"),
              ],
              rows: List.generate(
                controller.dailyDisplayData.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.dailyDisplayData[index].surname}, ${controller.dailyDisplayData[index].middlename} ${controller.dailyDisplayData[index].firstname}"
                            .toAutoLabel()),
                    DataCell(controller.dailyDisplayData[index].department
                        .toAutoLabel()),
                    DataCell((controller.dailyDisplayData[index].count)
                        .toAutoLabel()),
                    DataCell((controller.dailyDisplayData[index].time)
                        .toAutoLabel()),
                    DataCell((controller.dailyDisplayData[index].date)
                        .toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

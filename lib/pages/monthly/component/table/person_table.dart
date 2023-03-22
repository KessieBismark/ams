import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/widgets/waiting.dart';
import '../../../../services/widgets/extension.dart';
import '../controller.dart';

class PersonTable extends GetView<MonthlyReportCon> {
  const PersonTable({Key? key}) : super(key: key);

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
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.mReportDisplayData.sort((item1, item2) =>
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
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item1.department.compareTo(item2.department));
                    } else {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item2.department.compareTo(item1.department));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "In Time".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item1.inTime.compareTo(item2.inTime));
                    } else {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item2.inTime.compareTo(item1.inTime));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Out Time".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item1.outTime!.compareTo(item2.outTime!));
                    } else {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item2.outTime!.compareTo(item1.outTime!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Hours".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item1.hours!.compareTo(item2.hours!));
                    } else {
                      controller.mReportDisplayData.sort((item1, item2) =>
                          item2.hours!.compareTo(item1.hours!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.mReportDisplayData.sort(
                          (item1, item2) => item1.branch.compareTo(item2.date));
                    } else {
                      controller.mReportDisplayData.sort(
                          (item1, item2) => item2.branch.compareTo(item1.date));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Date".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.mReportDisplayData.sort(
                            (item1, item2) => item1.date.compareTo(item2.date));
                      } else {
                        controller.mReportDisplayData.sort(
                            (item1, item2) => item2.date.compareTo(item1.date));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Entry date"),
              ],
              rows: List.generate(
                controller.mReportDisplayData.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.mReportDisplayData[index].surname}, ${controller.mReportDisplayData[index].middlename} ${controller.mReportDisplayData[index].firstname}"
                            .toAutoLabel()),
                    DataCell(controller.mReportDisplayData[index].department
                        .toAutoLabel()),
                    DataCell((controller.mReportDisplayData[index].inTime)
                        .toAutoLabel()),
                    DataCell((controller.mReportDisplayData[index].outTime!)
                        .toAutoLabel()),
                    DataCell((controller.mReportDisplayData[index].hours!)
                        .toAutoLabel()),
                    DataCell((controller.mReportDisplayData[index].branch)
                        .toAutoLabel()),
                    DataCell((controller.mReportDisplayData[index].date)
                        .toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

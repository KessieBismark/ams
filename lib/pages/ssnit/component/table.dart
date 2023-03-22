import 'package:ams/services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/widgets/waiting.dart';
import 'controller/controller.dart';

class SsnitTable extends GetView<SsnitCon> {
  const SsnitTable({super.key});
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
                  label: "Structure Name".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssnitAmt.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.ssnitAmt.sort((item1, item2) =>
                          item2.surname.compareTo(item1.surname));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                  tooltip: "Employee name",
                ),
                DataColumn2(
                  label: "Amount".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssnitAmt.sort((item1, item2) =>
                          item1.amount.compareTo(item2.amount));
                    } else {
                      controller.ssnitAmt.sort((item1, item2) =>
                          item2.amount.compareTo(item1.amount));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Month".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssnitAmt.sort(
                          (item1, item2) => item1.month.compareTo(item2.month));
                    } else {
                      controller.ssnitAmt.sort(
                          (item1, item2) => item2.month.compareTo(item1.month));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Year".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssnitAmt.sort(
                          (item1, item2) => item1.year.compareTo(item2.year));
                    } else {
                      controller.ssnitAmt.sort(
                          (item1, item2) => item2.year.compareTo(item1.year));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
              ],
              rows: List.generate(
                controller.ssnitAmt.length,
                (index) => DataRow(
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.ssnitAmt[index].surname}, ${controller.ssnitAmt[index].middleName} ${controller.ssnitAmt[index].firstname}"
                            .toAutoLabel()),
                    DataCell((Utils().formatPrice(
                            double.parse(controller.ssnitAmt[index].amount)))
                        .toAutoLabel()),
                    DataCell(controller.ssnitAmt[index].month.toAutoLabel()),
                    DataCell(controller.ssnitAmt[index].year.toAutoLabel()),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}

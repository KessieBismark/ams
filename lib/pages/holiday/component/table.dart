import '../../../services/widgets/extension.dart';
import '../../../services/widgets/textbox.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../services/constants/color.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/widgets/button.dart';
import '../../../../../services/widgets/dialogs.dart';
import '../../../../../services/widgets/waiting.dart';
import '../../../services/utils/model.dart';
import '../../../services/widgets/delete_dailog.dart';
import '../../../services/widgets/dropdown.dart';
import 'controller/controller.dart';

class HolidayTable extends GetView<HolidayCon> {
  const HolidayTable({super.key});

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
                  label: "Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.hList.sort(
                          (item1, item2) => item1.date.compareTo(item2.date));
                    } else {
                      controller.hList.sort(
                          (item1, item2) => item2.date.compareTo(item1.date));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Description".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.hList.sort(
                          (item1, item2) => item1.des!.compareTo(item2.des!));
                    } else {
                      controller.hList.sort(
                          (item1, item2) => item2.des!.compareTo(item1.des!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.hList.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.hList.sort((item1, item2) =>
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
                controller.hList.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(controller.hList[index].date.toAutoLabel()),
                    DataCell(controller.hList[index].des!.toAutoLabel()),
                    DataCell(controller.hList[index].branch.toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access
                            .contains(Utils.initials("holidays", 2)))
                          IconButton(
                            onPressed: () {
                              controller.dailyDate =
                                  controller.hList[index].date;
                              controller.dateText.text =
                                  controller.hList[index].date;
                              controller.des.text =
                                  controller.hList[index].des!;
                              controller.branch.text =
                                  controller.hList[index].branch;
                              controller.selBranch = DropDownModel(
                                  id: controller.hList[index].id.toString(),
                                  name: controller.hList[index].branch);
                              updateDialog(context,
                                  controller.hList[index].id.toString());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                        if (Utils.access
                            .contains(Utils.initials("holidays", 3)))
                          Obx(() => !controller.deleting.value ||
                                  controller.hList[index].id !=
                                      int.parse(controller.deleteID)
                              ? IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Delete Record',
                                        content: Delete(
                                          deleteName:
                                              (controller.hList[index].date)
                                                  .toString(),
                                          ontap: () {
                                            controller.delete(controller
                                                .hList[index].id
                                                .toString());
                                            Get.back();
                                          },
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              : const MWaiting()),
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
        "Edit Holiday",
        true,
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
                        }).padding9)
                    : Container(),
                InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.today, // Refer step 1
                        firstDate: DateTime.parse('2021-01-01'),
                        lastDate: DateTime(9999),
                      );
                      if (picked != null) {
                        controller.today = picked;

                        // controller.dateText.text = picked.toString();
                        controller.dateText.text = Utils.dateOnly(picked);
                        controller.setDate.value = true;
                        controller.dailyDate =
                            DateFormat.yMMMMd().format(picked);
                      }
                    },
                    child: Obx(
                      () => ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(Icons.calendar_today, color: voilet),
                        title: controller.setDate.value
                            ? "Selected date: ${controller.dateText.text}"
                                .toLabel()
                            : "Click here to select date".toLabel(),
                      ).vPadding3,
                    ).padding9),
                MEdit(
                  hint: "Description",
                  controller: controller.des,
                ).padding9,
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => MButton(
                          onTap: () {
                            controller.updateDepartment(id);
                            Get.back();
                          },
                          type: ButtonType.save,
                          isLoading: controller.loading.value,
                        )),
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

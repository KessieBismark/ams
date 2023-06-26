import '../../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/model.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/dialogs.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import '../controller/controller.dart';

class SalartTable extends GetView<SalaryCon> {
  const SalartTable({super.key});
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
                      controller.salary.sort((item1, item2) =>
                          item1.surname.compareTo(item2.surname));
                    } else {
                      controller.salary.sort((item1, item2) =>
                          item2.surname.compareTo(item1.surname));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                  tooltip: "Salary structure name",
                ),
                DataColumn2(
                  label: "Amount".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.salary.sort((item1, item2) =>
                          item1.amount.compareTo(item2.amount));
                    } else {
                      controller.salary.sort((item1, item2) =>
                          item2.amount.compareTo(item1.amount));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Employees".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.salary.sort((item1, item2) =>
                            item1.group!.compareTo(item2.group!));
                      } else {
                        controller.salary.sort((item1, item2) =>
                            item2.group!.compareTo(item1.group!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Employees on the structure"),
                DataColumn2(label: "Action".toLabel(bold: true))
              ],
              rows: List.generate(
                controller.salary.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(
                        "${controller.salary[index].surname}, ${controller.salary[index].middlename} ${controller.salary[index].firstname}"
                            .toAutoLabel()),
                    DataCell((Utils().formatPrice(
                            double.parse(controller.salary[index].amount)))
                        .toAutoLabel()),
                    DataCell(
                      Row(
                        children: [
                          const Spacer(),
                          // if (_fxn.access
                          //     .contains(_fxn.initials("Permissions", 3)))
                          Obx(
                            () => !controller.deleting.value ||
                                    controller.salary[index].id !=
                                        controller.deleteID
                                ? IconButton(
                                    tooltip: "Delete",
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete',
                                        content: Column(
                                          children: [
                                            "Are you sure you want to delete ${controller.salary[index].surname}, ${controller.salary[index].middlename} ${controller.salary[index].firstname}"
                                                .toLabel()
                                                .padding9,
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MButton(
                                                  onTap: () {
                                                    controller.delete(controller
                                                        .salary[index].id);
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
                                  )
                                : const MWaiting(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }

  add(context) {
    return Dialogs.dialog(
        context,
        "Edit salary structure",
        false,
        0.0,
        0.0,
        SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                MEdit(
                  hint: "Structure Name",
                  controller: controller.name,
                  validate: Utils.validator,
                ).padding9,
                Utils.branchID == '0'
                    ? Obx(() => DropDownText2(
                        hint: "Select Branch",
                        label: "Select Branch",
                        controller: controller.selBranch,
                        isLoading: controller.isB.value,
                        validate: true,
                        list: controller.bList,
                        onChange: (DropDownModel? data) {
                          controller.branch.text = data!.id.toString();
                          controller.selBranch = data;
                          controller.getDepartment(controller.branch.text);
                        }).padding9)
                    : Container(),
                Obx(() => DropDownText2(
                    hint: "Select Department",
                    label: "Select Department",
                    controller: controller.selDepartment,
                    isLoading: controller.depLoading.value,
                    validate: true,
                    list: controller.departmentList,
                    onChange: (DropDownModel? data) {
                      controller.depText.text = data!.id.toString();
                      controller.selDepartment = data;

                      controller.getEmployees(
                          controller.branch.text, data.id.toString());
                    }).padding9),
                // Obx(() => MultiSelect(
                //         onChange: (value) {
                //           controller.eListSelected = value;
                //         },
                //         isLoading: controller.empLoading.value,
                //         selected: controller.eListSelected,
                //         items: controller.eList,
                //         hint: "Group employee under this structure")
                //     .padding9),
                MEdit(
                  hint: "Salary Amount",
                  controller: controller.amount,
                  inputType: TextInputType.number,
                  validate: Utils.validator,
                ),
                // Obx(() => !controller.isGroup.value
                //     ? MultiSelect(
                //             onChange: (item) {
                //               controller.selectedGroup = item;
                //               //  controller.getItemList(item.join(","));
                //             },
                //             selected: controller.selectedGroup,
                //             items: controller.salaryGroup,
                //             hint: "Group employee under this structure")
                //         .padding9
                //     : const MWaiting()),
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MButton(
                      onTap: () {
                        //  controller.getAttendance();
                        Get.back();
                      },
                      type: ButtonType.save,
                    ),
                    MButton(
                      onTap: () {
                        //  controller.clearText();
                        Get.back();
                      },
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

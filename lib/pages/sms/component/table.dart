import '../../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/widgets/waiting.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/model.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/textbox.dart';
import 'controller/controller.dart';

class SmsTable extends GetView<SmsCon> {
  const SmsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(
        () => !controller.loading.value
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
                    label: "Receiver".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort((item1, item2) =>
                            item1.receiver.compareTo(item2.receiver));
                      } else {
                        controller.smsList.sort((item1, item2) =>
                            item2.receiver.compareTo(item1.receiver));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Message".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort(
                            (item1, item2) => item1.meg.compareTo(item2.meg));
                      } else {
                        controller.smsList.sort(
                            (item1, item2) => item2.meg.compareTo(item1.meg));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Date".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort(
                            (item1, item2) => item1.date.compareTo(item2.date));
                      } else {
                        controller.smsList.sort(
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
                  controller.smsList.length,
                  (index) => DataRow(
                    color: index.isEven
                        ? MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(31, 167, 162, 162))
                        : null,
                    cells: [
                      DataCell((index + 1).toString().toAutoLabel()),
                      DataCell(
                          controller.smsList[index].receiver.toAutoLabel()),
                      DataCell(controller.smsList[index].meg.toAutoLabel()),
                      DataCell(controller.smsList[index].date.toAutoLabel()),
                      DataCell(
                        Row(
                          children: [
                            // if (Utils()
                            //     .access
                            //     .contains(Utils.initials("Category", 2)))
                            IconButton(
                              onPressed: () {
                                controller.meg.text =
                                    controller.smsList[index].meg;
                                reSendDialog(context);
                              },
                              icon: Icon(
                                Icons.forward,
                                color: voilet,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const MWaiting(),
      ),
    ).card;
  }

  reSendDialog(context) {
    Get.defaultDialog(
        title: "Resend sms",
        barrierDismissible: false,
        content: SingleChildScrollView(
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Obx(() => DropDownText(
                          hint: "Select Sender type",
                          label: "Select Sender type",
                          controller: controller.type.value,
                          validate: Utils.validator,
                          onChange: (val) {
                            controller.type.value.text = val.toString();
                            if (val == 'Staff') {
                              controller.isStaff.value = true;
                            } else {
                              controller.isStaff.value = false;
                            }
                          },
                          list: controller.tList)
                      .padding9),
                  Obx(() => controller.isStaff.value
                      ? Column(
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
                                      controller.branch.text =
                                          data!.id.toString();
                                      controller.selBranch = data;
                                      controller.getDepartment(
                                          controller.branch.text);
                                    }).padding9)
                                : Container(),
                            Obx(() => DropDownText2(
                                hint: "Select department",
                                label: "Select department",
                                controller: controller.selDepartment,
                                isLoading: controller.depLoading.value,
                                validate: true,
                                list: controller.departmentList,
                                onChange: (DropDownModel? data) {
                                  controller.depText.text = data!.id.toString();
                                  controller.selDepartment = data;
                                  controller.getEmployees(
                                      controller.branch.text,
                                      data.id.toString());
                                }).padding9),
                            Obx(() => DropDownText2(
                                hint: "Select employee",
                                label: "Select employee",
                                controller: controller.selEmployee,
                                isLoading: controller.empLoading.value,
                                validate: true,
                                list: controller.employeesList,
                                onChange: (DropDownModel? data) {
                                  controller.empName.text = data!.id.toString();
                                  controller.getAllContact();
                                }).padding9),
                          ],
                        )
                      : MEdit(
                          hint: "Receiver",
                          controller: controller.receiver,
                          inputType: TextInputType.number,
                          validate: Utils.validator,
                        ).padding9),
                  MEdit(
                    hint: "Message",
                    controller: controller.meg,
                    maxLines: 5,
                    validate: Utils.validator,
                  ).padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: controller.sendSms,
                          isLoading: controller.isSave.value,
                          type: ButtonType.save,
                        ),
                      ),
                      MButton(
                        onTap: Get.back,
                        type: ButtonType.cancel,
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}

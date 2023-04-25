import 'controller.dart';
import '../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/color.dart';
import '../../../../../services/widgets/delete_dailog.dart';
import '../../../../../services/widgets/waiting.dart';
import '../../../responsive.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/model.dart';

class EmployeeTable extends GetView<EmployeeCon> {
  const EmployeeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //setColumnSizeRatios(1, 2);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(
        () => !controller.getData.value
            ? DataTable2(
                columnSpacing: 12,
                horizontalMargin: 10,
                minWidth: 2200,
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
                    fixedWidth: 80,
                    label: "Staff ID".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.staffID.compareTo(item2.staffID));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.staffID.compareTo(item1.staffID));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                      fixedWidth: 200,
                      label: "Name".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.surname.compareTo(item2.surname));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
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
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.department.compareTo(item2.department));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.department.compareTo(item1.department));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Department name"),
                  DataColumn2(
                    label: "Gender".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.gender!.compareTo(item2.gender!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.gender!.compareTo(item1.gender!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                      label: "Ssnit #".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.gender!.compareTo(item2.gender!));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.gender!.compareTo(item1.gender!));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Social security"),
                  DataColumn2(
                    label: "Bank".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.bank!.compareTo(item2.bank!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.bank!.compareTo(item1.bank!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Account #".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.accountNo!.compareTo(item2.accountNo!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.accountNo!.compareTo(item1.accountNo!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                      label: "Hours".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.hour.compareTo(item2.hour));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.hour.compareTo(item1.hour));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Working hours in a day"),
                  DataColumn2(
                      label: "DOB".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.dob!.compareTo(item2.dob!));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.dob!.compareTo(item1.dob!));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Date of Birth"),
                  DataColumn2(
                    label: "Contact".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.contact!.compareTo(item2.contact!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.contact!.compareTo(item1.contact!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                      label: "E Contact".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.eContact!.compareTo(item2.eContact!));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.eContact!.compareTo(item1.eContact!));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Emergency Contact"),
                  DataColumn2(
                    label: "Hired Date".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.hiredDate!.compareTo(item2.hiredDate!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.hiredDate!.compareTo(item1.hiredDate!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Residence".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.residence!.compareTo(item2.residence!));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.residence!.compareTo(item1.residence!));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Resigned".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.resigned.compareTo(item2.resigned));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.resigned.compareTo(item1.resigned));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                      label: "Finger(s)".toLabel(bold: true),
                      onSort: (int columnIndex, bool ascending) {
                        if (ascending) {
                          controller.employeeRecords.sort((item1, item2) =>
                              item1.residence!.compareTo(item2.residence!));
                        } else {
                          controller.employeeRecords.sort((item1, item2) =>
                              item2.residence!.compareTo(item1.residence!));
                        }
                        controller.sortNameAscending.value = ascending;
                        controller.sortNameIndex.value = columnIndex;
                      },
                      tooltip: "Registered finger(s)"),
                  DataColumn2(
                    label: "Active".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.active.compareTo(item2.active));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
                            item2.active.compareTo(item1.active));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Branch".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.employeeRecords.sort((item1, item2) =>
                            item1.branch.compareTo(item2.branch));
                      } else {
                        controller.employeeRecords.sort((item1, item2) =>
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
                  controller.employeeRecords.length,
                  (index) => DataRow(
                    onLongPress: () {
                      controller.staffIDText.text =
                          controller.employeeRecords[index].staffID.toString();
                      controller.surNameText.text =
                          controller.employeeRecords[index].surname;
                      controller.firstNameText.text =
                          controller.employeeRecords[index].firstname!;
                      controller.middleNameText.text =
                          controller.employeeRecords[index].middlename!;
                      controller.depText.text =
                          controller.employeeRecords[index].department;
                      controller.genderText.text =
                          controller.employeeRecords[index].gender!;
                      controller.dobText.text =
                          controller.employeeRecords[index].dob!;
                      controller.contactTExt.text =
                          controller.employeeRecords[index].contact!;
                      controller.eContactTExt.text =
                          controller.employeeRecords[index].eContact!;
                      controller.hDateText.text =
                          controller.employeeRecords[index].hiredDate!;
                      controller.selectedHiredDate = DateTime.parse(
                          controller.employeeRecords[index].hiredDate!);
                      controller.isHire.value = true;
                      controller.residenceText.text =
                          controller.employeeRecords[index].residence!;
                      controller.resignedText.text =
                          controller.employeeRecords[index].resigned;
                      controller.isResign.value = true;
                      controller.resigned = DateTime(2030);

                      controller.selBranch = DropDownModel(
                          id: controller.employeeRecords[index].staffID
                              .toString(),
                          name: controller.employeeRecords[index].branch);
                      controller.selDepartment = DropDownModel(
                          id: controller.employeeRecords[index].staffID
                              .toString(),
                          name: controller.employeeRecords[index].department);
                      controller.branch.text =
                          controller.employeeRecords[index].bID!;
                      controller.depText.text =
                          controller.employeeRecords[index].dID!;
                      controller.employeeRecords[index].active == 1
                          ? controller.on.value = true
                          : controller.on.value = false;
                      if (Responsive.isMobile(context)) {
                        Get.toNamed('/editEmployee');
                      } else {
                        controller.updateEmployee.value = true;
                      }
                    },
                    color: index.isEven
                        ? MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(31, 167, 162, 162))
                        : null,
                    cells: [
                      DataCell((index + 1).toString().toAutoLabel()),
                      DataCell(controller.employeeRecords[index].staffID
                          .toString()
                          .toAutoLabel()),
                      DataCell(
                          "${controller.employeeRecords[index].surname}, ${controller.employeeRecords[index].middlename} ${controller.employeeRecords[index].firstname}"
                              .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].department
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].gender!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].ssnit!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].accountNo!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].bank!
                          .toAutoLabel()),
                      DataCell(
                          (controller.employeeRecords[index].hour.toString())
                              .toAutoLabel()),
                      DataCell(
                          controller.employeeRecords[index].dob!.toAutoLabel()),
                      DataCell(controller.employeeRecords[index].contact!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].eContact!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].hiredDate!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].residence!
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].resigned
                          .toAutoLabel()),
                      DataCell(controller.employeeRecords[index].finger!
                          .toAutoLabel()),
                      controller.employeeRecords[index].active == 1
                          ? DataCell(ClipOval(
                              child: Container(
                                color: const Color.fromARGB(255, 10, 134, 16),
                                child:
                                    "  Active  ".toLabel(color: Colors.white),
                              ),
                            ))
                          : DataCell(ClipOval(
                              child: Container(
                                  color: Colors.red,
                                  child: "  Inactive  "
                                      .toLabel(color: Colors.white)),
                            )),
                      DataCell(controller.employeeRecords[index].branch
                          .toAutoLabel()),
                      DataCell(
                        Row(
                          children: [
                            if (Utils.access
                                .contains(Utils.initials("employee", 2)))
                              IconButton(
                                onPressed: () {
                                  controller.staffIDText.text = controller
                                      .employeeRecords[index].staffID
                                      .toString();
                                  controller.ssnitText.text =
                                      controller.employeeRecords[index].ssnit!;
                                  controller.accountText.text = controller
                                      .employeeRecords[index].accountNo!;
                                  controller.hoursText.text = controller
                                      .employeeRecords[index].hour
                                      .toString();
                                  controller.surNameText.text =
                                      controller.employeeRecords[index].surname;
                                  controller.firstNameText.text = controller
                                      .employeeRecords[index].firstname!;
                                  controller.middleNameText.text = controller
                                      .employeeRecords[index].middlename!;
                                  controller.depText.text = controller
                                      .employeeRecords[index].department;
                                  controller.genderText.text =
                                      controller.employeeRecords[index].gender!;
                                  if (controller.employeeRecords[index].gender!
                                      .isNotEmpty) {
                                    controller.genSelected.value = controller
                                        .employeeRecords[index].gender!;
                                  }
                                  controller.dobText.text =
                                      controller.employeeRecords[index].dob!;
                                  controller.contactTExt.text = controller
                                      .employeeRecords[index].contact!;
                                  controller.eContactTExt.text = controller
                                      .employeeRecords[index].eContact!;
                                  controller.hDateText.text = controller
                                      .employeeRecords[index].hiredDate!;
                                  controller.residenceText.text = controller
                                      .employeeRecords[index].residence!;
                                  controller.resignedText.text = controller
                                      .employeeRecords[index].resigned;
                                  controller.selDepartment = DropDownModel(
                                      id: controller
                                          .employeeRecords[index].staffID
                                          .toString(),
                                      name: controller
                                          .employeeRecords[index].department);
                                  controller.employeeRecords[index].active == 1
                                      ? controller.on.value = true
                                      : controller.on.value = false;

                                  if (Responsive.isMobile(context)) {
                                    Get.toNamed('/editEmployee');
                                  } else {
                                    controller.updateEmployee.value = true;
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: voilet,
                                ),
                              ),
                            if (Utils.access
                                .contains(Utils.initials("employee", 3)))
                              Obx(() => !controller.isDelete.value ||
                                      controller
                                              .employeeRecords[index].staffID !=
                                          int.parse(controller.deleteID!)
                                  ? IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: 'Delete Record',
                                            content: Delete(
                                              deleteName:
                                                  ("${controller.employeeRecords[index].surname}, ${controller.employeeRecords[index].middlename} ${controller.employeeRecords[index].firstname}")
                                                      .toString(),
                                              ontap: () {
                                                controller.delete(
                                                  controller
                                                      .employeeRecords[index]
                                                      .staffID
                                                      .toString(),
                                                );
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
}

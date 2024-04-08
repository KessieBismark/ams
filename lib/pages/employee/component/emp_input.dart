import 'controller.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/extension.dart';

import '../../../services/constants/color.dart';
import '../../../services/utils/model.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployInput extends GetWidget<EmployeeCon> {
  const EmployInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 550,
        color: Utils.isLightTheme.value ? light : dark,
        child: PhysicalModel(
          color: Utils.isLightTheme.value ? light : dark,
          elevation: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                    key: controller.formKey,
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(250),
                      children: [
                        TableRow(children: [
                          "Add New Employee"
                              .toLabel(bold: true, fontsize: 20)
                              .vMargin9,
                          Container(
                            height: 50,
                          )
                        ]),
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Obx(() => SizedBox(
                                      width: 150,
                                      child: MEdit(
                                        hint: "Staff ID*",
                                        autofocus: true,
                                        readOnly: controller.isAuto.value,
                                        controller: controller.staffIDText,
                                        validate: Utils.validator,
                                      ).padding9,
                                    )),
                                SizedBox(
                                  width: 70,
                                  child: Obx(() => Row(
                                        children: [
                                          Checkbox(
                                              value: controller.isAuto.value,
                                              onChanged: (val) {
                                                controller.isAuto.value = val!;
                                                if (val) {
                                                  controller.getMaxId();
                                                }
                                              }),
                                          "Auto".toLabel()
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            MEdit(
                              hint: "Surname*",
                              controller: controller.surNameText,
                              validate: Utils.validator,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Middle name",
                              controller: controller.middleNameText,
                            ).padding9,
                            MEdit(
                              hint: "First name*",
                              controller: controller.firstNameText,
                              validate: Utils.validator,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Social Security #",
                              controller: controller.ssnitText,
                            ).padding9,
                            MEdit(
                              hint: "Accounts #",
                              controller: controller.accountText,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Bank name",
                              controller: controller.bankText,
                            ).padding9,
                            MEdit(
                              hint: "Working hours",
                              inputType: TextInputType.number,
                              controller: controller.hoursText,
                            ).padding9,
                          ],
                        ),
                        TableRow(
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
                                      controller.selBranch = data;
                                      controller.branch.text =
                                          data!.id.toString();
                                      controller
                                          .getDepartment(data.id.toString());
                                    }).padding9)
                                : "Branch: ${Utils.branchName}"
                                    .toLabel()
                                    .padding9,
                            Obx(() => DropDownText2(
                                hint: "Select department",
                                label: "Select department",
                                controller: controller.selDepartment,
                                isLoading: controller.depLoad.value,
                                validate: true,
                                list: controller.departmentList,
                                onChange: (DropDownModel? data) {
                                  controller.depText.text = data!.id.toString();
                                  controller.selDepartment = data;
                                }).padding9),
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Contact",
                              controller: controller.contactTExt,
                            ).padding9,
                            MEdit(
                              hint: "Emergency Contact",
                              controller: controller.eContactTExt,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Residence",
                              controller: controller.residenceText,
                            ).padding9,
                            Obx(
                              () => DropdownButton(
                                hint: 'Gender'.toLabel(),
                                onChanged: (newValue) {
                                  controller.setSelected(
                                    newValue.toString(),
                                  );
                                },
                                value: controller.genSelected.value,
                                items: [
                                  for (var data in controller.gen)
                                    DropdownMenuItem(
                                      value: data,
                                      child: Text(
                                        data,
                                      ),
                                    )
                                ],
                              ).padding9,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: controller
                                          .selectedDob, // RRefer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isDOB.value = false;
                                      controller.selectedDob = picked;
                                      controller.dobText.text =
                                          picked.toString();
                                      controller.isDOB.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isDOB.value
                                        ? "DOB: ${controller.selectedDob.toUtc().toString()}"
                                            .toLabel()
                                        : 'Date Of Birth'.toLabel(),
                                  ).vPadding3,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Obx(() => Text('Active: ${controller.on}')),
                                  Obx(
                                    () => Switch(
                                        onChanged: (val) => controller.toggle(),
                                        value: controller.on.value),
                                  )
                                ],
                              ).padding9,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: controller
                                          .selectedHiredDate, // Refer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isHire.value = false;
                                      controller.selectedHiredDate = picked;
                                      controller.hDateText.text =
                                          picked.toString();
                                      controller.isHire.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isHire.value
                                        ? "Hired: ${controller.selectedHiredDate.toUtc().toString()}"
                                            .toLabel()
                                        : 'Hired Date'.toLabel(),
                                  ).vPadding3,
                                )),
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          controller.resigned, // Refer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime(9999),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isResign.value = false;
                                      controller.resigned = picked;
                                      controller.resignedText.text =
                                          picked.toString();
                                      controller.isResign.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isResign.value
                                        ? "Resigned: ${controller.resigned.toUtc().toString()}"
                                            .toLabel()
                                        : 'Resigned Date'.toLabel(),
                                  ).vPadding3,
                                )),
                          ],
                        ),
                        TableRow(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Obx(() => !controller.loadData.value
                                  ? MButton(
                                      onTap: () => controller.insert(),
                                      type: ButtonType.save,
                                    )
                                  : const CupertinoActivityIndicator()),
                            ).padding9.padding9.hPadding9.hPadding9,
                            MButton(
                              onTap: () {
                                controller.input.value = false;
                              },
                              type: ButtonType.cancel,
                            ).padding9.padding9.hPadding9.hPadding9
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ).margin9.margin9,
        ),
      ).card.padding9.margin9,
    );
  }
}

class UpdateEmployInput extends GetWidget<EmployeeCon> {
  const UpdateEmployInput({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 550,
        color: Utils.isLightTheme.value ? light : dark,
        child: PhysicalModel(
          color: Utils.isLightTheme.value ? light : dark,
          elevation: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                    key: controller.formKey,
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(250),
                      children: [
                        TableRow(children: [
                          "Update Employee Record"
                              .toLabel(bold: true, fontsize: 17)
                              .vMargin9,
                          Container(
                            height: 50,
                          )
                        ]),
                        TableRow(
                          children: [
                            MEdit(
                              readOnly: true,
                              hint: "Staff ID*",
                              autofocus: true,
                              controller: controller.staffIDText,
                              validate: Utils.validator,
                            ).padding9,
                            MEdit(
                              hint: "Surname*",
                              controller: controller.surNameText,
                              validate: Utils.validator,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Middle name",
                              controller: controller.middleNameText,
                            ).padding9,
                            MEdit(
                              hint: "First name*",
                              controller: controller.firstNameText,
                              validate: Utils.validator,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Social Security #",
                              controller: controller.ssnitText,
                            ).padding9,
                            MEdit(
                              hint: "Accounts #",
                              controller: controller.accountText,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Bank name",
                              controller: controller.bankText,
                            ).padding9,
                            MEdit(
                              hint: "Working hours in a day",
                              inputType: TextInputType.number,
                              controller: controller.hoursText,
                            ).padding9,
                          ],
                        ),
                        TableRow(
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
                                      controller.selBranch = data;
                                      controller.branch.text =
                                          data!.id.toString();
                                      controller
                                          .getDepartment(data.id.toString());
                                    }).padding9)
                                : "Branch: ${Utils.branchName}"
                                    .toLabel()
                                    .padding9,
                            Obx(() => DropDownText2(
                                hint: "Select department",
                                label: "Select department",
                                controller: controller.selDepartment,
                                isLoading: controller.depLoad.value,
                                validate: true,
                                list: controller.departmentList,
                                onChange: (DropDownModel? data) {
                                  controller.depText.text = data!.id.toString();
                                  controller.selDepartment = data;
                                }).padding9),
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Contact",
                              controller: controller.contactTExt,
                            ).padding9,
                            MEdit(
                              hint: "Emergency Contact",
                              controller: controller.eContactTExt,
                            ).padding9,
                          ],
                        ),
                        TableRow(
                          children: [
                            MEdit(
                              hint: "Residence",
                              controller: controller.residenceText,
                            ).padding9,
                            Obx(
                              () => DropdownButton(
                                hint: 'Gender'.toLabel(),
                                onChanged: (newValue) {
                                  if (newValue != "Select Gender") {
                                    controller.setSelected(
                                      newValue.toString(),
                                    );
                                  }
                                },
                                value: controller.genSelected.value,
                                items: [
                                  for (var data in controller.gen)
                                    DropdownMenuItem(
                                      value: data,
                                      child: Text(
                                        data,
                                      ),
                                    )
                                ],
                              ).padding9,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: controller
                                          .selectedDob, // RRefer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isDOB.value = false;
                                      controller.selectedDob = picked;
                                      controller.dobText.text =
                                          picked.toString();
                                      controller.isDOB.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isDOB.value
                                        ? "DOB: ${controller.selectedDob.toUtc().toString()}"
                                            .toLabel()
                                        : 'Date Of Birth'.toLabel(),
                                  ).vPadding3,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Obx(() => Text('Active: ${controller.on}')),
                                  Obx(
                                    () => Switch(
                                        onChanged: (val) => controller.toggle(),
                                        value: controller.on.value),
                                  )
                                ],
                              ).padding9,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: controller
                                          .selectedHiredDate, // Refer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isHire.value = false;
                                      controller.selectedHiredDate = picked;
                                      controller.hDateText.text =
                                          picked.toString();
                                      controller.isHire.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isHire.value
                                        ? "Hired: ${controller.selectedHiredDate.toUtc().toString()}"
                                            .toLabel()
                                        : 'Hired Date'.toLabel(),
                                  ).vPadding3,
                                )),
                            Obx(() => InkWell(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          controller.resigned, // Refer step 1
                                      firstDate: controller.idate,
                                      lastDate: DateTime(9999),
                                    );
                                    if (picked != null &&
                                        picked != controller.iDate) {
                                      controller.isResign.value = false;
                                      controller.resigned = picked;
                                      controller.resignedText.text =
                                          picked.toString();
                                      controller.isResign.value = true;
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.access_time,
                                      color: voilet,
                                    ),
                                    title: controller.isResign.value
                                        ? "Resigned: ${controller.resigned.toUtc().toString()}"
                                            .toLabel()
                                        : 'Resigned Date'.toLabel(),
                                  ).vPadding3,
                                )),
                          ],
                        ),
                        TableRow(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Obx(() => !controller.loadData.value
                                  ? MButton(
                                      onTap: () {
                                        //  controller
                                        //       .getDepartment(Utils.branchID);
                                        controller.updateEmployInput();
                                        controller.updateEmployee.value = false;
                                      },
                                      title: "Update",
                                      color: greenfade,
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const CupertinoActivityIndicator()),
                            ).padding9.padding9.hPadding9.hPadding9,
                            MButton(
                              onTap: () {
                                controller.updateEmployee.value = false;
                              },
                              type: ButtonType.cancel,
                            ).padding9.padding9.hPadding9.hPadding9
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ).margin9.margin9,
        ),
      ).card.padding9.margin9,
    );
  }
}

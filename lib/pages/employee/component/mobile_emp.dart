import 'controller.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/utils/model.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/textbox.dart';
import '../../../services/widgets/waiting.dart';

class EmployeeMobileInput extends GetView<EmployeeCon> {
  const EmployeeMobileInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Add New Employee".toLabel(),
        backgroundColor: dark,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Obx(() => SizedBox(
                        width: myWidth(context, 1.3),
                        child: MEdit(
                          hint: "Staff ID*",
                          autofocus: true,
                          readOnly: controller.isAuto.value,
                          controller: controller.staffIDText,
                          validate: Utils.validator,
                        ).padding9,
                      )),
                  SizedBox(
                    width: 65,
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
              MEdit(
                hint: "Firstname*",
                controller: controller.firstNameText,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Middle name",
                controller: controller.middleNameText,
              ).padding9,
              MEdit(
                hint: "Social Security #",
                controller: controller.ssnitText,
              ).padding9,
              MEdit(
                hint: "Accounts #",
                controller: controller.accountText,
              ).padding9,
              MEdit(
                hint: "Working hours in a day",
                controller: controller.hoursText,
              ).padding9,
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
                        controller.branch.text = data!.id.toString();
                        controller.getDepartment(data.id.toString());
                      }).padding9)
                  : "Branch: ${Utils.branchName}".toLabel().padding9,
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
              MEdit(
                hint: "Contact",
                controller: controller.contactTExt,
              ).padding9,
              MEdit(
                hint: "Emergency Contact",
                controller: controller.eContactTExt,
              ).padding9,
              MEdit(
                hint: "Residence",
                controller: controller.residenceText,
              ).padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Gender".toLabel(),
                  const SizedBox(
                    width: 7,
                  ),
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
                    ),
                  ),
                ],
              ).hPadding9,
              Obx(() => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDob, // RRefer step 1
                        firstDate: controller.idate,
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != controller.iDate) {
                        controller.isDOB.value = false;
                        controller.selectedDob = picked;
                        controller.dobText.text = picked.toString();
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
                  )).padding9,
              Obx(() => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.selectedHiredDate, // Refer step 1
                        firstDate: controller.idate,
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != controller.iDate) {
                        controller.isHire.value = false;
                        controller.selectedHiredDate = picked;
                        controller.hDateText.text = picked.toString();
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
                  )).padding9,
              Row(
                children: [
                  Obx(() => Text('Active: ${controller.on}')),
                  Obx(
                    () => Switch(
                        onChanged: (val) => controller.toggle(),
                        value: controller.on.value),
                  ),
                ],
              ).padding9,
              Obx(() => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.resigned, // Refer step 1
                        firstDate: controller.idate,
                        lastDate: DateTime(9999),
                      );
                      if (picked != null && picked != controller.iDate) {
                        controller.isResign.value = false;
                        controller.resigned = picked;
                        controller.resignedText.text = picked.toString();
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
                  )).padding9,
              Row(
                children: [
                  Obx(() => !controller.loadData.value
                      ? MButton(
                          onTap: () => controller.insert(),
                          type: ButtonType.save,
                        ).padding9
                      : const MWaiting().padding9),
                  const Spacer()
                ],
              )
            ],
          ),
        ).padding9,
      ),
    );
  }
}

class UpdateEmployeeMobileInput extends GetView<EmployeeCon> {
  const UpdateEmployeeMobileInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Update Employee Record".toLabel(),
        backgroundColor: dark,
        centerTitle: true,
      ),
      body: ListView(children: [
        Form(
          key: controller.formKey,
          child: Column(
            children: [
              MEdit(
                hint: "Staff ID*",
                autofocus: true,
                readOnly: true,
                controller: controller.staffIDText,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Surname*",
                controller: controller.surNameText,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Firstname*",
                controller: controller.firstNameText,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Middle name",
                controller: controller.middleNameText,
              ).padding9,
              MEdit(
                hint: "Social Security #",
                controller: controller.ssnitText,
              ).padding9,
              MEdit(
                hint: "Accounts #",
                controller: controller.accountText,
              ).padding9,
              MEdit(
                hint: "Working hours in a day",
                controller: controller.hoursText,
              ).padding9,
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
                        controller.branch.text = data!.id.toString();
                        controller.getDepartment(data.id.toString());
                      }).padding9)
                  : "Branch: ${Utils.branchName}".toLabel().padding9,
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
              MEdit(
                hint: "Contact",
                controller: controller.contactTExt,
              ).padding9,
              MEdit(
                hint: "Emergency Contact",
                controller: controller.eContactTExt,
              ).padding9,
              MEdit(
                hint: "Residence",
                controller: controller.residenceText,
              ).padding9,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: myWidth(context, 2.5), child: "Gender".toLabel()),
                  SizedBox(
                    width: myWidth(context, 2.5),
                    child: Obx(
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
                      ),
                    ),
                  ),
                ],
              ).hPadding9,
              SizedBox(
                width: myWidth(context, 1.1),
                child: Obx(() => InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDob, // RRefer step 1
                          firstDate: controller.idate,
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != controller.iDate) {
                          controller.isDOB.value = false;
                          controller.selectedDob = picked;
                          controller.dobText.text = picked.toString();
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
                            ? Text(
                                "DOB: ${controller.selectedDob.toUtc().toString()}")
                            : const Text('Date Of Birth'),
                      ).vPadding3,
                    )),
              ).padding9,
              SizedBox(
                width: myWidth(context, 1.1),
                child: Obx(
                  () => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.selectedHiredDate, // Refer step 1
                        firstDate: controller.idate,
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != controller.iDate) {
                        controller.isHire.value = false;
                        controller.selectedHiredDate = picked;
                        controller.hDateText.text = picked.toString();
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
                          ? Text(
                              "Hired: ${controller.selectedHiredDate.toUtc().toString()}")
                          : const Text('Hired Date'),
                    ).vPadding3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text('Active: ${controller.on}')),
                  Obx(
                    () => Switch(
                        onChanged: (val) => controller.toggle(),
                        value: controller.on.value),
                  )
                ],
              ).padding9,
              SizedBox(
                width: myWidth(context, 1.1),
                child: Obx(() => InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.resigned, // Refer step 1
                          firstDate: controller.idate,
                          lastDate: DateTime(9999),
                        );
                        if (picked != null && picked != controller.iDate) {
                          controller.isResign.value = false;
                          controller.resigned = picked;
                          controller.resignedText.text = picked.toString();
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
                            ? Text(
                                "Resigned: ${controller.resigned.toUtc().toString()}")
                            : const Text('Resigned Date'),
                      ).vPadding3,
                    )),
              ),
              Row(
                children: [
                  Obx(() => !controller.loadData.value
                      ? MButton(
                          onTap: () => controller.updateEmployInput(),
                          type: ButtonType.save,
                        ).padding9
                      : const MWaiting().padding9),
                  const Spacer()
                ],
              )
            ],
          ),
        ).padding9,
      ]),
    );
  }
}

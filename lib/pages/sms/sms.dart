import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/richtext.dart';
import '../../../widgets/header/header.dart';
import '../../services/utils/model.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/textbox.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class SMS extends GetView<SmsCon> {
  const SMS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                pageName: 'SMS Portal',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.smsList = controller.sms.where((data) {
                      var name = data.receiver.toLowerCase();
                      return name.contains(text.toLowerCase());
                    }).toList();
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    // fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // if (Responsive.isDesktop(context) ||
                        //     Responsive.isTablet(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (Utils.access
                                .contains(Utils.initials("sms portal", 1)))
                              Row(
                                children: [
                                  MButton(
                                    onTap: () {
                                      controller.clearText();
                                      controller.getBranches();
                                      addDialog(context);
                                    },
                                    type: ButtonType.add,
                                  ).hPadding9,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Utils.userRole == "Super Admin"
                                      ? MButton(
                                          onTap: () {
                                            controller.getAPI().then((value) {
                                              apiDialog(context);
                                            });
                                          },
                                          title: "Sms settings",
                                          icon: const Icon(Icons.settings),
                                          color: const Color.fromARGB(
                                              255, 83, 68, 21),
                                        ).hPadding9
                                      : Container(),
                                ],
                              ),
                            Obx(() => MyRichText(
                                load: controller.loading.value,
                                mainColor: Utils.isLightTheme.value
                                    ? Colors.black
                                    : light,
                                subColor: Colors.red,
                                mainText: "SMS ",
                                subText: "(${controller.smsList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("sms portal", 0)))
                          SizedBox(
                              height: myHeight(context, 1.28),
                              child: const SmsTable())
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addDialog(context) {
    Get.defaultDialog(
        title: "Send sms",
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

  apiDialog(context) {
    Get.defaultDialog(
        title: "SMS API",
        barrierDismissible: true,
        content: SingleChildScrollView(
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Header",
                    controller: controller.header,
                  ).padding9,
                  MEdit(
                    hint: "API",
                    controller: controller.api,
                  ).padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: controller.insertAPI,
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

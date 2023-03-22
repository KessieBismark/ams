import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/utils/model.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dialogs.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/richtext.dart';
import '../../services/widgets/textbox.dart';
import '../../services/widgets/waiting.dart';
import '../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class Department extends GetView<DepartmentCon> {
  const Department({super.key});

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
                pageName: 'Department',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.depList = controller.dep.where((data) {
                      var name = data.name.toLowerCase();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (Utils.access
                                .contains(Utils.initials("department", 1)))
                            MButton(
                              onTap: () {
                                controller.clearText();
                                add(context);
                              },
                              type: ButtonType.add,
                            ).hPadding9,
                            Obx(() => MyRichText(
                                load: controller.getData.value,
                                mainColor:
                                    Utils.isLightTheme.value ? dark : light,
                                subColor: Colors.red,
                                mainText: "Department Table ",
                                subText: "(${controller.depList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("department", 0)))
                        SizedBox(
                            height: myHeight(context, 1.19),
                            child: const DepartmentTable())
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

  add(context) {
    return Dialogs.dialog(
        context,
        "Add Department",
        false,
        0.0,
        0.0,
        SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                MEdit(
                  hint: "Department Name",
                  controller: controller.depName,
                  validate: Utils.validator,
                ).padding9,
                Utils.branchID == '0'
                    ? Obx(() => DropDownText2(
                        hint: "Select branch",
                        label: "Select branch",
                        controller: controller.selBranch,
                        isLoading: controller.isB.value,
                        validate:true,
                        list: controller.bList,
                        onChange: (DropDownModel? data) {
                          controller.branch.text = data!.id.toString();
                          controller.selBranch = data;
                        }).padding9)
                    : Container(),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.swkdTime = value.format(context);
                            controller.swkdBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: greenfade,
                        ),
                        title: controller.swkdBool.value
                            ? "Weekdays start time: ${controller.swkdTime}"
                                .toLabel()
                            : "Click on the icon to select weekdays start time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.wkdTime = value.format(context);
                            controller.wkdBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: voilet,
                        ),
                        title: controller.wkdBool.value
                            ? "Weekdays closing time:${controller.wkdTime}"
                                .toLabel()
                            : "Click on the icon to select weekdays closing time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((TimeOfDay? value) {
                          if (value != null) {
                            controller.swknTime = value.format(context);
                            controller.swknBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.access_time,
                          color: greenfade,
                        ),
                        title: controller.swknBool.value
                            ? "Weekend start time: ${controller.swknTime}"
                                .toLabel()
                            : "Click on the icon to select weekend start time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                Obx(() => InkWell(
                      onTap: () async {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: controller.now.hour,
                                    minute: controller.now.minute))
                            .then((value) {
                          if (value != null) {
                            controller.wknTime = value.format(context);
                            controller.wknBool.value = true;
                          }
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(Icons.access_time, color: voilet),
                        title: controller.wknBool.value
                            ? "Weekend closing time: ${controller.wknTime}"
                                .toLabel()
                            : "Click on the icon to select weekend closing time"
                                .toLabel(),
                      ).vPadding3,
                    ).padding9),
                const Divider().padding9,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => !controller.loading.value
                        ? MButton(
                            onTap: () {
                              controller.insert();
                            },
                            type: ButtonType.save,
                          )
                        : const MWaiting()),
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

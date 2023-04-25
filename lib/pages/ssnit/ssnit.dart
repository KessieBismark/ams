import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

import '../../responsive.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dialogs.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/richtext.dart';
import '../../services/widgets/textbox.dart';
import '../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class Ssnit extends GetView<SsnitCon> {
  const Ssnit({super.key});

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
                pageName: 'SSNIT Contribution',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    controller.ssnitAmt = controller.ssnit.where((data) {
                      var name = data.surname.toLowerCase();
                      var fname = data.firstname.toLowerCase();
                      var middlename = data.middleName!.toLowerCase();
                      var amount = data.amount;
                      return name.contains(text.toLowerCase()) ||
                          fname.contains(text.toLowerCase()) ||
                          middlename.contains(text.toLowerCase()) ||
                          amount.contains(text);
                    }).toList();
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
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
                        if (Responsive.isDesktop(context) ||
                            Responsive.isTablet(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // if (_fxn.access
                              //     .contains(_fxn.initials("Departments", 1)))
                              MButton(
                                onTap: () => add(context),
                                type: ButtonType.add,
                              ).hPadding9,
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                               
                                  subColor: Colors.red,
                                  mainText: "Contributed records ",
                                  subText: "(${controller.ssnitAmt.length})")),

                              IconButton(
                                      onPressed: () async {
                                        controller.reload();
                                      },
                                      icon: const Icon(FontAwesome.file_excel))
                                  .hPadding9
                            ],
                          ).padding3.card,
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // if (_fxn.access
                              //     .contains(_fxn.initials("Departments", 1)))
                              Obx(() => MyRichText(
                                  load: controller.getData.value,
                                  
                                  subColor: Colors.red,
                                  mainText: "Contributed records ",
                                  subText: "(${controller.ssnitAmt.length})")),

                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "Add Structure") {
                                    add(context);
                                  } else {
                                    controller.reload();
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    controller.popUpMenuItems,
                              ),
                            ],
                          ).padding3.card,
                        SizedBox(
                            height: myHeight(context, 1.19),
                            child: const SsnitTable())
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
        "Add SSNIT rate",
        false,
        0.0,
        0.0,
        SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                MEdit(
                  hint: "Percentage rate %",
                  controller: controller.percentage,
                  validate: Utils.validator,
                ).padding9,
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

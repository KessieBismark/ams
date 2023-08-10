import 'component/controller/controller.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../responsive.dart';
import '../../services/constants/color.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/utils/model.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dialogs.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/richtext.dart';
import '../../services/widgets/textbox.dart';
import '../../widgets/header/header.dart';
import 'component/table/table.dart';

class Salary extends GetView<SalaryCon> {
  const Salary({super.key});

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
                pageName: 'Salary Structure',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.getData.value = true;
                    controller.getData.value = false;
                    controller.salary = controller.sal.where((data) {
                      var surname = data.surname.toLowerCase();
                      var middlename = data.middlename!.toLowerCase();
                      var firstname = data.firstname!.toLowerCase();
                      var branch = data.branch.toLowerCase();
                      var amount = data.amount;
                      return surname.contains(text.toLowerCase()) ||
                          middlename.contains(text.toLowerCase()) ||
                          branch.contains(text.toLowerCase()) ||
                          firstname.contains(text.toLowerCase()) ||
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
                                   mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: "Salary Table ",
                                  subText: "(${controller.salary.length})")),

                              IconButton(
                                      onPressed: () async {
                                        controller.reload();
                                      },
                                      icon: const Icon(Icons.refresh))
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
                                    mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                  subColor: Colors.red,
                                  mainText: "Attendance Table ",
                                  subText: "(${controller.salary.length})")),

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
                            height: myHeight(context, 1.28),
                            child: const SalartTable())
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
        "Add salary structure",
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
                        validate:true,
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
                    validate:true,
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
                      isLoading: controller.getData.value,
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

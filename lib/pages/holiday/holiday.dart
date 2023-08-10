import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'component/controller/controller.dart';
import 'component/table.dart';

class Holiday extends GetView<HolidayCon> {
  const Holiday({super.key});

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
                pageName: 'Holidays',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.hList = controller.h.where((data) {
                      var name = data.date.toLowerCase();
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
                                .contains(Utils.initials("holidays", 1)))
                              MButton(
                                onTap: () {
                                  controller.clearText();
                                  add(context);
                                },
                                type: ButtonType.add,
                              ).hPadding9,
                            Obx(() => MyRichText(
                                load: controller.getData.value,
                                 mainColor:  Utils.isLightTheme.value
              ? Colors.black
              :  light,
                                subColor: Colors.red,
                                mainText: "Holidays Table ",
                                subText: "(${controller.hList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("holidays", 0)))
                          SizedBox(
                            height: myHeight(context, 1.28),
                              child: const HolidayTable())
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
        "Add Holiday",
        false,
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
                        validate:true,
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
                            controller.insert();
                          },
                          isLoading: controller.loading.value,
                          type: ButtonType.save,
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

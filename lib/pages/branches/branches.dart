import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/richtext.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class Branches extends GetView<BranchesCon> {
  const Branches({super.key});

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
                pageName: 'Branches',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.bhList = controller.b.where((data) {
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
                            if (Utils.userRole == "Super Admin")
                              MButton(
                                onTap: () {
                                  controller.clearText();
                                  addDialog(context);
                                },
                                type: ButtonType.add,
                              ).hPadding9,
                            Obx(() => MyRichText(
                                load: controller.loading.value,
                                mainColor:
                                    Utils.isLightTheme.value ? dark : light,
                                subColor: Colors.red,
                                mainText: "Branches Record ",
                                subText: "(${controller.bhList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.userRole == "Super Admin")
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const BranchTable())
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
        title: "Add Branch",
        content: SingleChildScrollView(
          child: Form(
              key: controller.bformKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Name",
                    controller: controller.name,
                    validate: Utils.validator,
                  ).padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: () => controller.insert(),
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

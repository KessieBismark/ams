import 'dart:typed_data';

import 'package:ams/services/widgets/button.dart';
import 'package:ams/services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../../services/constants/constant.dart';
import '../../../services/widgets/hero_widgt.dart';
import 'controller.dart';

imageSource({required EmployeeCon con}) async {
  Get.defaultDialog(
    title: "Select Image Source",
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MTextButton(
            title: "Gallery",
            color: Colors.blue,
            onTap: () async {
              if (GetPlatform.isMobile) {
                final ImagePicker picker = ImagePicker();
                final XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);
                con.imgBytes = await file!.readAsBytes();
                con.imageUrl.value = file.name;
                con.imageName = file.name;
                con.isImg.value = true;
                con.isImg.value = false;
                Get.back();
              } else {
                con.pickFile();
                Get.back();
              }
            }),
        if (GetPlatform.isMobile)
          MTextButton(
              title: "Camera",
              color: Colors.green,
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file =
                    await picker.pickImage(source: ImageSource.camera);
                con.imgBytes = await file!.readAsBytes();
                con.imageUrl.value = file.name;
                con.imageName = file.name;
                con.isImg.value = true;
                con.isImg.value = false;
                Get.back();
              }),
      ],
    ).padding9,
  );
}

viewImageDesktop({
  required BuildContext context,
  required EmployeeCon controller,
  required Uint8List image,
  required String name,
}) {
  return Get.defaultDialog(
    title: "$name's Picture",
    content: SizedBox(
      width: myWidth(context, 2.5),
      height: myHeight(context, 1.8),
      child: Column(
        children: [
          HeroWidget(
            tag: 'img',
            trans: true,
            child: SizedBox(
              width: myWidth(context, 2.5),
              height: myHeight(context, 2.1),
              child: Center(
                child: Obx(() => controller.isImg.value
                    ? Image.memory(fit: BoxFit.fill, controller.imgBytes)
                    : Image.memory(fit: BoxFit.fill, controller.imgBytes)),
              ),
            ),
          ),
          const Divider(),
          MButton(
            onTap: () {
              imageSource(con: controller);
            },
            title: "Change Image",
          )
        ],
      ),
    ),
  );
}

import 'dart:typed_data';

import 'package:ams/pages/employee/component/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/extension.dart';
import '../../../services/widgets/hero_widgt.dart';

class UserImage extends StatelessWidget {
  final EmployeeCon controller;
  final Uint8List image;
  final String name;
  const UserImage(
      {super.key,
      required this.name,
      required this.image,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: "$name's Picture".toLabel(),
        actions: [
          MButton(
            onTap: () {
              imageSource();
            },
            title: "Change Image",
          )
        ],
      ),
      body: HeroWidget(
        tag: 'img',
        trans: true,
        child: Center(
          child: Obx(() => controller.isImg.value
              ? Image.memory(controller.imgBytes)
              : Image.memory(controller.imgBytes)),
        ),
      ),
    );
  }

  imageSource() {
    Get.defaultDialog(
      title: "Select Image Source",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MTextButton(
              title: "Gallery",
              color: Colors.blue,
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);

                controller.imgBytes = await file!.readAsBytes();
                controller.imageUrl.value = file.name;
                controller.imageName = file.name;
                controller.isImg.value = true;
                controller.isImg.value = false;
                Get.back();
              }),
          MTextButton(
              title: "Camera",
              color: Colors.green,
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file =
                    await picker.pickImage(source: ImageSource.camera);

                controller.imgBytes = await file!.readAsBytes();
                controller.imageUrl.value = file.name;
                controller.imageName = file.name;
                controller.isImg.value = true;
                controller.isImg.value = false;
                Get.back();
              }),
        ],
      ).padding9,
    );
  }
}

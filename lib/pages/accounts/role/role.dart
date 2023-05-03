import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/widgets/button.dart';
import '../../../services/widgets/extension.dart';
import 'controller/controller.dart';
import 'steppers/attendance/step.dart';
import 'steppers/company/step.dart';
import 'steppers/entries/steps.dart';
import 'steppers/report/steps.dart';
import 'steppers/sms/step.dart';

class Role extends GetView<RoleController> {
  const Role({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              "Assign roles for ${controller.name}".toUpperCase().toAutoLabel(),
          actions: [
            MButton(
              onTap: () => controller.insert(),
              type: ButtonType.save,
            ).padding9
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ExpansionTile(
                    title: "Company Branches".toLabel(bold: true),
                    children: const [CompanyRole()],
                  ),
                  ExpansionTile(
                    title: "Sms".toLabel(bold: true),
                    children: const [SmsRole()],
                  ),
                  ExpansionTile(
                    title: "Entries".toLabel(bold: true),
                    children: const [Entries()],
                  ),
                  ExpansionTile(
                    title: "Attendance".toLabel(bold: true),
                    children: const [Attend()],
                  ),
                  ExpansionTile(
                    title: "Reports".toLabel(bold: true),
                    children: const [Report()],
                  ),
                ],
              )).card,
        ));
  }
}

import 'dart:convert';

import 'package:ams/pages/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/company_details.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';

class CompanyInfoCon extends GetxController {
  final ciformKey = GlobalKey<FormState>();
  final cname = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  final gps = TextEditingController();
  final slogan = TextEditingController();
  final website = TextEditingController();
  final email = TextEditingController();
  List<LogicalKeyboardKey> keys = [];

  var isSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    cname.text = Cpy.cpyName;
    contact.text = Cpy.cpyContact;
    address.text = Cpy.cpyAddress;
    gps.text = Cpy.cpyGps;
    website.text = Cpy.cpyWebsite;
    email.text = Cpy.cpyEmail;
    slogan.text = Cpy.cpySlogan;
  }

  updateData() async {
    if (ciformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_company",
          "name": cname.text.trim().toUpperCase(),
          "contact": contact.text.trim(),
          "gps": gps.text.trim(),
          "slogan": slogan.text.trim(),
          "address": address.text.trim(),
          "website": website.text.trim(),
          "email": email.text.trim(),
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          Get.to(() => const Login());
        } else {
          isSave.value = false;
          Utils().showError(notSaved);
        }
      } catch (e) {
        isSave.value = false;
        print.call(e);
      }
    }
  }
}

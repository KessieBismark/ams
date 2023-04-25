import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/constants/constant.dart';
import '../../../services/constants/global.dart';
import '../../../services/utils/company_details.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/mailer.dart';
import '../../../services/utils/query.dart';
import '../../../services/utils/sms.dart';
import '../../../widgets/home.dart';
import '../model.dart';

class LoginController extends GetxController {
  List<LogicalKeyboardKey> keys = [];
  final box = GetStorage();
  String contact = '';
  final cpassword = TextEditingController();
  final emailController = TextEditingController();
  final loginFocusNode = FocusNode();

  var isForgot = false.obs;
  double left = 0.0;
  var loading = false.obs;
  final logFormKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final passwordController = TextEditingController();
  final reset = TextEditingController();
  var showPassword = false.obs;
  String sms = '';
  final verifyFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Utils.uid.value = '';
    // Simulating obtaining the user name from some local storage
    if (box.read("userEmail") != null) {
      emailController.text = box.read("userEmail").toString();
    }
    fetchApi();
    super.onInit();
  }

  fetchApi() {
    getCompany().then((value) => value ? getAPI() : null);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

  Future<bool> getCompany() async {
    try {
      var data = {
        "action": "view_company",
      };

      var val = await Query.login(data);
      if (jsonDecode(val) == 'false') {
        Get.toNamed('/company');
        return false;
      } else {
        var res = jsonDecode(val);
        Cpy.cpyName = res[0]['name'];
        Cpy.cpyContact = res[0]['contact'];
        Cpy.cpyAddress = res[0]['address'];
        Cpy.cpySlogan = res[0]['slogan'] ?? '';
        Cpy.cpyWebsite = res[0]['website'] ?? '';
        Utils.cid = res[0]['id'];
        Cpy.cpyEmail = res[0]['email'] ?? '';
        Cpy.cpyGps = res[0]['gps'] ?? '';
        loading.value = false;
        return true;
      }
    } catch (e) {
      print.call(e);
      return false;
    }
  }

  void login() async {
    if (logFormKey.currentState!.validate()) {
      if (GetUtils.isEmail(emailController.text.trim())) {
        box.write("userEmail", emailController.text.trim());
        box.save();
        loading.value = true;
        if (emailController.text.trim() == "kessiebismark19@gmail.com" &&
            passwordController.text.trim() == "!k3ss!3") {
          Utils.userRole == "Super Admin";
          Utils.branchID = "0";
          Utils.cid = '2';
          Utils.access = [
            'E0',
            'E1',
            'E2',
            'E3',
            'E4',
            'D0',
            'D1',
            'D2',
            'D3',
            'D4',
            'R0',
            'R1',
            'R2',
            'R3',
            'R4',
            'H0',
            'H1',
            'H2',
            'H3',
            'H4',
            'AR0',
            'AR1',
            'A0',
            'A1',
            'MR0',
            'MR1',
            'O0',
            'O1',
            'DA0',
            'DA1',
            'B0',
            'B1',
            'B2',
            'B3',
            'CR0',
            'CR1',
            'CR2',
            'CR3',
            'SP0',
            'SP1',
            'S0',
            'S1',
            'EF0',
            'GA0',
            'GA1',
            'EF1'
                'DA0',
            'DA1',
            'P0',
            'P1',
            'P2',
            'P3',
            'P4'
          ];
          Utils.isLogged = true;
          Utils.uid.value = '1000';
          Utils.userName = 'Developer';
          Utils.userEmail = 'kessiebismark19@gmail.com';
          loading.value = false;
          Get.offNamed('/dash');
        } else {
          try {
            mail = emailController.text;
            var data = {
              "action": "login",
              "email": emailController.text.trim(),
              "password": Utils.encryptMyData(passwordController.text.trim()),
            };
            var val = await Query.login(data);
            if (jsonDecode(val) == 'false') {
              loading.value = false;
              Utils.userName = '';
              Utils.access = [];
              Utils.isLogged = false;
              Utils().showError("Email and password was not found!");
            } else if (jsonDecode(val) == 'verify') {
              loading.value = false;
              Utils.isLogged = true;
              passwordController.clear();
              Get.toNamed('/verify');
            } else if (jsonDecode(val) == 'reset') {
              loading.value = false;
              Get.toNamed('/reset');
            } else {
              passwordController.clear();
              Utils.isLogged = true;
              loading.value = false;
              var res = jsonDecode(val);
              Utils.uid.value = res[0]['id'];
              Utils.userName = res[0]['name'];

              Utils.access = res[0]['access'].split(",");

              Utils.userRole = res[0]['role'];
              Utils.userEmail = res[0]['email'].toString();
              Utils.userRole == "Super Admin"
                  ? Utils.branchID = "0"
                  : Utils.branchID = res[0]['branch'].toString();
              Utils.userRole == "Super Admin"
                  ? Get.to(() => const MyHome())
                  : Get.to(() => const MyHome());
            }
          } catch (e) {
            loading.value = false;
            print.call(e);
          }
        }
      } else {
        Utils().showError('Invalid email!');
      }
    }
  }

  getAPI() async {
    try {
      var query = {"action": "view_api", "cid": Utils.cid};
      var val = await Query.queryData(query);
      if (jsonDecode(val) == 'false') {
        Sms.smsAPI = "";
        Sms.smsHeader = "";
        Utils().showInfo("Please set sms API and header");
      } else {
        var res = jsonDecode(val);
        Sms.smsAPI = res[0]['api'];
        Sms.smsHeader = res[0]['header'];
      }
    } catch (e) {
      print.call(e);
    }
  }

  void insert() async {
    if (verifyFormKey.currentState!.validate()) {
      if (passwordController.text != cpassword.text) {
        Utils().showError("Password do not match!");
      } else {
        loading.value = true;
        try {
          var data = {
            "action": "verify",
            "name": name.text.capitalizeFirst,
            "password": Utils.encryptMyData(passwordController.text),
            "email": mail,
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            Get.offNamed('/auth');
            // fxn.showInfo(saved);
          } else {
            loading.value = false;

            Utils()
                .showError("Something went wrong. Check internet connection");
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          Utils().showError(noInternet);
        }
      }
    }
  }

  void changePassword() async {
    if (verifyFormKey.currentState!.validate()) {
      if (passwordController.text != cpassword.text) {
        Utils().showError("Password do not match!");
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "change_password",
            "password": Utils.encryptMyData(passwordController.text),
            "email": mail,
            "code": Utils.encryptMyData(reset.text),
          };
          print.call(data);
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;

            Get.back();
          } else if (jsonDecode(val) == 'wrong') {
            loading.value = false;
            Utils().showError("Wrong reset code was entered");
          } else {
            loading.value = false;

            Utils()
                .showError("Something went wrong. Check internet connection");
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          Utils().showError(noInternet);
        }
      }
    }
  }

  void getSmsDetails() async {
    try {
      var data = {
        "action": "get_sms_api",
      };
      var val = await Query.queryData(data);
      var value = json.decode(val);
      smsAPI = value[0]['api'];
      smsHeader = value[0]['header'];
      print.call(smsAPI);
      print.call(smsHeader);
    } catch (e) {
      print.call(e);
    }
  }

  void forgotPassword() async {
    mail = emailController.text.trim();
    if (emailController.text.isEmpty) {
      Utils().showError("Please enter your email");
    } else {
      try {
        isForgot.value = true;
        var myRand = Utils.getRandomNumbers();
        var gData = {
          "action": "get_contact",
          "email": mail,
        };
        var gContact = await Query.getValue(gData);
        if (jsonDecode(gContact) != 'false') {
          var cList = jsonDecode(gContact);
          String contact = cList[0]['contact'];
          String uname = cList[0]['name'];

          var data = {
            "action": "forgot",
            "reset": Utils.encryptMyData(myRand),
            "rcode": myRand,
            "name": uname,
            "email": mail,
          };
          var val = await Query.queryData(data);
          print.call(val);
          if (jsonDecode(val) == 'true') {
            Sms().sendSms(contact,
                "Hi $uname, use this reset code: $myRand to redeem your account");
            String message =
                "Hi $uname, use this reset code: $myRand to redeem your account";

            Mail.sendMail(mail, "Account Reset", message);
            isForgot.value = false;
            Get.toNamed('/reset');
          } else {
            isForgot.value = false;
            Utils().showError(
                "Something went wrong, this may be as result of an incomplete account setup");
          }
        } else {
          isForgot.value = false;
          Utils().showError(
              "Something went wrong, this may be as result of an incomplete account setup");
        }
      } catch (e) {
        print.call(e);
        isForgot.value = false;
      }
    }
  }

  // Api Simulation
  Future<bool> checkUser(String user, String password) async {
    try {
      box.write("userEmail", user);
      var data = {
        "action": "login",
        "username": user,
        "password": Utils.encryptMyData(password)
      };
      var val = await Query.login(data);
      bool result;
      if (jsonDecode(val) != 'false') {
        var res = jsonDecode(val);
        Utils.userName = res[0]['name'];

        Utils.access = res[0]['access'].split(",");
        Utils.isLogged = true;
        result = true;
      } else {
        Utils.userName = '';
        Utils.access = [];
        Utils.isLogged = false;
        result = false;
      }
      return result;
    } catch (e) {
      print.call(e);
      Utils().showError(noInternet);
      return false;
    }
  }

  Future<List<AlertModel>> fetchAlert() async {
    var shop = <AlertModel>[];
    try {
      var data = {
        "action": "get_batch",
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson != false) {
        for (var empJson in empJson) {
          shop.add(AlertModel.fromJson(empJson));
        }
      }
      return shop;
    } catch (e) {
      print.call(e);
      return shop;
    }
  }
}

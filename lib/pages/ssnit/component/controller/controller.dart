import 'dart:convert';
import 'dart:io';

import '../model/model.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../../../employee/component/models/emp_models.dart';

class SsnitCon extends GetxController {
  List<SsnitModel> ssnit = <SsnitModel>[];
  List<SsnitModel> ssnitAmt = <SsnitModel>[];
  final formKey = GlobalKey<FormState>();

  final percentage = TextEditingController();

  List<String> salaryGroup = [];
  List<String> selectedGroup = [];

  String deleteID = '';
  var deleting = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var loading = false.obs;
  var isGroup = false.obs;
  int weekHours = 0;
  int weekendHours = 0;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  static const menuItems = <String>[
    'Add Structure',
    'Reload',
  ];
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  void reload() {
    getSsnit();
  }

  void getSsnit() {
    getData.value = true;
    fetchSsnit().then((value) {
      ssnit = [];
      ssnitAmt = [];
      ssnit.addAll(value);
      ssnitAmt = ssnit;

      getData.value = false;
    });
  }

  // void getEmployees(String val) {
  //   getData.value = true;
  //   fetchEmployee(val).then((value) {
  //     employee = [];
  //     employee.addAll(value);
  //     for (int i = 0; i < employee.length; i++) {
  //       salaryGroup.add(
  //           "${employee[i].surname}, ${employee[i].middlename} ${employee[i].firstname}");
  //     }
  //     getData.value = false;
  //   });
  // }

  Future<void> generateCsv(List<EmpListModel> data) async {
    if (data.isEmpty) {
      Utils().showError("There are no record to export");
    } else {
      try {
        List<List<dynamic>> csvData = [
          <String>[
            'Staff ID',
            'Surname',
            'Middle Name',
            'First Name',
            'Department'
          ],
          [data]
        ];

        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/SSNIT contribution.csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export SSNIT contribution.csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  void insert() async {
    if (formKey.currentState!.validate()) {
      if (!Utils.isNumeric(percentage.text)) {
        Utils().showError(numberOnly);
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "insert_permissions",
            "percentage": percentage.text,
          };
          print.call(data);
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            Utils().showInfo(saved);
          } else {
            loading.value = false;
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          Utils().showError(noInternet);
        }
      }
    }
  }

  Future<List<SsnitModel>> fetchSsnit() async {
    var permission = <SsnitModel>[];
    try {
      var data = {
        "action": "view_permissions",
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(SsnitModel.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }
}

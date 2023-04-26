import 'dart:convert';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/model.dart';
import '../../../branches/component/controller/controller.dart';
import '../model/model.dart';

final b = Get.find<BranchesCon>();

class DepartmentCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<DepartmentModel> dep = <DepartmentModel>[];
  List<DepartmentModel> depList = <DepartmentModel>[];
  List<DropDownModel> bList = [];
  DropDownModel? selBranch;
  final branch = TextEditingController();
  final depName = TextEditingController();
  final DateTime now = DateTime.now();
  var deleting = false.obs;
  var wkdBool = false.obs;
  var wknBool = false.obs;
  var swkdBool = false.obs;
  var swknBool = false.obs;
  var loading = false.obs;
  var getData = false.obs;
  String deleteID = "";
  String wknTime = '';
  String wkdTime = '';
  String swknTime = '';
  String swkdTime = '';
  var isB = false.obs;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() async {
    super.onInit();
    reload();
  }

  getBranches() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.b = [];
      b.b.addAll(value);
      bList = [];
      for (int i = 0; i < b.b.length; i++) {
        bList.add(DropDownModel(id: b.b[i].id, name: b.b[i].name));
      }
      isB.value = false;
    });
  }

  reload() {
    geDataView();
    clearText();
    getBranches();
  }

  geDataView() {
    getData.value = true;
    fetchDepartment().then((value) {
      dep = [];
      depList = [];
      dep.addAll(value);
      depList = dep;
      getData.value = false;
    });
    clearText();
  }

  clearText() {
    depName.clear();
    wknTime = '';
    wkdTime = '';
    swknTime = '';
    swkdTime = '';
    wkdBool.value = false;
    wknBool.value = false;
    swkdBool.value = false;
    swknBool.value = false;
  }

  void updateDepartment(String id) async {
    if (formKey.currentState!.validate()) {
      if (wkdTime.isEmpty || wknTime.isEmpty) {
        Utils().showError(
            "Closing time cannot be empty. Please click on the icons to set the time.");
      } else {
        loading.value = true;
        try {
          var data = {
            "action": "update_department",
            "id": id,
            "name": depName.text.toUpperCase(),
            "wkd": wkdTime,
            "swkd": swkdTime,
            "swknd": swknTime,
            "wkn": wknTime,
            "cid": Utils.cid,
            "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            reload();
            Utils().showInfo(saved);
          } else if (jsonDecode(val) == 'duplicate') {
            loading.value = false;
            Utils().showError("${depName.text} already exist in the database");
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

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        deleting.value = true;
        var data = {"action": "delete_department", "id": id};
        var val = await Query.queryData(data);
        if (jsonDecode(val) == 'true') {
          reload();
          deleting.value = false;
          Utils().showInfo("Record has been deleted");
        } else if (jsonDecode(val) == 'false') {
          deleting.value = false;
          Utils().showError("Something went wrong, could not delete record");
        } else {
          deleting.value = false;
          Utils().showError(noInternet);
        }
      } catch (e) {
        deleting.value = false;
        print.call(e);
        Utils().showError(noInternet);
      }
    }
  }

  void insert() async {
    if (formKey.currentState!.validate()) {
      if (wkdTime.isEmpty || wknTime.isEmpty) {
        Utils().showError(
            "Starting and closing time cannot be empty. Please click on the icons to set the time.");
      } else {
        loading.value = true;
        try {
          var data = {
            "action": "add_department",
            "name": depName.text.toUpperCase(),
            "wkd": wkdTime,
            "swkd": swkdTime,
            "swknd": swknTime,
            "wkn": wknTime,
            "cid": Utils.cid,
            "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            reload();
          } else if (jsonDecode(val) == 'duplicate') {
            loading.value = false;
            Utils().showError("${depName.text} already exist in the database");
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

  Future<List<DepartmentModel>> fetchDepartment() async {
    var record = <DepartmentModel>[];
    try {
      var data = {
        "action": "view_department",
        "cid": Utils.cid,
        "branch": Utils.branchID
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(DepartmentModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<DepartmentModel>> fetchDepartmentByBranch(String branch) async {
    var record = <DepartmentModel>[];
    try {
      var data = {
        "action": "view_department_by_branch",
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch : Utils.branchID
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(DepartmentModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}

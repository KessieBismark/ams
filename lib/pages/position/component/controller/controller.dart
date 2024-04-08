import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../model.dart';

class PositionCon extends GetxController {
  final bformKey = GlobalKey<FormState>();
  List<PositionModel> b = <PositionModel>[];
  List<PositionModel> bhList = <PositionModel>[];
  final name = TextEditingController();
  var loading = false.obs;
  var isSave = false.obs;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String deleteID = '';
  var isDelete = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Utils.checkAccess();
    reload();
  }

  reload() {
    getData();
    clearText();
  }

  getData() {
    loading.value = true;
    fetchServiceCategory().then((value) {
      b = [];
      bhList = [];
      b.addAll(value);
      bhList = b;
      loading.value = false;
    });
  }

  insert() async {
    if (bformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_position",
          "name": name.text.trim().capitalize,
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          reload();
        } else if (jsonDecode(val) == 'duplicate') {
          isSave.value = false;
          Utils().showError(duplicate);
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

  delete(String id) async {
    try {
      isSave.value = true;
      var query = {
        "action": "delete_position",
        "id": id,
      };
      var val = await Query.queryData(query);

      if (jsonDecode(val) == 'true') {
        isSave.value = false;
        reload();
      } else {
        isSave.value = false;
        Utils().showError(notSaved);
      }
    } catch (e) {
      isSave.value = false;
      print.call(e);
    }
  }

  clearText() {
    name.clear();
  }

  updateData(String id) async {
    if (bformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_position",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          reload();
          Get.back();
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

  Future<List<PositionModel>> fetchServiceCategory() async {
    var record = <PositionModel>[];
    try {
      var data = {
        "action": "view_position",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(PositionModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}

import 'dart:convert';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/model.dart';
import '../../../absentee/component/model/absentee_model.dart';
import '../../../branches/component/controller/controller.dart';
import '../model/model.dart';

final b = Get.find<BranchesCon>();

class HolidayCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<HolidayModel> h = <HolidayModel>[];
  List<HolidayModel> hList = <HolidayModel>[];
  List<DropDownModel> bList = [];
  DropDownModel? selBranch;
  final branch = TextEditingController();
  final dateText = TextEditingController();
  final des = TextEditingController();

  DateTime today = DateTime.now();
  var deleting = false.obs;
  var setDate = false.obs;
  String dailyDate = "";

  var loading = false.obs;
  var getData = false.obs;
  String deleteID = "";

  var isB = false.obs;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    dateText.text = Utils.dateOnly(DateTime.now());

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
    fetchHolidy().then((value) {
      h = [];
      hList = [];
      h.addAll(value);
      hList = h;
      getData.value = false;
    });
    clearText();
  }

  clearText() {
    dateText.clear();
    des.clear();
    branch.clear();
    setDate.value = true;
    setDate.value = false;
  }

  void updateDepartment(String id) async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      try {
        var data = {
          "action": "update_holiday",
          "id": id,
          "date": dateText.text,
          "des": des.text,
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
          Utils().showError("${dateText.text} already exist in the database");
        } else {
          loading.value = false;
          Utils().showError("Something went wrong. Check internet connection");
        }
      } catch (e) {
        loading.value = false;
        print.call(e);
        Utils().showError(noInternet);
      }
    }
  }

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        deleting.value = true;
        var data = {"action": "delete_holiday", "id": id};
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
      if (dateText.text.isNotEmpty) {
        if (Utils.branchID == '0' && branch.text.isNotEmpty) {
                loading.value = true;

          try {
            var data = {
              "action": "add_holiday",
              "date": dateText.text,
              "des": des.text,
              "cid": Utils.cid,
              "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
            };
            var val = await Query.queryData(data);
            if (jsonDecode(val) == 'true') {
              loading.value = false;
              reload();
            } else if (jsonDecode(val) == 'duplicate') {
              loading.value = false;
              Utils()
                  .showError("${dateText.text} already exist in the database");
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
        } else {
          Utils().showError("Please select a branch");
        }
      }else{
        Utils().showError("Date is required");
      }
    }
  }

  Future<List<HolidayModel>> fetchHolidy() async {
    var record = <HolidayModel>[];
    try {
      var data = {
        "action": "view_holiday",
        "cid": Utils.cid,
        "branch": Utils.branchID
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(HolidayModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}

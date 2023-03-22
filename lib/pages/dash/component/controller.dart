import 'dart:convert';

import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class DashCon extends GetxController {
  List<DashModel> aList = <DashModel>[];
  var eTotal = ''.obs;
  var late = ''.obs;
  var early = ''.obs;

  var bweek = false.obs;
  var bmonth = false.obs;
  var bday = false.obs;
  var byear = false.obs;
  var aLoad = false.obs;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  onInit() {
    super.onInit();
    if (!bday.value || !bweek.value || !bmonth.value || !byear.value) {
      bday.value = true;
      getAttSummary("Day");
    }
    sales();
  }

  void getAttSummary(var val) {
    aLoad.value = true;
    fetchAttSummary(val).then((value) {
      aList = [];
      aList.addAll(value);
      aLoad.value = false;
    });
  }

  sales() async {
    try {
      var query = {
        "action": "view_topDash",
        "cid": Utils.cid,
        "branch": Utils.branchID
      };
      var val = await Query.queryData(query);
      if (jsonDecode(val) != 'false') {
        var res = jsonDecode(val);
        eTotal.value = res[0]['employee'];
        early.value = res[0]['early'] ?? '0';
        late.value = res[0]['late'] ?? '0';
      }
    } catch (e) {
      print.call(e);
    }
  }

  Future<List<DashModel>> fetchAttSummary(String duration) async {
    var shop = <DashModel>[];
    try {
      var data = {
        "action": "view_att_summary",
        "duration": duration,
        "cid": Utils.cid,
        "branch": Utils.branchID,
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      for (var empJson in empJson) {
        shop.add(DashModel.fromJson(empJson));
      }
      return shop;
    } catch (e) {
      print.call(e);
      return shop;
    }
  }
}

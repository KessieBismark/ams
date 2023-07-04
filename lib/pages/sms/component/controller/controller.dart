import 'dart:convert';

import '../../../branches/component/controller/controller.dart';
import '../../../department/component/controller/controller.dart';
import '../../../employee/component/controller.dart';
import '../../../employee/component/models/emp_models.dart';
import '../../../../services/utils/model.dart';
import '../../../../services/utils/sms.dart';
import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/utils/query.dart';

final dep = Get.find<DepartmentCon>();
final emp = Get.find<EmployeeCon>();
final b = Get.find<BranchesCon>();

class SmsCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  final receiver = TextEditingController();
  final meg = TextEditingController();
  final type = TextEditingController().obs;
  final cn = TextEditingController();
  final api = TextEditingController();
  final header = TextEditingController();

  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  List<String> eList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;
  final empName = TextEditingController();
  final depText = TextEditingController();
  List<String> allContact = [];
  List<String> tList = ['Staff', 'Outsider'];
  List<String> empList = [];
  List<String> depList = [];
  List<SmsModel> sms = <SmsModel>[];

  List<SmsModel> smsList = <SmsModel>[];
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  var loading = false.obs;
  var isSave = false.obs;
  var isBranch = false.obs;
  var isEmp = false.obs;
  var isDep = false.obs;
  var isB = false.obs;
  var empLoading = false.obs;
  var depLoading = false.obs;

  var isStaff = false.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
    getBranches();
  }

  reload() {
    clearText();
    getData();
  }

  clearText() {
    receiver.clear();
    meg.clear();
    type.value.clear();
    isStaff.value = false;
    cn.clear();
    isSave.value = false;
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

  getDepartment(String branch) {
    depLoading.value = true;
    dep.fetchDepartmentByBranch(branch).then((value) {
      dep.dep = [];
      dep.dep.addAll(value);
      departmentList = [];
      departmentList.add(DropDownModel(id: '0', name: 'All'));
      for (int i = 0; i < dep.dep.length; i++) {
        departmentList.add(
            DropDownModel(id: dep.dep[i].id.toString(), name: dep.dep[i].name));
      }
      depLoading.value = false;
    });
  }

  void getEmployees(String branch, String dep) {
    empLoading.value = true;
    emp.fetchEmployeeByDepBranch(branch, dep).then((value) {
      emp.employee = [];
      employeesList = [];
      emp.employee.addAll(value);
      employeesList.add(DropDownModel(id: '0', name: 'All'));
      for (int i = 0; i < emp.employee.length; i++) {
        employeesList.add(DropDownModel(
            id: emp.employee[i].staffID.toString(),
            name:
                "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}"));
      }
      empLoading.value = false;
    });
  }

  sendSms() {
    processSms().then((value) {
      if (value) {
        insert();
      }
    });
  }

  Future<bool> processSms() async {
    bool result = false;
    if (Sms.smsAPI.isNotEmpty && Sms.smsHeader.isNotEmpty) {
      if (isStaff.value) {
        isSave.value = true;
        Sms().sendSms(allContact.join(','), meg.text.trim());
        result = true;
      } else {
        if (Utils.isNumeric(receiver.text) && (receiver.text.length == 10)) {
          isSave.value = true;
          Sms().sendSms(receiver.text.trim(), meg.text.trim());
          result = true;
          isSave.value = false;
        } else {
          isSave.value = false;
          Utils().showError("Wrong contact entered!");
        }
      }
    } else {
      Utils().showError('Sms api is not set, please the sms api');
    }
    return result;
  }

  getAllContact() {
    isSave.value = true;
    fetchAllContact().then((value) {
      emp.employee = [];
      allContact = [];
      emp.employee.addAll(value);
      for (int i = 0; i < emp.employee.length; i++) {
        allContact.add(emp.employee[i].contact!);
      }
      isSave.value = false;
    });
  }

  insert() async {
    try {
      isSave.value = true;

      var query = {
        "action": "add_sms",
        "receiver": isStaff.value ? 'Staff' : receiver.text.trim(),
        "meg": meg.text.trim(),
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
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

  insertAPI() async {
    if (header.text.isNotEmpty && api.text.isNotEmpty) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_api",
          "api": api.text.trim(),
          "header": header.text.trim(),
          "cid": Utils.cid,
          "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
          "department": depText.text,
          "staff_id": empName.text,
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          Sms.smsAPI = api.text;
          Sms.smsHeader = header.text;
          isSave.value = false;
          Utils().showInfo("API settings has been saved successfully");
        } else {
          isSave.value = false;
          Utils().showError(notSaved);
        }
      } catch (e) {
        isSave.value = false;
        print.call(e);
      }
    } else {
      Utils().showError("API and header cannot be empty!");
    }
  }

  Future getAPI() async {
    try {
      var query = {
        "action": "view_api",
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
      };
      var val = await Query.queryData(query);
      if (jsonDecode(val) == 'false') {
        Sms.smsAPI = "";
        Sms.smsHeader = "";
        Utils().showInfo("Please set sms API and header");
      } else {
        var res = jsonDecode(val);
        Sms.smsAPI = res[0]['api'];
        Sms.smsHeader = res[0]['header'];
        api.text = res[0]['api'];
        header.text = res[0]['header'];
      }
    } catch (e) {
      isSave.value = false;
      print.call(e);
    }
  }

  getData() {
    loading.value = true;
    fetchData().then((value) {
      sms = [];
      smsList = [];
      sms.addAll(value);
      smsList = sms;
      loading.value = false;
    });
  }

  Future<List<EmpListModel>> fetchAllContact() async {
    var record = <EmpListModel>[];
    try {
      var data = {
        "action": "get_contacts",
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(EmpListModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<SmsModel>> fetchData() async {
    var record = <SmsModel>[];
    try {
      var data = {
        "action": "view_sms",
        "cid": Utils.cid,
        "branch": Utils.branchID
        // "department": depText.text,
        // "staff_id": empName.text,
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SmsModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}

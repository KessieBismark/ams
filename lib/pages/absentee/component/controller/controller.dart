import 'dart:convert';
import 'dart:io';

import 'package:ams/pages/department/component/controller/controller.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/model.dart';
import '../../../../services/utils/query.dart';
import '../../../branches/component/controller/controller.dart';
import '../../../employee/component/controller.dart';
import '../../../employee/component/models/emp_models.dart';
import '../model/absentee_model.dart';

final dep = Get.find<DepartmentCon>();
final emp = Get.find<EmployeeCon>();
final b = Get.find<BranchesCon>();

class AbsenteeCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<AbsentModel> absent = <AbsentModel>[];
  List<AbsentModel> absentDisplayData = <AbsentModel>[];
  List<EmpListModel> employee = <EmpListModel>[];
  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  List<String> eList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;
  final dateText = TextEditingController();
  final empName = TextEditingController();
  final depText = TextEditingController();
  DateTime today = DateTime.parse("2021-01-08");
  var depLoading = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var setDate = false.obs;
  var isB = false.obs;
  String rdate = '';
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getBranches();
    dateText.text = Utils.dateOnly(DateTime.now());
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    setDate.value = true;
    isB.value = true;
    isB.value = false;
  }

  getBranches() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.b = [];
      b.b.addAll(value);
      bList = [];
      bList.add(DropDownModel(id: '0', name: 'All'));
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

  static const menuItems = <String>[
    'Search record',
    'Export',
    'Print',
  ];

  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  void getAttendance(String dep, String emp, String date, String bid) {
    getData.value = true;
    if (depText.text.isNotEmpty ||
        empName.text.isNotEmpty ||
        dateText.text.isNotEmpty) {
      fetchAbsentAtendance(bid, dep, date, emp).then((value) {
        absent = [];
        absentDisplayData = [];
        absent.addAll(value);
        absentDisplayData = absent;
        getData.value = false;
        clearText();
      });
    } else {
      Utils().showError(noInternet);
    }
  }

  void clearText() {
    depText.clear();
    empName.clear();
    dateText.clear();
    selDepartment = null;
    selEmployee = null;
    selBranch = null;
    branch.clear();
    isB.value = true;
    isB.value = false;
    depLoading.value = true;
    depLoading.value = false;
    empLoading.value = true;
    empLoading.value = false;
    setDate.value = false;
  }

  Future<void> generateCsv(List<AbsentModel> data) async {
    if (data.isEmpty) {
      Utils().showError("There are no record to export");
    } else {
      try {
        List<List<dynamic>> csvData = [
          <String>['Staff ID', 'Employee Name', 'Department', 'Branch'],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              "${data[i].surname}, ${data[i].middlename} ${data[i].firstname}",
              data[i].department,
              data[i].branch,
            ]
        ];
        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/absentees (${dateText.text}).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export absentees (${dateText.text}).csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  Future<List<AbsentModel>> fetchAbsentAtendance(
      String branch, String dep, String date, String emp) async {
    var permission = <AbsentModel>[];
    try {
      var data = {
        "action": "absentees",
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch : Utils.branchID,
        "date": date,
        "department": dep,
        "staff_id": emp,
      };
      print(data);
      var res = await Query.queryData(data);
      print(res);
      print.call((res));
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          permission.add(AbsentModel.fromMap(productJson));
        }
      } else {
        Utils().showError('No record found');
      }
      return permission;
    } catch (e) {
      print.call(e);
      return permission;
    }
  }
}

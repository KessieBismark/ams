import 'dart:convert';
import 'dart:io';

import '../../../department/component/controller/controller.dart';
import '../../../../services/utils/query.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/model.dart';
import '../../../absentee/component/controller/controller.dart';
import '../../../absentee/component/model/absentee_model.dart';
import '../../../branches/component/controller/controller.dart';
import '../../../employee/component/controller.dart';
import '../../../employee/component/models/emp_models.dart';
import '../model/daily_model.dart';

final dep = Get.find<DepartmentCon>();
final b = Get.find<BranchesCon>();
final emp = Get.find<EmployeeCon>();
final ab = Get.find<AbsenteeCon>();

class AttendanceCon extends GetxController {
  String dailyDate = "";
  List<DailyModel> daily = <DailyModel>[];
  List<DailyModel> dailyDisplayData = <DailyModel>[];
  List<AbsentModel> absent = <AbsentModel>[];
  List<AbsentModel> absentDisplayData = <AbsentModel>[];
  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;
  final empName = TextEditingController();
  final branch = TextEditingController();
  List<DropDownModel> departmentList = [];
  List<EmpListModel> employee = <EmpListModel>[];
  final dateText = TextEditingController();
  final empNametext = TextEditingController();
  final depText = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var setDate = true.obs;
  var isAbsent = false.obs;
  var depLoading = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  var isB = false.obs;
  String rdate = '';
  DateTime today = DateTime.now();

  static const menuItems = <String>[
    'Search record',
    'Download attendance',
    'Search Absentee',
    'Export',
    'Print',
  ];

  final Uri download = Uri.file(
      r'C:\Program Files (x86)\BISTECH GHANA\AMS FLUTTER\upload.exe',
      windows: true);

  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  @override
  void onInit() async {
    dateText.text = Utils.dateOnly(DateTime.now());
    dailyDate = Utils.dateOnly(DateTime.now());
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    getBranches();
    super.onInit();
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

  void getAbsent() {
    getData.value = true;
    if (depText.text.isNotEmpty ||
        empName.text.isNotEmpty ||
        dateText.text.isNotEmpty) {
      ab
          .fetchAbsentAtendance(
              branch.text, depText.text, dateText.text, empName.text)
          .then((value) {
        absent = [];
        absentDisplayData = [];
        absent.addAll(value);
        absentDisplayData = absent;
        getData.value = false;
        // clearText();
        isAbsent.value = true;
      });
    } else {
      Utils().showError(noInternet);
    }
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

  getAttendance() {
    Utils.branchID == '0' ? null : branch.text = Utils.branchID;
    if (branch.text.isNotEmpty &&
        depText.text.isNotEmpty &&
        empName.text.isNotEmpty) {
      getData.value = true;
      fetchDailyAtendance(branch.text, depText.text, empName.text)
          .then((value) {
        daily = [];
        dailyDisplayData = [];
        daily.addAll(value);
        dailyDisplayData = daily;
        getData.value = false;
        isAbsent.value = false;
        // clearText();
      });
    } else {
      Utils().showError("All entries are required");
    }
  }

  // void clearText() {
  //   depText.clear();
  //   empNametext.clear();
  //   //  dateText.clear();
  //   //setDate.value = false;
  // }

  Future<void> generateCsv(List<DailyModel> data) async {
    if (data.isEmpty) {
      Utils().showError("There are no record to export");
    } else {
      try {
        List<List<dynamic>> csvData = [
          <String>[
            'Staff ID',
            'Employee Name',
            'Department',
            'Branch',
            'In Time',
            'Out Time',
            'Overtime',
            'Hour',
            'Date'
          ],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              "${data[i].surname}, ${data[i].middlename} ${data[i].firstname}",
              data[i].department,
              data[i].branch,
              data[i].inTime,
              data[i].outTime,
              data[i].overtime,
              data[i].hours,
              data[i].date,
            ]
        ];
        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/attendance (${dateText.text}).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export attendance (${dateText.text}).csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  Future<List<DailyModel>> fetchDailyAtendance(
      String branch, String dep, String staff) async {
    var permission = <DailyModel>[];
    try {
      var data = {
        "action": "daily_attendance",
        "date": dateText.text,
        "branch": Utils.branchID == '0' ? branch : Utils.branchID,
        "cid": Utils.cid,
        "department": dep,
        "staff_id": staff,
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(DailyModel.fromMap(empJson));
        }
      }
      return permission;
    } catch (e) {
      print.call(e);
      return permission;
    }
  }
}

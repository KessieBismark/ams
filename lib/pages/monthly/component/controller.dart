import 'dart:convert';
import 'dart:io';

import '../../department/component/controller/controller.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/constants/constant.dart';
import '../../../services/utils/model.dart';
import '../../branches/component/controller/controller.dart';
import '../../employee/component/controller.dart';
import '../../employee/component/models/emp_models.dart';
import '../model/mreport_model.dart';

final dep = Get.put(DepartmentCon());
final emp = Get.find<EmployeeCon>();
final b = Get.find<BranchesCon>();

class MonthlyReportCon extends GetxController {
  final formKey = GlobalKey<FormState>();

  List<MReportModel> mReport = <MReportModel>[];
  List<MReportModel> mReportDisplayData = <MReportModel>[].obs;
  List<MModel> daily = <MModel>[];
  List<MModel> dailyDisplayData = <MModel>[].obs;
  List<EmpListModel> employee = <EmpListModel>[];
  List<EmpListModel> employeeRecords = <EmpListModel>[].obs;

  final sdateText = TextEditingController();
  final edateText = TextEditingController();
  final depText = TextEditingController();
  final reportType = TextEditingController();
  final DateTime now = DateTime.now();
  final time = TextEditingController();
  final empName = TextEditingController();
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  DateTime today = DateTime.parse("2021-01-08");
  var depLoading = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var setDate1 = false.obs;
  var setDate2 = false.obs;
  var wkdBool = false.obs;
  var inTime = false.obs;
  var outTime = false.obs;
  var byPerson = false.obs;
  var isB = false.obs;
  String selectedDate = "";

  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;

  @override
  void onInit() {
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

  getByDate() {
    if (depText.text.isNotEmpty &&
        empName.text.isNotEmpty &&
        sdateText.text.isNotEmpty &&
        edateText.text.isNotEmpty) {
      byPerson.value = true;
      getData.value = true;

      fetchMontlyByDate().then((value) {
        mReport = [];
        mReportDisplayData = [];
        mReport.addAll(value);
        mReportDisplayData = mReport;
        getData.value = false;
        // clearText();
      });
    } else {
      Utils().showError(infoNeeded);
    }
  }

  void getByTime() {
    if (depText.text.isNotEmpty &&
        time.text.isNotEmpty &&
        sdateText.text.isNotEmpty &&
        reportType.text.isNotEmpty &&
        edateText.text.isNotEmpty) {
      if (inTime.value == false && outTime.value == false) {
        Utils().showError(
            "Please select In Time or Out Time and also the report type");
      } else {
        getData.value = true;
        if (reportType.text == 'Detailed') {
          byPerson.value = true;
          fetchMontlyByTimeDetail().then((value) {
            mReport = [];
            mReportDisplayData = [];
            mReport.addAll(value);
            mReportDisplayData = mReport;
            getData.value = false;
            //  clearText();
          });
        } else {
          byPerson.value = false;
          fetchMontlyByTime().then((value) {
            daily = [];
            dailyDisplayData = [];
            daily.addAll(value);
            dailyDisplayData = daily;
            getData.value = false;
            //  clearText();
          });
        }
      }
    } else {
      Utils().showError(infoNeeded);
    }
  }

  // void clearText() {
  //   // depText.clear();
  //   // empName.clear();

  //   // sdateText.clear();
  //   // edateText.clear();

  //   // selDepartment = null;
  //   // selEmployee = null;
  //   // selBranch = null;
  //   // branch.clear();
  //   // isB.value = true;
  //   // isB.value = false;

  //   depLoading.value = true;
  //   depLoading.value = false;
  //   empLoading.value = true;
  //   empLoading.value = false;
  // }

  static const menuItems = <String>[
    'By time',
    'By date',
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

  Future<void> generateTimeCsv(List<MModel> data) async {
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
            'Count',
            'Time',
            'Dates'
          ],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              "${data[i].surname}, ${data[i].middlename} ${data[i].firstname}",
              data[i].department,
              data[i].branch,
              data[i].count,
              data[i].time,
              data[i].date,
            ]
        ];
        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/Time report (${time.text} on $selectedDate).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export Time report.csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  Future<void> generateMonthCsv(List<MReportModel> data) async {
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
              data[i].staffId,
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
        final path = '$dir/Monthly report ($selectedDate).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export Monthly report.csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  Future<List<EmpListModel>> fetchEmployee(String val) async {
    var products = <EmpListModel>[];
    try {
      var data = {"action": "get_emp", "by": val, "enc_by": val};
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(EmpListModel.fromJson(productJson));
        }
      } else {
        Utils().showError('No employee found');
      }
      return products;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      Utils().showError(noInternet);
      return products;
    }
  }

  Future<List<MReportModel>> fetchMontlyByDate() async {
    var permission = <MReportModel>[];
    try {
      var data = {
        "action": "by_date",
        "sdate": sdateText.text,
        "edate": edateText.text,
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
      };
      var result = await Query.queryData(data);

      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(MReportModel.fromMap(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<MReportModel>> fetchMontlyByTimeDetail() async {
    var permission = <MReportModel>[];
    try {
      var data = {
        "action": "by_time",
        "sdate": sdateText.text,
        "time": time.text,
        "period": inTime.value == true ? "1" : "2",
        "edate": edateText.text,
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
        "report": reportType.text
      };

      var result = await Query.queryData(data);
      var empJson = json.decode(result);
     print(data);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(MReportModel.fromMap(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<MModel>> fetchMontlyByTime() async {
    var permission = <MModel>[];
    try {
      var data = {
        "action": "by_time",
        "sdate": sdateText.text,
        "time": time.text,
        "period": inTime.value == true ? "1" : "2",
        "edate": edateText.text,
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "department": depText.text,
        "staff_id": empName.text,
        "report": reportType.text
      };

      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(MModel.fromMap(empJson));
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

import 'dart:convert';
import 'dart:io';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/model.dart';
import '../../../branches/component/controller/controller.dart';
import '../../../department/component/controller/controller.dart';
import '../../../employee/component/controller.dart';
import '../../../employee/component/models/emp_models.dart';
import '../model/overtime_model.dart';

final dep = Get.put(DepartmentCon());
final emp = Get.find<EmployeeCon>();
final b = Get.find<BranchesCon>();

class OvertimeCon extends GetxController {
  final formKey = GlobalKey<FormState>();

  List<OvertimeModel> overTime = <OvertimeModel>[];
  List<OvertimeModel> overTimeDisplayData = <OvertimeModel>[].obs;

  List<EmpListModel> employee = <EmpListModel>[];
  List<EmpListModel> employeeRecords = <EmpListModel>[].obs;

  final sdateText = TextEditingController();
  final edateText = TextEditingController();
  final depText = TextEditingController();
  final DateTime now = DateTime.now();
  final empNametext = TextEditingController();
  final time = TextEditingController();
  final empName = TextEditingController();

  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;

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
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String selectedDate = "";
  @override
  void onInit() {
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    getBranches();
    super.onInit();
  }

  void getByDate() {
    if (depText.text.isNotEmpty ||
        empNametext.text.isNotEmpty ||
        sdateText.text.isNotEmpty ||
        edateText.text.isNotEmpty) {
      byPerson.value = true;
      getData.value = true;
      fetchOvertime().then((value) {
        overTime = [];
        overTimeDisplayData = [];
        overTime.addAll(value);
        overTimeDisplayData = overTime;
        getData.value = false;
       // clearText();
      });
    } else {
      Utils().showError(infoNeeded);
    }
  }

  // void clearText() {
  //   depText.clear();
  //   empNametext.clear();
  //   setDate1.value = false;
  //   setDate2.value = false;
  // }

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

  Future<void> generateCsv(List<dynamic> data) async {
    if (data.isEmpty) {
      Utils().showError("There are no record to export");
    } else {
      try {
        List<List<dynamic>> csvData = [
          <String>[
            'Staff ID',
            'Name',
            'Department',
            'Branch',
            'Total Seconds',
            'Time',
          ],
          ...overTimeDisplayData.map((data) => [
                data.staffId,
                "${data.surname}, ${data.middlename} ${data.firstname}",
                data.department,
                data.branch,
                data.totalSeconds!,
                Utils.isNumeric(data.totalSeconds!)
                    ? Utils.convertTime(int.parse(data.totalSeconds!))
                    : data.totalSeconds!
              ])
        ];
        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/Overtime ($selectedDate).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export Overtime ($selectedDate).csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  Future<List<OvertimeModel>> fetchOvertime() async {
    var permission = <OvertimeModel>[];
    try {
      var data = {
        "action": "overtime",
        "sdate": sdateText.text,
        "edate": edateText.text,
        "department": depText.text,
        "staff_id": empName.text,
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(OvertimeModel.fromMap(empJson));
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

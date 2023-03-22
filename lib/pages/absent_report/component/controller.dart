import 'dart:convert';
import 'dart:io';
import 'model.dart';
import '../../department/component/controller/controller.dart';
import '../../employee/component/controller.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/model.dart';
import '../../branches/component/controller/controller.dart';

final emp = Get.put(EmployeeCon());
final dep = Get.put(DepartmentCon());
final b = Get.find<BranchesCon>();

class AbsentReportCon extends GetxController {
  List<AbRecordModel> data = <AbRecordModel>[];
  List<AbRecordModel> dataList = <AbRecordModel>[];
  final sdateText = TextEditingController();
  final edateText = TextEditingController();
  final depText = TextEditingController();
  final empName = TextEditingController();
  final branch = TextEditingController();
  DateTime sDate = DateTime.now();
  final sDateText = TextEditingController();
  final eDateText = TextEditingController();
  DateTime eDate = DateTime.now();
  final empNametext = TextEditingController();
  DateTime today = DateTime.parse("2021-01-08");
  var loadData = false.obs;
  final DateTime now = DateTime.parse("2021-12-08");
  var depLoad = false.obs;
  var empLoad = false.obs;
  final reason = TextEditingController();
  var loading = false.obs;
  List types = ['', 'Leave', 'Off day', 'Sick', 'Emergency', 'Other'];
  final typeText = TextEditingController();
  var permDate = [].obs;
  var setDate = false.obs;
  var getData = false.obs;
  var isB = false.obs;
  var selectedDate = '';
  var typeSelected = ''.obs;
  var depLoading = false.obs;
  var empLoading = false.obs;
  var isOther = false.obs;
  var isAbsent = false.obs;
  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  List<String> eList = [];
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;
  List<String> selEList = [];

  final formKey = GlobalKey<FormState>();
  String dailyDate = '';

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() {
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    reload();
    super.onInit();
  }

  reload() {
    getBranches();
    clearText();
  }

  clearText() {
    selDepartment = null;
    selBranch = null;
    selEmployee = null;
    branch.clear();
    depText.clear();
    empNametext.clear();
    isB.value = true;
    isB.value = false;
    depLoading.value = true;
    depLoading.value = false;
    empLoading.value = true;
    empLoading.value = false;
    setDate.value = false;
    getData.value = false;
  }

  void setSelected(String value) {
    typeSelected.value = value;
    typeText.text = value;
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

  String sortDate(String date) {
    String newList = '';
    try {
      List<String> list = date.split(',');
      list.sort(((a, b) => a.compareTo(b)));
      newList = list.join(',');
      return newList;
    } catch (e) {
      print.call(e);
      return newList;
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

  savePermission(String id, String date) async {
    try {
      var data = {
        "action": "savePerm",
        "staff_id": id,
        "sdate": date,
        "days": '1',
        "hour": '9',
        "type": typeText.text,
        "reason": reason.text,
        // "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "cid": Utils.cid
      };
      var val = await Query.queryData(data);
      if (jsonDecode(val) == 'true') {
        permDate.add('$id-$date');
        Utils().showInfo(saved);
        // Get.back();
      } else {
        Utils().showError(notSaved);
      }
    } catch (e) {
      print.call(e);
    }
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

  void getAttendance() {
    getData.value = true;
    if (depText.text.isNotEmpty ||
        empNametext.text.isNotEmpty ||
        sdateText.text.isNotEmpty ||
        edateText.text.isNotEmpty) {
      fetchData().then((value) {
        data = [];
        dataList = [];
        data.addAll(value);
        dataList = data;
        getData.value = false;
        clearText();
      });
    } else {
      Utils().showError(infoNeeded);
    }
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

  Future<void> generateCsv(List<AbRecordModel> data) async {
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
            'Absebt Days',
            'Permission',
            'Dates'
          ],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              "${data[i].surname}, ${data[i].middlename} ${data[i].firstname}",
              data[i].department,
              data[i].branch,
              data[i].abDays,
              data[i].permission,
              data[i].dates,
            ]
        ];
        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/Absent report ($selectedDate).csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export Absent report ($selectedDate).csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  Future<List<AbRecordModel>> fetchData() async {
    var permission = <AbRecordModel>[];
    try {
      var data = {
        "action": "absent_report",
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
          permission.add(AbRecordModel.fromMap(empJson));
        }
      }

      return permission;
    } catch (e) {
      getData.value = false;
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }
}

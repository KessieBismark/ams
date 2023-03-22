import 'dart:convert';
import 'package:ams/pages/branches/component/controller/controller.dart';
import 'package:ams/pages/employee/component/controller.dart';
import 'package:ams/services/utils/helpers.dart';
import 'package:ams/services/utils/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/model.dart';
import '../../absentee/component/controller/controller.dart';
import '../../absentee/component/model/absentee_model.dart';
import '../../department/component/controller/controller.dart';
import 'model/per_model.dart';

final dep = Get.find<DepartmentCon>();
final b = Get.find<BranchesCon>();
final emp = Get.find<EmployeeCon>();
final ab = Get.find<AbsenteeCon>();

class PermissionCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<PermissionModel> per = <PermissionModel>[];
  List<PermissionModel> perDisplayData = <PermissionModel>[].obs;
  List<AbsentModel> absent = <AbsentModel>[];
  List<AbsentModel> absentDisplayData = <AbsentModel>[];
  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  List<DropDownModel> eList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  List<DropDownModel> empList = [];
  bool tableSelect = false;
  DropDownModel? selEmployee;
  List<String> selEList = [];
  List types = [
    '',
    'Leave',
    'Sick Leave',
    'Off day',
    'Sick',
    'Emergency',
    'Other'
  ];
  List<DropDownModel> eListSelected = [];
  final empName = TextEditingController();
  final depText = TextEditingController();
  final sDateText = TextEditingController();
  final eDateText = TextEditingController();
  final typeText = TextEditingController();
  final reason = TextEditingController();
  DateTime sDate = DateTime.now();
  DateTime eDate = DateTime.now();
  String sel = '';
  final DateTime now = DateTime.parse("2021-12-08");
  DateTime idate = DateTime.parse("1950-01-01");
  String deleteID = '';
  var selectedDate = '';
  var setDate = false.obs;
  var typeSelected = ''.obs;
  var deleting = false.obs;
  var depLoading = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var searchAbsent = false.obs;
  var loading = false.obs;
  var searchData = false.obs;
  var isOther = false.obs;
  var isAbsent = false.obs;
  var isSave = false.obs;
  int weekHours = 0;
  int weekendHours = 0;
  var isB = false.obs;
  var isSearch = false.obs;
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String rdate = '';
  var isChecked = [].obs;
  final dateText = TextEditingController();
  DateTime today = DateTime.now();

  @override
  void onInit() async {
    super.onInit();
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    reload();
  }

  reload() {
    //  getPermission();
    getBranches();
  }

  void getPermission() {
    getData.value = true;
    fetchPermission().then((value) {
      per = [];
      perDisplayData = [];
      per.addAll(value);
      perDisplayData = per;
      searchData.value = true;
      isAbsent.value = false;
      getData.value = false;
    });
  }

  void search() async {
    if (branch.text.isNotEmpty &&
        depText.text.isNotEmpty &&
        empName.text.isNotEmpty) {
      getData.value = true;
      fetchSearch(branch.text, depText.text, empName.text).then((value) {
        per = [];
        perDisplayData = [];
        per.addAll(value);
        perDisplayData = per;
        getData.value = false;
        searchData.value = true;
        isAbsent.value = false;
      });
    } else {
      Utils().showError("All entries are required");
    }
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

  void getAbsent(String branch) {
    getData.value = true;
    if (depText.text.isNotEmpty ||
        empName.text.isNotEmpty ||
        dateText.text.isNotEmpty) {
      ab
          .fetchAbsentAtendance(
              branch, depText.text, dateText.text, empName.text)
          .then((value) {
        absent = [];
        absentDisplayData = [];
        absent.addAll(value);
        absentDisplayData = absent;
        getData.value = false;
        searchData.value = true;
        isAbsent.value = true;
      });
    } else {
      Utils().showError(noInternet);
    }
  }

  static const menuItems = <String>[
    'Add New',
    'Search',
    'Search Absent',
    'Reload',
    'Print'
  ];
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

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

  // void addSelectedID() {
  //   try {
  //     selEList = [];
  //     for (var selected in eListSelected) {
  //       for (var map in employeesList) {
  //         if (map.name == selected) {
  //           selEList.add(map.id);
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     Utils().showError(e.toString());
  //   }
  // }

  void getEmployees(String branch, String dep) {
    empLoading.value = true;
    emp.fetchEmployeeByDepBranch(branch, dep).then(
      (value) {
        emp.employee = [];
        employeesList = [];
        emp.employee.addAll(value);
        eList = [];
        empList = [];
        empList.add(DropDownModel(id: '0', name: 'All'));
        employeesList.add(DropDownModel(id: '0', name: 'All'));

        for (int i = 0; i < emp.employee.length; i++) {
          employeesList.add(DropDownModel(
              id: emp.employee[i].staffID.toString(),
              name:
                  "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}"));
          empList.add(DropDownModel(
              id: emp.employee[i].staffID.toString(),
              name:
                  "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}"));
          eList.add(DropDownModel(
              id: emp.employee[i].staffID.toString(),
              name:
                  "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}"));
        }
        empLoading.value = false;
      },
    );
  }

  void setSelected(String value) {
    typeSelected.value = value;
    typeText.text = value;
  }

  clearTexts() {
    depText.clear();
    empName.clear();
    typeText.clear();
    sDateText.clear();
    eDateText.clear();
    selBranch = null;
    reason.clear();
    eListSelected = [];
    selEList = [];
    selDepartment = null;
    selEmployee = null;
    loading.value = false;
    setDate.value = false;
    depLoading.value = true;
    depLoading.value = false;
    empLoading.value = true;
    empLoading.value = false;
    typeSelected.value = '';
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

  Future<bool> getDuration(String dep, String branch) async {
    bool result;
    try {
      print("started");
      var data = {
        "action": "get_duration",
        "department": dep,
        "branch": Utils.branchID == '0' ? branch : Utils.branchID,
        "cid": Utils.cid
      };
      var res = await Query.queryData(data);
      print(res);
      var val = json.decode(res);
      DateTime wkdH, wknH;
      wkdH = DateFormat("hh:mm:ss").parse(val[0]['weekHour']);
      wknH = DateFormat("hh:mm:ss").parse(val[0]['wknH']);
      weekHours = wkdH.hour;
      weekendHours = wknH.hour;
      result = true;
      return result;
    } catch (e) {
      print.call(e);
      return false;
    }
  }

  void insert() async {
    isChecked.value = [];
    for (int i = 0; i < eListSelected.length; i++) {
      isChecked.add(eListSelected[i].id);
    }
    if (isChecked.isNotEmpty) {
      if (formKey.currentState!.validate()) {
        if (depText.text.isEmpty ||
            // empName.text.isEmpty ||
            sDateText.text.isEmpty ||
            eDateText.text.isEmpty ||
            typeText.text.isEmpty) {
          Utils().showError("All fields are required");
        } else {
          loading.value = true;

          try {
            int? hour, days;
            getDuration(depText.text, branch.text).then((value) async {
              if (value) {
                hour = Utils.hoursDifference(
                    sDate, eDate, weekHours, weekendHours);
                days = Utils.daysDifference(sDate, eDate);

                var data = {
                  "action": "insert_permissions",
                  "dep": depText.text,
                  "empName": isChecked.join(','),
                  "sdate": sDate.toString(),
                  "edate": eDate.toString(),
                  "days": days.toString(),
                  "hour": hour.toString(),
                  "type": typeText.text,
                  "reason": reason.text,
                  "branch":
                      Utils.branchID == '0' ? branch.text : Utils.branchID,
                  "cid": Utils.cid
                };
                print.call(data);
                var val = await Query.queryData(data);
                if (jsonDecode(val) == 'true') {
                  loading.value = false;
                  reload();
                  clearTexts();
                  Utils().showInfo(saved);
                } else {
                  Utils().showError(notSaved);
                  loading.value = false;
                }
              } else {
                loading.value = false;
                Utils().showError(noInternet);
                return;
              }
            });
            loading.value = false;
          } catch (e) {
            loading.value = false;
            print.call(e);
            Utils().showError(e.toString());
          }
        }
      }
    } else {
      Utils().showError(
          "Could not retrieve any staff Id, make sure to select at least one staff name");
    }
  }

  void insertPerm() async {
    // addSelectedID();
    if (isChecked.isNotEmpty) {
      if (formKey.currentState!.validate()) {
        if (
            //depText.text.isEmpty ||
            //   empName.text.isEmpty ||
            sDateText.text.isEmpty ||
                eDateText.text.isEmpty ||
                typeText.text.isEmpty) {
          Utils().showError("All fields are required");
        } else {
          loading.value = true;

          try {
            int? hour, days;
            getDuration(depText.text, branch.text).then((value) async {
              if (value) {
                hour = Utils.hoursDifference(
                    sDate, eDate, weekHours, weekendHours);
                days = Utils.daysDifference(sDate, eDate);
                var data = {
                  "action": "insert_perm",
                  "dep": depText.text,
                  "empName": isChecked.join(','),
                  "sdate": sDate.toString(),
                  "edate": eDate.toString(),
                  "days": days.toString(),
                  "hour": hour.toString(),
                  "type": typeText.text,
                  "reason": reason.text,
                  "branch":
                      Utils.branchID == '0' ? branch.text : Utils.branchID,
                  "cid": Utils.cid
                };
                print.call(data);
                var val = await Query.queryData(data);
                if (jsonDecode(val) == 'true') {
                  loading.value = false;
                  reload();
                  clearTexts();
                  Utils().showInfo(saved);
                } else {
                  Utils().showError(notSaved);
                  loading.value = false;
                }
              } else {
                loading.value = false;
                Utils().showError(noInternet);
                return;
              }
            });
            loading.value = false;
          } catch (e) {
            loading.value = false;
            print.call(e);
            Utils().showError(e.toString());
          }
        }
      }
    } else {
      Utils().showError(
          "Could not retrieve any staff Id, make sure to select at least one staff name");
    }
  }

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        deleting.value = true;
        var data = {"action": "delete_permissions", "id": id, "cid": Utils.cid};
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

  Future<List<PermissionModel>> fetchPermission() async {
    var permission = <PermissionModel>[];
    try {
      var data = {
        "action": "view_permissions",
        "cid": Utils.cid,
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(PermissionModel.fromMap(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<PermissionModel>> fetchSearch(
      String branch, String dep, String staff) async {
    var permission = <PermissionModel>[];
    try {
      var data = {
        "action": "search_permission",
        "branch": Utils.branchID == '0' ? branch : Utils.branchID,
        "cid": Utils.cid,
        "department": dep,
        "staff_id": staff,
        "sdate": sDate.toString(),
        "edate": eDate.toString(),
      };
      print(data);
      var result = await Query.queryData(data);
      print(result);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(PermissionModel.fromMap(empJson));
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

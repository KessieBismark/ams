import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/model.dart';
import '../../../../services/utils/query.dart';
import '../../../branches/component/controller/controller.dart';
import '../../../department/component/controller/controller.dart';
import '../../../employee/component/controller.dart';
import '../../../employee/component/models/emp_models.dart';
import '../model/salary_model.dart';

final dep = Get.put(DepartmentCon());
final emp = Get.find<EmployeeCon>();
final b = Get.find<BranchesCon>();

class SalaryCon extends GetxController {
  List<SalaryModel> sal = <SalaryModel>[];
  List<SalaryModel> salary = <SalaryModel>[].obs;
  List<EmpListModel> employee = <EmpListModel>[];
  final formKey = GlobalKey<FormState>();
  final depText = TextEditingController();
  final name = TextEditingController();
  final amount = TextEditingController();
  final group = TextEditingController();

  List<String> salaryGroup = [];
  List<String> selectedGroup = [];

  DropDownModel? selBranch;
  DropDownModel? selDepartment;
  List<DropDownModel> bList = [];
  List<DropDownModel> departmentList = [];
  List<String> eList = [];
  final branch = TextEditingController();
  List<DropDownModel> employeesList = [];
  DropDownModel? selEmployee;
  List<String> selEList = [];
  List<String> eListSelected = [];
  final empName = TextEditingController();
  String deleteID = '';
  var deleting = false.obs;
  var depLoading = false.obs;
  var empLoading = false.obs;
  var getData = false.obs;
  var loading = false.obs;
  var isB = false.obs;
  var isGroup = false.obs;

  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);

    reload();
  }

  reload() {
    getBranches();
    getSalary();
    clearTexts();
  }

  void addSelectedID() {
    try {
      selEList = [];
      for (var selected in eListSelected) {
        for (var map in employeesList) {
          if (map.name == selected) {
            selEList.add(map.id);
          }
        }
      }
    } catch (e) {
      print(e);
      Utils().showError(e.toString());
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
      eList = [];
      for (int i = 0; i < emp.employee.length; i++) {
        employeesList.add(DropDownModel(
            id: emp.employee[i].staffID.toString(),
            name:
                "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}"));
        eList.add(
            "${emp.employee[i].surname}, ${emp.employee[i].middlename} ${emp.employee[i].firstname}");
      }
      empLoading.value = false;
    });
  }

  static const menuItems = <String>[
    'Add Structure',
    'Reload',
  ];
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  clearTexts() {
    name.clear();
    amount.clear();
    group.clear();
    selectedGroup = [];
  }

  void getSalary() {
    getData.value = true;
    fetchSalaryStructure().then((value) {
      sal = [];
      salary = [];
      sal.addAll(value);
      salary = sal;

      getData.value = false;
    });
  }

  void insert() async {
    if (formKey.currentState!.validate()) {
      if (amount.text.isEmpty || name.text.isEmpty || selectedGroup.isEmpty) {
        Utils().showError("All fields are required");
      } else if (!Utils.isNumeric(amount.text)) {
        Utils().showError(numberOnly);
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "insert_permissions",
            "name": name.text,
            "amount": amount.text,
            "empName": selEList.join(','),
            "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
            "cid": Utils.cid
          };
          print.call(data);
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            reload();
            clearTexts();
          } else {
            loading.value = false;
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          Utils().showError(noInternet);
        }
      }
    }
  }

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        deleting.value = true;
        var data = {"action": "delete_per", "id": id};
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

  Future<List<SalaryModel>> fetchSalaryStructure() async {
    var permission = <SalaryModel>[];
    try {
      var data = {
        "action": "view_salary",
        "branch": Utils.branchID == '0' ? branch.text : Utils.branchID,
        "cid": Utils.cid
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(SalaryModel.fromJson(empJson));
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

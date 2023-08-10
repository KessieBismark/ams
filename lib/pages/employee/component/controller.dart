import 'dart:convert';
import 'dart:io';

import '../../branches/component/controller/controller.dart';
import '../../department/component/controller/controller.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/model.dart';
import 'models/emp_models.dart';

final dep = Get.find<DepartmentCon>();
final b = Get.find<BranchesCon>();

class EmployeeCon extends GetxController {
  static const menuItems = <String>[
    'Add New',
    'Sync',
    'Enroll fingerprint',
    'Refresh',
    // 'Print',
    'Export',
  ];

  final accountText = TextEditingController();
  final bool active = true;
  final bankText = TextEditingController();
  DropDownModel? selBranch;
  List<DropDownModel> bList = [];
  final branch = TextEditingController();
  final contactTExt = TextEditingController();
  String? deleteID;
  var depLoad = false.obs;
  final depText = TextEditingController();
  DropDownModel? selDepartment;
  List<DropDownModel> departmentList = [];
  final dobText = TextEditingController();
  final eContactTExt = TextEditingController();
  List<EmpListModel> employee = <EmpListModel>[];
  List<EmpListModel> employeeRecords = <EmpListModel>[];
  final Uri enroll = Uri.file(
      r'C:\Program Files (x86)\BISTECH GHANA\AMS FLUTTER\register.exe',
      windows: true);

  final firstNameText = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? fullname;
  List gen = ['Select Gender', 'Male', 'Female'];
  var genSelected = 'Select Gender'.obs;
  final genderText = TextEditingController();
  var getData = false.obs;
  final hDateText = TextEditingController();
  final hoursText = TextEditingController();
  String id = '';
  DateTime iDate = DateTime.now();
  DateTime idate = DateTime.parse("1950-01-01");
  var input = false.obs;
  var isDOB = false.obs;
  var isDelete = false.obs;
  var isHire = false.obs;
  var isResign = false.obs;
  var isSave = false.obs;
  var isUpdate = false.obs;
  var isAuto = false.obs;
  var loadData = false.obs;
  final middleNameText = TextEditingController();
  var on = true.obs; // our observable
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final residenceText = TextEditingController();
  DateTime resigned = DateTime.parse("2059-12-30");
  final resignedText = TextEditingController();
  DateTime selectedDob = DateTime.now();
  DateTime selectedHiredDate = DateTime.now();
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  final ssnitText = TextEditingController();
  final staffIDText = TextEditingController();
  final surNameText = TextEditingController();
  final Uri sync = Uri.file(
      r'C:\Program Files (x86)\BISTECH GHANA\AMS FLUTTER\sync_device.exe',
      windows: true);

  var updateEmployee = false.obs;
  var isB = false.obs;

  @override
  void onInit() {
    selectedHiredDate = DateTime.now();
    hDateText.text = DateTime.now().toString();
    resigned = DateTime.parse('9994-01-01');
    isHire.value = true;
    isResign.value = true;

    reload();
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    super.onInit();
  }

  reload() {
    getEmployee();
    getBranches();
    clearText();
    getMaxId();
  }

  void getEmployee() {
    getData.value = true;
    fetchEmployee().then((value) {
      employee = [];
      employeeRecords = [];
      employee.addAll(value);
      employeeRecords = employee;
      getData.value = false;
    });
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
    depLoad.value = true;
    dep.fetchDepartmentByBranch(branch).then((value) {
      dep.dep = [];
      dep.dep.addAll(value);
      departmentList = [];
      for (int i = 0; i < dep.dep.length; i++) {
        departmentList.add(
            DropDownModel(id: dep.dep[i].id.toString(), name: dep.dep[i].name));
      }
      depLoad.value = false;
    });
  }

  void clearText() {
    staffIDText.clear();
    surNameText.clear();
    middleNameText.clear();
    firstNameText.clear();
    ssnitText.clear();
    accountText.clear();
    hoursText.clear();
    depText.clear();
    dobText.clear();
    genderText.clear();
    hDateText.clear();
    residenceText.clear();
    eContactTExt.clear();
    contactTExt.clear();
    selectedHiredDate = DateTime.now();
    hDateText.text = DateTime.now().toString();

    resigned = DateTime.parse('9994-01-01');
    isHire.value = true;
    isResign.value = true;
  }

  Future<void> generateCsv(List<EmpListModel> data) async {
    if (data.isEmpty) {
      Utils().showError("There are no record to export");
    } else {
      try {
        List<List<dynamic>> csvData = [
          <String>[
            'Staff ID',
            'Surname',
            'Middle Name',
            'First Name',
            'Department',
            'Gender',
            'Ssnit #',
            'Bank',
            'Account #',
            'Working Hours',
            'DOB',
            'Contact',
            'Emergency Contact',
            'Hired Date',
            'Residence',
            'Resigned',
            'Registered Finger(s)',
            'Branch',
            'Active',
            'Branch'
          ],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              data[i].surname,
              data[i].middlename,
              data[i].firstname,
              data[i].department,
              data[i].gender,
              data[i].ssnit,
              data[i].bank,
              data[i].accountNo,
              data[i].hour,
              data[i].dob,
              data[i].contact,
              data[i].eContact,
              data[i].hiredDate,
              data[i].residence,
              data[i].resigned,
              data[i].finger,
              data[i].active,
              data[i].branch
            ]
        ];

        String csv = const ListToCsvConverter().convert(csvData);
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final path = '$dir/employee.csv';
        final File file = File(path);
        await file.writeAsString(csv);
        Utils().showInfo("$export employee.csv");
      } catch (e) {
        Utils().showError(exportError);
      }
    }
  }

  void toggle() => on.value = on.value ? false : true;

  void setSelected(String value) {
    genSelected.value = value;
    genderText.text = value;
  }

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        isDelete.value = true;
        var data = {"action": "delete_employee", "id": id};
        var val = await Query.queryData(data);
        if (jsonDecode(val) == 'true') {
          reload();
          isDelete.value = false;
        } else if (jsonDecode(val) == 'false') {
          isDelete.value = false;
          Utils().showError("Something went wrong, could not delete record");
        } else {
          isDelete.value = false;
          Utils().showError("Something went wrong, could not delete record");
        }
      } catch (e) {
        isDelete.value = false;
        print.call(e);
        Utils().showError(noInternet);
      }
    }
  }

  void updateEmployInput() async {
    if (formKey.currentState!.validate()) {
      if (depText.text.isNotEmpty &&
          staffIDText.text.isNotEmpty &&
          surNameText.text.isNotEmpty &&
          firstNameText.text.isNotEmpty) {
        try {
          isUpdate.value = true;
          var data = {
            "action": "update_employee",
            //"id": id,
            "staffID": staffIDText.text,
            "surname": surNameText.text.trim().toUpperCase(),
            "firstname": firstNameText.text.trim().capitalize,
            "middlename": middleNameText.text.trim().capitalize,
            "department": depText.text,
            "ssnit": ssnitText.text.trim(),
            "account": accountText.text.trim(),
            "bank": bankText.text.trim(),
            "hour": hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim(),
            "dob": dobText.text,
            "hdate": hDateText.text,
            "residence": residenceText.text.toUpperCase(),
            "contact": contactTExt.text,
            "econtact": eContactTExt.text,
            "gender": genderText.text,
            "active": on.value ? "1" : "0",
            "resigned": resignedText.text,
            "cid": Utils.cid,
            "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            isUpdate.value = false;
            clearText();
            reload();
          } else if (jsonDecode(val) == 'false') {
            isUpdate.value = false;
            Utils().showError(notSaved);
          } else {
            isUpdate.value = false;
            Utils().showError(
                "Data could not be saved. Check internet connection");
          }
        } catch (e) {
          isUpdate.value = false;
          print.call(e);
        }
      } else {
        Utils().showError("Staff ID, Name, Shop cannot be empty!");
      }
    }
  }

  void insert() async {
    if (formKey.currentState!.validate()) {
      if (depText.text.isNotEmpty &&
          staffIDText.text.isNotEmpty &&
          surNameText.text.isNotEmpty &&
          firstNameText.text.isNotEmpty) {
        try {
          isSave.value = true;
          var data = {
            "action": "add_employee",
            "staffID": staffIDText.text,
            "surname": surNameText.text.trim().toUpperCase(),
            "firstname": firstNameText.text.trim().capitalize,
            "middlename": middleNameText.text.trim().capitalize,
            "department": depText.text,
            "ssnit": ssnitText.text.trim(),
            "account": accountText.text.trim(),
            "bank": bankText.text.trim(),
            "hour": hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim(),
            "dob": dobText.text,
            "hdate": hDateText.text,
            "residence": residenceText.text.toUpperCase(),
            "contact": contactTExt.text,
            "econtact": eContactTExt.text,
            "gender": genderText.text,
            "active": on.value ? "1" : "0",
            "resigned": resignedText.text,
            "cid": Utils.cid,
            "branch": Utils.branchID == '0' ? branch.text : Utils.branchID
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            isSave.value = false;
            clearText();
            reload();
            Utils().showInfo("Data was saved successfully");
          } else if (jsonDecode(val) == 'false') {
            isSave.value = false;
            Utils().showError(notSaved);
          } else {
            isSave.value = false;
            Utils().showError(
                "Data could not be saved. Check internet connection");
          }
        } catch (e) {
          isSave.value = false;
          print.call(e);
        }
      } else {
        Utils().showError("Staff ID, Name, Shop cannot be empty!");
      }
    }
  }

  getMaxId() async {
    try {
      var data = {"action": "get_max_id", "cid": Utils.cid};
      var val = await Query.queryData(data);
      var res = jsonDecode(val);
      if (res != 'false') {
        staffIDText.text = res[0]['id'].toString();
        isAuto.value = true;
      } else {
        Utils().showError(
            'Something went wrong please check your internet connection');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<List<EmpListModel>> fetchEmployee() async {
    var employee = <EmpListModel>[];
    try {
      var data = {
        "action": "emp_list",
        "cid": Utils.cid,
        "branch": Utils.branchID
      };
      var result = await Query.queryData(data);
      var empJson = jsonDecode(result);
      if (empJson != 'false') {
        for (var empJson in empJson) {
          employee.add(EmpListModel.fromJson(empJson));
        }
      }
      return employee;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return employee;
    }
  }

  Future<List<EmpListModel>> fetchEmployeeByDepBranch(
      String branch, String dep) async {
    var employee = <EmpListModel>[];
    try {
      var data = {
        "action": "emp_list_by_parm",
        "cid": Utils.cid,
        "department": dep,
        "branch": Utils.branchID == '0' ? branch : Utils.branchID
      };
      var result = await Query.queryData(data);
      var empJson = jsonDecode(result);
      if (empJson != 'false') {
        for (var empJson in empJson) {
          employee.add(EmpListModel.fromJson(empJson));
        }
      }
      return employee;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return employee;
    }
  }
}

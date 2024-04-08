import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ams/pages/employee/component/profile.dart';
import 'package:ams/services/constants/server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:time/time.dart';
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
import '../../permission/component/model/per_model.dart';
import '../../position/component/controller/controller.dart';
import 'models/emp_models.dart';

final dep = Get.find<DepartmentCon>();
final b = Get.find<BranchesCon>();
final p = Get.find<PositionCon>();
String baseString =
    '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';

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
  final eNameTExt = TextEditingController();
  final nidExt = TextEditingController();
  final emailExt = TextEditingController();
  DropDownModel? selDepartment;
  List<DropDownModel> departmentList = [];
  final dobText = TextEditingController();
  final eContactTExt = TextEditingController();
  List<EmpListModel> employee = <EmpListModel>[];
  List<EmpListModel> employeeRecords = <EmpListModel>[];
  final Uri enroll = Uri.file(
      r'C:\Program Files (x86)\BISTECH GHANA\AMS FLUTTER\register.exe',
      windows: true);
  List<DropDownModel> positionList = [];
  DropDownModel? selPosition;
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
    List<PermissionModel> per = <PermissionModel>[];
  var pLoad = false.obs;
  var cDraw = false.obs;
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
  List<ChartData> cData = [];

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
  var imageUrl = ''.obs;
  var imageName = '';
  var isImg = false.obs;
  Uint8List imgBytes = base64Decode(baseString);
  var imgSet = false.obs;

  @override
  void onInit() {
    selectedHiredDate = DateTime.now();
    hDateText.text = DateTime.now().toString();
    resigned = DateTime.parse('9994-01-01');
    isHire.value = true;
    isResign.value = true;
    resignedText.text = "2079-12-12";
    reload();
    Utils.branchID == '0' ? null : getDepartment(Utils.branchID);
    super.onInit();
  }

  reload() {
    getEmployee();
    getBranches();
    clearText();
    getMaxId();
    getPosition();
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

  getPosition() {
    depLoad.value = true;
    p.fetchServiceCategory().then((value) {
      p.b = [];
      p.b.addAll(value);
      positionList = [];
      for (int i = 0; i < p.b.length; i++) {
        positionList
            .add(DropDownModel(id: p.b[i].id.toString(), name: p.b[i].name));
      }
      depLoad.value = false;
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

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);

        String fileName = result.files.first.name;
        Uint8List fileBytes = file.readAsBytesSync();

        imgBytes = fileBytes;
        imageUrl.value = fileName;
        imageName = fileName;
        isImg.value = true;
        isImg.value = false;

        // Your logic to use the selected file
      } else {
        // User canceled the file picking
      }
    } catch (e) {
      print("File picking error: $e");
    }
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
    selPosition = DropDownModel(id: "", name: "");
    selDepartment = DropDownModel(id: "", name: "");
    selBranch = DropDownModel(id: "", name: "");
    resigned = DateTime.parse('9994-01-01');
    isHire.value = true;
    isResign.value = true;
    isSave.value = false;
    loadData.value = false;
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
            'Email',
            'National ID',
            'Position',
            'Branch',
            'Gender',
            'Ssnit #',
            'Bank',
            'Account #',
            'Working Hours',
            'DOB',
            'Contact',
            'Emergency Person',
            'Emergency Contact',
            'Hired Date',
            'Residence',
            'Resigned',
            'Registered Finger(s)',
            'Branch',
            'Active',
          ],
          for (int i = 0; i < data.length; i++)
            [
              data[i].staffID,
              data[i].surname,
              data[i].middlename,
              data[i].firstname,
              data[i].email,
              data[i].nid,
              data[i].position,
              data[i].branch,
              data[i].gender,
              data[i].ssnit,
              data[i].bank,
              data[i].accountNo,
              data[i].hour,
              data[i].dob,
              data[i].contact,
              data[i].emergencyName,
              data[i].eContact,
              data[i].hiredDate,
              data[i].residence,
              data[i].resigned,
              data[i].active,
            ]
        ];

        if (GetPlatform.isWeb) {
          String csv = const ListToCsvConverter().convert(csvData);
          //Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
          FlutterFileSaver().writeFileAsString(
              fileName: "employee(${DateTime.now().date}).csv", data: csv);

          Utils().showInfo("employee(${DateTime.now().date}).csv");
        } else {
          String csv = const ListToCsvConverter().convert(csvData);
          final String dir = (await getApplicationDocumentsDirectory()).path;

          final path = '$dir/employee.csv';
          final File file = File(path);
          await file.writeAsString(csv);
          Utils().showInfo("$export employee.csv");
        }
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
      if (staffIDText.text.isNotEmpty &&
          surNameText.text.isNotEmpty &&
          firstNameText.text.isNotEmpty) {
        try {
          isUpdate.value = true;
          // var data = {
          //   "action": "update_employee",
          //   //"id": id,
          //   "staffID": staffIDText.text,
          //   "surname": surNameText.text.trim().toUpperCase(),
          //   "firstname": firstNameText.text.trim().capitalize,
          //   "middlename": middleNameText.text.trim().capitalize,
          //   "department": selDepartment!.id,
          //   "ssnit": ssnitText.text.trim(),
          //   "account": accountText.text.trim(),
          //   "bank": bankText.text.trim(),
          //   "hour": hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim(),
          //   "dob": dobText.text,
          //   "hdate": hDateText.text,
          //   "residence": residenceText.text.toUpperCase(),
          //   "contact": contactTExt.text,
          //   "econtact": eContactTExt.text,
          //   "gender": genderText.text,
          //   "active": on.value ? "1" : "0",
          //   "resigned": DateTime.parse(resignedText.text).isAfter(resigned)
          //       ? resignedText.text
          //       : resigned.toString(),
          //   "cid": Utils.cid,
          //   "branch": Utils.branchID == '0' ? selBranch!.id : Utils.branchID
          // };

          var request = http.MultipartRequest("POST", Uri.parse(Api.url));
          request.fields['staffID'] = staffIDText.text;
          request.fields['action'] = "update_employee";
          request.fields['surname'] = surNameText.text.trim().toUpperCase();
          request.fields['firstname'] = firstNameText.text.trim().capitalize!;
          request.fields['middlename'] = middleNameText.text.trim().capitalize!;
          request.fields['department'] = selDepartment!.id;
          request.fields['ssnit'] = ssnitText.text.trim();
          request.fields['account'] = accountText.text.trim();
          request.fields['bank'] = bankText.text.trim();
          request.fields['hour'] =
              hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim();
          request.fields['dob'] = dobText.text;
          request.fields['hdate'] = hDateText.text;
          request.fields['residence'] = residenceText.text.toUpperCase();
          request.fields['contact'] = contactTExt.text;
          request.fields['econtact'] = eContactTExt.text;
          request.fields['gender'] = genderText.text;
          request.fields['active'] = on.value ? "1" : "0";
          request.fields['resigned'] =
              DateTime.parse(resignedText.text).isAfter(resigned)
                  ? resignedText.text
                  : resigned.toString();
          request.fields['branch'] =
              Utils.branchID == '0' ? selBranch!.id : Utils.branchID;
          request.fields['position'] = selPosition!.id;
          request.fields['email'] = emailExt.text;
          request.fields['emergencyname'] = eNameTExt.text;
          request.fields['nid'] = nidExt.text;
          request.fields['cid'] = Utils.cid;
          // request.fields['branch'] =
          //     Utils.branchID == '0' ? selBranch!.id : Utils.branchID;

          // Compress the image
          final compressedImageBytes =
              await Utils().compressFile(imgBytes, 'image');

          // Add the compressed image to the request
          request.files.add(
            http.MultipartFile.fromBytes(
              "image",
              compressedImageBytes,
              filename: imageName,
            ),
          );
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var val = String.fromCharCodes(responseData);

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

  // void updateEmployInput() async {
  //   if (formKey.currentState!.validate()) {
  //     if (depText.text.isNotEmpty &&
  //         staffIDText.text.isNotEmpty &&
  //         surNameText.text.isNotEmpty &&
  //         firstNameText.text.isNotEmpty) {
  //       try {
  //         isUpdate.value = true;
  //         var data = {
  //           "action": "update_employee",
  //           //"id": id,
  //           "staffID": staffIDText.text,
  //           "surname": surNameText.text.trim().toUpperCase(),
  //           "firstname": firstNameText.text.trim().capitalize,
  //           "middlename": middleNameText.text.trim().capitalize,
  //           "department": selDepartment!.id,
  //           "ssnit": ssnitText.text.trim(),
  //           "account": accountText.text.trim(),
  //           "bank": bankText.text.trim(),
  //           "hour": hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim(),
  //           "dob": dobText.text,
  //           "hdate": hDateText.text,
  //           "residence": residenceText.text.toUpperCase(),
  //           "contact": contactTExt.text,
  //           "econtact": eContactTExt.text,
  //           "gender": genderText.text,
  //           "active": on.value ? "1" : "0",
  //           "resigned": DateTime.parse(resignedText.text).isAfter(resigned)
  //               ? resignedText.text
  //               : resigned.toString(),
  //           "cid": Utils.cid,
  //           "branch": Utils.branchID == '0' ? selBranch!.id : Utils.branchID
  //         };
  //         var val = await Query.queryData(data);
  //         if (jsonDecode(val) == 'true') {
  //           isUpdate.value = false;
  //           clearText();
  //           reload();
  //         } else if (jsonDecode(val) == 'false') {
  //           isUpdate.value = false;
  //           Utils().showError(notSaved);
  //         } else {
  //           isUpdate.value = false;
  //           Utils().showError(
  //               "Data could not be saved. Check internet connection");
  //         }
  //       } catch (e) {
  //         isUpdate.value = false;
  //         print.call(e);
  //       }
  //     } else {
  //       Utils().showError("Staff ID, Name, Shop cannot be empty!");
  //     }
  //   }
  // }

  // void insert() async {
  //   if (formKey.currentState!.validate()) {
  //     if (depText.text.isNotEmpty &&
  //         staffIDText.text.isNotEmpty &&
  //         surNameText.text.isNotEmpty &&
  //         firstNameText.text.isNotEmpty) {
  //       try {
  //         isSave.value = true;
  //         var data = {
  //           "action": "add_employee",
  //           "staffID": staffIDText.text,
  //           "surname": surNameText.text.trim().toUpperCase(),
  //           "firstname": firstNameText.text.trim().capitalize,
  //           "middlename": middleNameText.text.trim().capitalize,
  //           "department": selDepartment!.id, // depText.text,
  //           "ssnit": ssnitText.text.trim(),
  //           "account": accountText.text.trim(),
  //           "bank": bankText.text.trim(),
  //           "hour": hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim(),
  //           "dob": dobText.text,
  //           "hdate": hDateText.text,
  //           "residence": residenceText.text.toUpperCase(),
  //           "contact": contactTExt.text,
  //           "econtact": eContactTExt.text,
  //           "gender": genderText.text,
  //           "active": on.value ? "1" : "0",
  //           "resigned": resignedText.text,
  //           "cid": Utils.cid,
  //           "branch": Utils.branchID == '0' ? selBranch!.id : Utils.branchID
  //         };
  //         var val = await Query.queryData(data);
  //         if (jsonDecode(val) == 'true') {
  //           isSave.value = false;
  //           clearText();
  //           reload();
  //           Utils().showInfo("Data was saved successfully");
  //         } else if (jsonDecode(val) == 'false') {
  //           isSave.value = false;
  //           Utils().showError(notSaved);
  //         } else {
  //           isSave.value = false;
  //           Utils().showError(
  //               "Data could not be saved. Check internet connection");
  //         }
  //       } catch (e) {
  //         isSave.value = false;
  //         print.call(e);
  //       }
  //     } else {
  //       Utils().showError("Staff ID, Name, Shop cannot be empty!");
  //     }
  //   }
  // }

  void insert() async {
    if (formKey.currentState!.validate()) {
      if (staffIDText.text.isNotEmpty &&
          surNameText.text.isNotEmpty &&
          firstNameText.text.isNotEmpty) {
        try {
          isSave.value = true;
          var request = http.MultipartRequest("POST", Uri.parse(Api.url));
          request.fields['staffID'] = staffIDText.text;
          request.fields['action'] = "add_employee";
          request.fields['surname'] = surNameText.text.trim().toUpperCase();
          request.fields['firstname'] = firstNameText.text.trim().capitalize!;
          request.fields['middlename'] = middleNameText.text.trim().capitalize!;
          request.fields['department'] = selDepartment!.id;
          request.fields['ssnit'] = ssnitText.text.trim();
          request.fields['account'] = accountText.text.trim();
          request.fields['bank'] = bankText.text.trim();
          request.fields['hour'] =
              hoursText.text.trim().isEmpty ? '0' : hoursText.text.trim();
          request.fields['dob'] = dobText.text;
          request.fields['hdate'] = hDateText.text;
          request.fields['residence'] = residenceText.text.toUpperCase();
          request.fields['contact'] = contactTExt.text;
          request.fields['econtact'] = eContactTExt.text;
          request.fields['gender'] = genderText.text;
          request.fields['active'] = on.value ? "1" : "0";
          request.fields['resigned'] = resignedText.text;
          request.fields['branch'] =
              Utils.branchID == '0' ? selBranch!.id : Utils.branchID;
          request.fields['position'] = selPosition!.id;
          request.fields['email'] = emailExt.text;
          request.fields['emergencyname'] = eNameTExt.text;
          request.fields['nid'] = nidExt.text;
          request.fields['cid'] = Utils.cid;
          // request.fields['branch'] =
          //     Utils.branchID == '0' ? selBranch!.id : Utils.branchID;

          // Compress the image
          final compressedImageBytes =
              await Utils().compressFile(imgBytes, 'image');

          // Add the compressed image to the request
          request.files.add(
            http.MultipartFile.fromBytes(
              "image",
              compressedImageBytes,
              filename: imageName,
            ),
          );
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var val = String.fromCharCodes(responseData);
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

    int calculateYearDays(int year) {
    int totalDays =
        DateTime(year + 1, 0, 0).difference(DateTime(year, 1, 1)).inDays;
    int totalWorkingDays = 0;

    for (int i = 0; i < totalDays; i++) {
      DateTime date = DateTime(year, 1, 1).add(Duration(days: i));
      if (date.weekday >= DateTime.monday &&
          date.weekday <= DateTime.saturday) {
        totalWorkingDays++;
      }
    }

    return totalWorkingDays;
  }

    int daysPassedInYear() {
    DateTime currentDate = DateTime.now();
    DateTime jan1st = DateTime(DateTime.now().year, 1, 1);
    return currentDate.difference(jan1st).inDays + 1;
  }

    getRadalData(String id) async {
    cDraw.value = true;
    try {
      var data = {"action": "view_profile", "id": id};
      var val = await Query.queryData(data);
      var res = jsonDecode(val);
      if (res != 'false') {
        int hCount = int.parse(res[0]['holiday'].toString());
        int totalWork = daysPassedInYear() - hCount;
        cData.clear();

        cData.add(
            ChartData(x: 'Early', y: int.parse(res[0]['early'].toString())));
        cData
            .add(ChartData(x: 'Late', y: int.parse(res[0]['late'].toString())));
        cData.add(ChartData(
            x: 'Total Attendance',
            y: int.parse(res[0]['attendance'].toString())));
        cData.add(ChartData(x: 'Total Working Days', y: totalWork));
        cDraw.value = false;
      }
      cDraw.value = false;
    } catch (e) {
      cDraw.value = false;
      // ignore: avoid_print
      print(e);
    }
  }

  void search(String staff) async {
    getData.value = true;
    fetchLeave(staff).then((value) {
      per = [];
      per.addAll(value);
      getData.value = false;
    });
    getData.value = false;
    getData.value = false;
  }

  Future<List<PermissionModel>> fetchLeave(String staff) async {
    var permission = <PermissionModel>[];
    try {
      var data = {
        "action": "search_onleave",
        "staff_id": staff,
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(PermissionModel.fromMap(empJson));
        }
      }
      getData.value = false;

      return permission;
    } catch (e) {
      getData.value = false;
      // ignore: avoid_print
      print(e);
      return permission;
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

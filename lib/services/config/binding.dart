import 'package:ams/pages/layout/component/controller/controller.dart';

import '../../pages/absent_report/component/controller.dart';
import '../../pages/absentee/component/controller/controller.dart';
import '../../pages/branches/component/controller/controller.dart';
import '../../pages/daily/component/controller/controller.dart';
import '../../pages/dash/component/controller.dart';
import '../../pages/department/component/controller/controller.dart';
import '../../pages/employee/component/controller.dart';
import '../../pages/holiday/component/controller/controller.dart';
import '../../pages/lunch_break/component/controller/controller.dart';
import '../../pages/monthly/component/controller.dart';
import '../../pages/overtime/component/controller/controller.dart';
import '../../pages/permission/component/controller.dart';
import '../../pages/salary/component/controller/controller.dart';
import 'package:get/get.dart';
import '../../pages/accounts/role/controller/controller.dart';
import '../../pages/accounts/users/component/controllers/users_controller.dart';
import '../../pages/company/component/controller/controller.dart';
import '../../pages/company_info/component/controller/controller.dart';
import '../../pages/login/controllers/login_controller.dart';
import '../../pages/sms/component/controller/controller.dart';

class AMSBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashCon());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AbsentReportCon(), fenix: true);
    Get.lazyPut(() => AbsenteeCon());
    // Get.put( EmployeeCon(), permanent: true);
    // Get.create<EmployeeCon>(() => EmployeeCon());
    Get.lazyPut(() => EmployeeCon(), fenix: true);
    Get.lazyPut(() => DepartmentCon(), fenix: true);
    // Get.create<DepartmentCon>(() => DepartmentCon());
    Get.lazyPut(() => AttendanceCon(), fenix: true);
    Get.lazyPut(() => MonthlyReportCon());
    Get.lazyPut(() => PermissionCon());
    Get.lazyPut(() => OvertimeCon());
    Get.lazyPut(() => SalaryCon());
    Get.lazyPut(() => BranchesCon(), fenix: true);
    //  Get.create<BranchesCon>(() => BranchesCon());
    Get.lazyPut(() => SmsCon());
    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => CompanyCon());
    Get.lazyPut(() => CompanyInfoCon());
    Get.lazyPut(() => RoleController());
    Get.lazyPut(() => HolidayCon());
    Get.lazyPut(() => LunchCon());
  }
}

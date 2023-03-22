import '../../pages/absent_report/absent_report.dart';
import '../../pages/absentee/absentee.dart';
import '../../pages/accounts/users/users.dart';
import '../../pages/daily/daily.dart';
import '../../pages/department/department.dart';
import '../../pages/employee/employee.dart';
import '../../pages/holiday/holiday.dart';
import '../../pages/login/login.dart';
import '../../pages/lunch_break/lunch.dart';
import '../../pages/permission/permission.dart';
import '../../pages/salary/salary.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../pages/accounts/role/role.dart';
import '../../pages/branches/branches.dart';
import '../../pages/company/company.dart';
import '../../pages/company_info/company_info.dart';
import '../../pages/dash/dash.dart';
import '../../pages/employee/component/mobile_emp.dart';
import '../../pages/login/reset.dart';
import '../../pages/login/verify.dart';
import '../../pages/monthly/monthly.dart';
import '../../pages/overtime/overtime.dart';
import '../../pages/sms/sms.dart';
import '../../widgets/main_dash.dart';
import '../menu_controller/menu_controller.dart';
import 'binding.dart';

class Routes {
  static final routes = [
    GetPage(
        name: '/dash',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(panel: Dashboard(), selected: '/dash'),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/accounts',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(panel: Users(), selected: "/accounts"),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/absent_report',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: AbsentReport(),
                selected: "/absent_report",
                name: "Absent Report",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/employee',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Employee(),
                selected: "/employee",
                name: "Employee",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/empInput',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const EmployeeMobileInput(),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/department',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Department(),
                selected: "/department",
                name: "Department",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/absentee',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Absentee(),
                selected: '/absentee',
                name: "Absentee",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/attendance',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Attendance(),
                selected: '/attendance',
                name: "Attendance",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/mreport',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: MonthlyReport(),
                selected: '/mreport',
                name: "Monthly Report",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/permission',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Permission(),
                selected: '/permission',
                name: "Permission",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/sms',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: SMS(),
                selected: '/sms',
                name: "Sms Portal",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/overtime',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: OverTime(),
                selected: '/overtime',
                name: "Overtime Report",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/salary',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Salary(),
                selected: '/salary',
                name: "Salary Structure",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
        name: '/lunch',
        page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MyMenuController(),
                ),
              ],
              child: const Framework(
                panel: Lunch(),
                selected: '/lunch',
                name: "Lunch Break",
              ),
            ),
        binding: AMSBinding()),
    GetPage(
      name: '/branches',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Branches(), selected: '/branches'),
      ),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/holidays',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Holiday(), selected: '/holidays'),
      ),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/company',
      page: () => const Company(),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/reset',
      page: () => const Reset(),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/role',
      page: () => const Role(),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/auth',
      page: () => const Login(),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/verify',
      page: () => const Verify(),
      binding: AMSBinding(),
    ),
    GetPage(
      name: '/cinfo',
      page: () => const CompanyInfo(),
      binding: AMSBinding(),
    ),
  ];
}

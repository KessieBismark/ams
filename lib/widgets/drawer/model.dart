import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DItems {
  final IconData icon;
  final String title;
  final String? link;
  final List<String> subMenus;
  final String? route;

  DItems(
      {required this.icon,
      this.link,
      required this.title,
      required this.subMenus,
      this.route});
}

class MyDrawerItems {
  final String header;
  final List<DItems> items;

  MyDrawerItems(this.header, this.items);

  static List<MyDrawerItems> data = [
    MyDrawerItems(
      "",
      [
        DItems(
          icon: Icons.dashboard_customize,
          title: "Dashboard",
          link: "/dash",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Employee Management",
      [
        DItems(
          icon: Icons.group_add_sharp,
          title: "Employee",
          link: "/employee",
          subMenus: [],
        ),
        DItems(
          icon: Icons.group_work,
          title: "Department",
          link: "/department",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Leave Management",
      [
        DItems(
          icon: FontAwesomeIcons.calendar,
          title: "Permission",
          link: "/permission",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Holidays",
      [
        DItems(
          icon: Icons.work_off,
          title: "holidays",
          link: "/holidays",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "SMS",
      [
        DItems(
          icon: Icons.message,
          title: "Sms Portal",
          link: "/sms",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "REPORT & ANALYSIS",
      [
        DItems(
          icon: Icons.timelapse,
          title: "Attendance",
          link: "/attendance",
          subMenus: [],
        ),  DItems(
          icon: Icons.lunch_dining,
          title: "Lunch Break",
          link: "/lunch",
          subMenus: [],
        ),
        DItems(
          icon: Icons.report,
          title: "Report",
          subMenus: [
            "Absent Report-/absent_report",
            "Absentees-/absentee",
            "Monthly Report-/mreport",
            "Overtime Report-/overtime",
          ],
        ),
      ],
    ),
//     MyDrawerItems(
//       "charges & Payroll",
//       [
//         DItems(
//           icon: Icons.timelapse,
//           title: "charges",
//           link: "/attendance",
//           subMenus: [
//             "Ssnit contribution-/attendance",
//             "Deductions-/attendance",
//           ],
//         ),
//         DItems(
//           icon: Icons.timelapse,
//           title: "Salary Structure",
//           link: "/salary",
//           subMenus: [],
//         ),
//         DItems(
//           icon: Icons.timelapse,
//           title: "Commissions",
//           link: "/attendance",
//           subMenus: [],
//         ),
//         DItems(
//           icon: Icons.timelapse,
//           title: "payslip",
//           link: "/attendance",
//           subMenus: [
//             // "Ssnit contribution-/attendance",
//             // "Commissions-/attendance",
//             // "Deductions-/attendance",
//             // "Salary Structure-/attendance",
// //"Salary Structure-/attendance",
//           ],
//         ),
//       ],
//     ),
    MyDrawerItems(
      "Configurations & Settings",
      [
        DItems(
          icon: FontAwesomeIcons.codeBranch,
          title: "branches",
          link: "/branches",
          subMenus: [],
        ),
        DItems(
          icon: FontAwesomeIcons.industry,
          title: "Company info",
          link: "/cinfo",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "User Account",
      [
        DItems(
          icon: Icons.verified_user,
          title: "Accounts",
          link: "/accounts",
          subMenus: [],
        ),
      ],
    ),
  ];
}

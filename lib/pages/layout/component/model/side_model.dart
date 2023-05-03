import 'package:ams/pages/absent_report/absent_report.dart';
import 'package:ams/pages/absentee/absentee.dart';
import 'package:ams/pages/accounts/users/users.dart';
import 'package:ams/pages/dash/dash.dart';
import 'package:ams/pages/department/department.dart';
import 'package:ams/pages/employee/employee.dart';
import 'package:ams/pages/holiday/holiday.dart';
import 'package:ams/pages/lunch_break/lunch.dart';
import 'package:ams/pages/monthly/monthly.dart';
import 'package:ams/pages/overtime/overtime.dart';
import 'package:ams/pages/permission/permission.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/utils/helpers.dart';
import '../../../branches/branches.dart';
import '../../../company_info/company_info.dart';
import '../../../daily/daily.dart';
import '../../../sms/sms.dart';

class SubMenu {
  final String id;
  final String title;
  final Widget widget;
  final IconData? icon;

  SubMenu(
      {required this.id,
      this.icon = Entypo.dot,
      required this.title,
      required this.widget});
}

class MenuModel {
  final String id;
  final String title;
  final String? label;
  final IconData icon;
  final Widget? widget;
  final List<SubMenu> subMenu;

  MenuModel(
      {required this.id,
      required this.title,
      this.label,
      required this.subMenu,
      required this.icon,
      this.widget});
}

class MenuHeader {
  final String header;
  final List<MenuModel> menus;

  MenuHeader({required this.header, required this.menus});

  static List<MenuHeader> data = [
    MenuHeader(header: "", menus: [
      MenuModel(
          id: Utils.getInitials('Dashboard'),
          title: 'Dashboard',
          subMenu: [],
          widget: const Dashboard(),
          icon: Icons.dashboard_customize)
    ]),
    MenuHeader(header: "Employee Management", menus: [
      MenuModel(
        id: Utils.getInitials('Employee'),
        title: 'Employee',
        subMenu: [],
        widget: const Employee(),
        icon: Icons.group_add_sharp,
      ),
      MenuModel(
        id: Utils.getInitials('Department'),
        title: 'Department',
        subMenu: [],
        widget: const Department(),
        icon: Icons.group_work,
      ),
    ]),
    MenuHeader(header: "Leave Management", menus: [
      MenuModel(
          id: Utils.getInitials('Permission'),
          title: 'Permission',
          subMenu: [],
          icon: FontAwesomeIcons.calendar,
          widget: const Permission()),
      MenuModel(
          id: Utils.getInitials('Holidays'),
          title: 'Holidays',
          subMenu: [],
          icon: Icons.work_off,
          widget: const Holiday())
    ]),
    MenuHeader(header: "SMS", menus: [
      MenuModel(
          id: Utils.getInitials('Holidays'),
          title: 'SMS',
          subMenu: [],
          icon: Icons.message,
          widget: const SMS())
    ]),
    MenuHeader(header: "REPORT & ANALYSIS", menus: [
      MenuModel(
          id: Utils.getInitials('Attendance'),
          title: 'Attendance',
          icon: Icons.timelapse,
          subMenu: [],
          widget: const Attendance()),
      MenuModel(
          id: Utils.getInitials('Lunch Break'),
          title: 'Lunch Break',
          icon: Icons.lunch_dining,
          subMenu: [],
          widget: const Lunch()),
      MenuModel(
          id: Utils.getInitials('Report'),
          title: 'Report',
          icon: FontAwesomeIcons.flask,
          subMenu: [
            SubMenu(
                icon: Entypo.dot,
                id: Utils.getInitials('Absent Report'),
                title: 'Absent Report',
                widget: const AbsentReport()),
            SubMenu(
                icon: Entypo.dot,
                id: Utils.getInitials('Absentees'),
                title: 'Absentees',
                widget: const Absentee()),
            SubMenu(
                icon: Entypo.dot,
                id: Utils.getInitials('Monthly Report'),
                title: 'Monthly Report',
                widget: const MonthlyReport()),
            SubMenu(
                icon: Entypo.dot,
                id: Utils.getInitials('Overtime Report'),
                title: 'Overtime Report',
                widget: const OverTime())
          ]),
    ]),
    MenuHeader(header: "Configurations & Settings", menus: [
      MenuModel(
          id: Utils.getInitials('Branches'),
          title: 'Branches',
          subMenu: [],
          icon: FontAwesomeIcons.codeBranch,
          widget: const Branches()),
      MenuModel(
          id: Utils.getInitials('Company info'),
          title: 'Company info',
          subMenu: [],
          icon: FontAwesomeIcons.industry,
          widget: const CompanyInfo())
    ]),
    MenuHeader(header: "User Accounts", menus: [
      MenuModel(
          id: Utils.getInitials('Accounts'),
          title: 'Accounts',
          subMenu: [],
          icon: Icons.verified_user,
          widget: const Users())
    ])
  ];
}

class SearchableModel {
  final String id;
  final IconData? icon;
  final String title;
  final Widget widget;

  SearchableModel(
      {this.icon, required this.id, required this.title, required this.widget});
}

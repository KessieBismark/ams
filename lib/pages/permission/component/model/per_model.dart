class PermissionModel {
  final String id;
  final String staffID;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String department;
  final String sdate;
  final String days;
  final String date;
  final String eDate;
  final String type;
  final String hours;
  final String branch;
  final String? reason;

  PermissionModel(
      {required this.id,
      required this.staffID,
      required this.surname,
      this.middlename,
      this.firstname,
      required this.department,
      required this.sdate,
      required this.days,
      required this.branch,
      required this.date,
      required this.eDate,
      required this.type,
      required this.hours,
      this.reason});

  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
        id: map['id'],
        staffID: map['staff_id'],
        surname: map['Surname'],
        firstname: map['first_name'] ?? '',
        middlename: map['Middle_name'] ?? '',
        department: map['department'],
        sdate: map['start_date'],
        eDate: map['end_date'],
        type: map['type'],
        branch: map['branch'],
        hours: map['leave_hours'],
        days: map['days'],
        reason: map['reason'] ?? '',
        date: map['date']);
  }
}

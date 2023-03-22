class AbRecordModel {
  final String staffID;
  final String surname;
  final String? firstname;
  final String? middlename;
  final String department;
  final String permission;
  final String dates;
  final String abDays;
  final String branch;

  AbRecordModel(
      {required this.staffID,
      this.middlename,
      this.firstname,
      required this.surname,
      required this.department,
      required this.permission,
      required this.branch,
      required this.dates,
      required this.abDays});

  factory AbRecordModel.fromMap(Map<String, dynamic> map) {
    return AbRecordModel(
        staffID: map['Staff_ID'],
        firstname: map['first_name'] ?? '',
        middlename: map['Middle_name'] ?? '',
        surname: map['Surname'],
        department: map['department'],
        branch: map['branch'],
        permission: map['Leave_Type'],
        dates: map['date'],
        abDays: map['days']);
  }
}

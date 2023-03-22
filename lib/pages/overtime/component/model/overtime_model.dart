class OvertimeModel {
  final String staffId;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String department;
  final String? totalSeconds;
  final String branch;

  OvertimeModel(
      {required this.staffId,
      required this.surname,
      this.middlename,
       this.firstname,
      required this.department,
      this.totalSeconds,
      required this.branch});

  factory OvertimeModel.fromMap(Map<String, dynamic> map) {
    return OvertimeModel(
      staffId: map['staff_id'],
      surname: map['Surname'],
      firstname: map['first_name']??'',
      middlename: map['Middle_name'] ?? '',
      department: map['department'],
      totalSeconds: map['total_seconds'] ?? '',
      branch: map['branch'],
    );
  }
}

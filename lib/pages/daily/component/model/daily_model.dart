class DailyModel {
  final String staffID;
  final String surname;
  final String? firstname;
  final String? middlename;
  final String department;
  final String inTime;
  final String? outTime;
  final String? overtime;
  final String date;
  final String? hours;
  final String branch;

  DailyModel({
    required this.staffID,
    this.firstname,
    this.middlename,
    required this.surname,
    required this.department,
    required this.inTime,
    this.outTime,
    this.overtime,
    required this.date,
    required this.branch,
    this.hours,
  });

  factory DailyModel.fromMap(Map<String, dynamic> map) {
    return DailyModel(
      staffID: map['staff_id'],
      firstname: map['first_name'] ?? '',
      middlename: map['Middle_name'] ?? '',
      surname: map['Surname'],
      department: map['department'],
      inTime: map['in_time'],
      outTime: map['out_time'] ?? "",
      overtime: map['overtime'] ?? "",
      date: map['date'],
      branch: map['branch'],
      hours: map['hours'] ?? "",
    );
  }
}

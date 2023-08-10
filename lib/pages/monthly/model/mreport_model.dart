class MModel {
  final String staffID;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String department;
  final String count;
  final String time;
  final String date;
  final String branch;

  MModel(
      {required this.staffID,
      required this.surname,
      this.middlename,
      this.firstname,
      required this.department,
      required this.count,
      required this.time,
      required this.date,
      required this.branch});

  factory MModel.fromMap(Map<String, dynamic> map) {
    return MModel(
      staffID: map['Staff_ID'],
      surname: map['Surname'],
      firstname: map['first_name'] ?? '',
      middlename: map['Middle_name'] ?? '',
      department: map['department'],
      branch: map['branch'],
      count: map['Count'],
      time: map['Time'],
      date: map['Dates'],
    );
  }
}

class MReportModel {
  final String staffId;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String department;
  final String inTime;
  final String? outTime;
  final String? overtime;
  final String date;
  final String? hours;
  final String branch;

  MReportModel(
      {required this.staffId,
      required this.surname,
      this.middlename,
      this.firstname,
      required this.department,
      required this.inTime,
      required this.outTime,
      required this.overtime,
      required this.date,
      required this.hours,
      required this.branch});

  factory MReportModel.fromMap(Map<String, dynamic> map) {
    return MReportModel(
      staffId: map['staff_id'],
      surname: map['Surname'],
      firstname: map['first_name'] ?? '',
      middlename: map['Middle_name'] ?? '',
      department: map['department'],
      inTime: map['in_time'],
      branch: map['branch'],
      outTime: map['out_time'] ?? '',
      overtime: map['overtime'] ?? '',
      date: map['date'],
      hours: map['hours'] ?? '',
    );
  }
}

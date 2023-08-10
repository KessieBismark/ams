class LunchModel {
  final String staffID;
  final String surname;
  final String? firstname;
  final String? middlename;
  final String department;
  final String inTime;
  final String? outTime;
  final String? overtime;
  final String date;
  final String branch;

  LunchModel({
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
  });

  factory LunchModel.fromMap(Map<String, dynamic> map) {
    return LunchModel(
      staffID: map['Staff_ID'],
      firstname: map['first_name'] ?? '',
      middlename: map['Middle_name'] ?? '',
      surname: map['Surname'],
      department: map['department'],
      inTime: map['In_Time'],
      outTime: map['Out_Time'] ?? "",
      overtime: map['Overtime'] ?? "",
      date: map['Date'],
      branch: map['branch'],
    );
  }
}

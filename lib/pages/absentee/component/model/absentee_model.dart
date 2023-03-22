class AbsentModel {
  final String staffID;
  final String surname;
  final String? firstname;
  final String? middlename;
  final String department;
  final String branch;

  AbsentModel({
    required this.staffID,
     this.firstname,
    this.middlename,
    required this.branch,
    required this.surname,
    required this.department,
  });

  factory AbsentModel.fromMap(Map<String, dynamic> map) {
    return AbsentModel(
      staffID: map['staff_id'],
      firstname: map['first_name']??'',
      middlename: map['Middle_name'] ?? '',
      surname: map['Surname'],
      branch: map['branch'],
      department: map['department'],
    );
  }
}

// class DropDownModel {
//   final String id;
//   final String name;

//   DropDownModel({required this.id, required this.name});
// }

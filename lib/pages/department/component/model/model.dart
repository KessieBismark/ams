class DepartmentModel {
  final int id;
  final String name;
  final String weekstart;
  final String weekendstart;
  final String weekdays;
  final String weekend;
  final String branch;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.weekdays,
    required this.weekend,
    required this.weekstart,
    required this.branch,
    required this.weekendstart,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> map) {
    return DepartmentModel(
      id: int.parse(map['ID']),
      name: map['Name'],
      weekdays: map['Weekdays'],
      weekend: map['Weekend'],
      branch: map['branch'],
      weekstart: map['week_start'],
      weekendstart: map['weekend_start'],
    );
  }
}

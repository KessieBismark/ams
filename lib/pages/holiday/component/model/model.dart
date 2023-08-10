class HolidayModel {
  final int id;
  final String date;
  final String? des;

  final String branch;

  HolidayModel({
    required this.id,
    required this.date,
    this.des,
    required this.branch,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> map) {
    return HolidayModel(
      id: int.parse(map['id']),
      date: map['date'],
      des: map['description'] ?? '',
      branch: map['branch'],
    );
  }
}

class SsnitModel {
  final String id;
  final String surname;
  final String firstname;
  final String? middleName;
  final String month;
  final String year;
  final String amount;

  SsnitModel(
      {required this.id,
      required this.surname,
      required this.firstname,
      required this.middleName,
      required this.month,
      required this.year,
      required this.amount});

  factory SsnitModel.fromJson(Map<String, dynamic> map) {
    return SsnitModel(
        id: map[''],
        surname: map['surname'],
        firstname: map['firstname'],
        middleName: map['middle_name'] ?? '',
        month: map['month'],
        year: map['year'],
        amount: map['amount']);
  }
}

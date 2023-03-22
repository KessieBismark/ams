class ssnitModel {
  final String id;
  final String surname;
  final String firstname;
  final String? middleName;
  final String month;
  final String year;
  final String amount;

  ssnitModel(
      {required this.id,
      required this.surname,
      required this.firstname,
      required this.middleName,
      required this.month,
      required this.year,
      required this.amount});

  factory ssnitModel.fromJson(Map<String, dynamic> map) {
    return ssnitModel(
        id: map[''],
        surname: map['surname'],
        firstname: map['firstname'],
        middleName: map['middle_name'] ?? '',
        month: map['month'],
        year: map['year'],
        amount: map['amount']);
  }
}

class SalaryModel {
  final String id;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String amount;
  final String? group;
  final String branch;

  SalaryModel(
      {required this.id,
      required this.surname,
      this.middlename,
      this.firstname,
      required this.amount,
      required this.branch,
      this.group});

  factory SalaryModel.fromJson(Map<String, dynamic> map) {
    return SalaryModel(
        id: map['id'],
        surname: map['Surname'],
        firstname: map['first_name'] ?? '',
        middlename: map['Middle_name'] ?? '',
        amount: map['amount'],
        branch: map['branch'],
        group: map['group'] ?? '');
  }
}

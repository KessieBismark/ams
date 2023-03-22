class DashModel {
  final String surname;
  final String? middleName;
  final String? firstName;
  final String? early;
  final String? late;

  DashModel(
      {required this.surname,
      required this.middleName,
      required this.firstName,
       this.early,
       this.late});
  factory DashModel.fromJson(Map<String, dynamic> map) {
    return DashModel(
        surname: map['Surname'],
        middleName: map['Middle_name']??'',
        firstName: map['first_name']??'',
        early: map['early']??'',
        late: map['late']??'');
  }
}

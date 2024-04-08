class EmpListModel {
  final int staffID;
  final String surname;
  final String? middlename;
  final String? firstname;
  final String? dob;
  final String department;
  final String? gender;
  final String? contact;
  final String? residence;
  final String? eContact;
  final String? ssnit;
  final String? accountNo;
  final String? bID;
  final String? dID;
  final String? bank;
  final String? picture;

  final int hour;
  final String? hiredDate;
  final int active;
  final String resigned;
  final String branch;
  final String? finger;
  final String? pid;
  final String? position;
  final String? emergencyName;
  final String? email;
  final String? nid;

  EmpListModel(
      {required this.staffID,
      required this.surname,
      this.middlename,
      this.firstname,
      this.dob,
      required this.department,
      this.gender,
      this.nid,
      this.ssnit,
      this.pid,
      this.position,
      this.emergencyName,
      this.email,
      this.accountNo,
      this.picture,
      this.bank,
      this.bID,
      this.dID,
      required this.hour,
      this.contact,
      this.residence,
      this.eContact,
      this.finger,
      this.hiredDate,
      required this.branch,
      required this.active,
      required this.resigned});

  factory EmpListModel.fromJson(Map<String, dynamic> json) {
    return EmpListModel(
        staffID: int.parse(json['Staff_ID']),
        surname: json['Surname'],
        firstname: json['first_name'] ?? '',
        picture: json['picture'] ?? '',
        middlename: json['Middle_name'] ?? '',
        department: json['Department'],
        dob: json['DOB'] ?? '',
        ssnit: json['ssnit'] ?? '',
        accountNo: json['accountNo'] ?? '',
        bank: json['bank'] ?? '',
        hour: int.parse(json['Working_Hours'] ?? 0),
        gender: json['Gender'] ?? '',
        contact: json['Contact'] ?? '',
        pid: json['pid'] ?? '',
        position: json['position'] ?? '',
        nid: json['national_id'] ?? '',
        emergencyName: json['emergency_name'] ?? '',
        email: json['email'] ?? '',
        finger: json['finger'] ?? '',
        bID: json['bid'] ?? '',
        dID: json['did'] ?? '',
        residence: json['Residence'] ?? '',
        eContact: json['Emergency_Contact'] ?? '',
        hiredDate: json['Hired_Date'] ?? '',
        active: int.parse(json['Active']),
        branch: json['branch'],
        resigned: json['Resigned']);
  }
}

class PositionModel {
  final String id;
  final String name;

  PositionModel({required this.id, required this.name});

  factory PositionModel.fromJson(Map<String, dynamic> map) {
    return PositionModel(id: map['id'], name: map['title']);
  }
}

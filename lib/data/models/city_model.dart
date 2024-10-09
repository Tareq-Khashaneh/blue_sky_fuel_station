class CityModel {
  final int? id;
  final String? name;

  CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> data) =>
      CityModel(id: data['id'], name: data['name']);
}


class ProductModel {
  final int? id;
  final String? name;
  final String? nameAr;
  final String? unit;
  final int? amount;
  final int? quota;
  ProductModel(
      {required this.id,
      required this.name,
      required this.nameAr,
      required this.unit,
      required this.amount,
      required this.quota});
  factory ProductModel.fromJson(Map<String, dynamic> data) => ProductModel(
      id: data['id'],
      name: data['name'],
      nameAr: data['name_ar'],
      unit: data['unit'],
      amount: data['amount_precision'],
      quota: data['device_quota']);

}

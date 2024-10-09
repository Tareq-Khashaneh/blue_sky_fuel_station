
import '../../core/constants/typedef.dart';

class SaleModel {
  final String? name;
  final String? nameAr;
   var quantity;
  final double? unitPrice;
  final double? totalPrice;
  final int? isSummary;
  SaleModel(
      {required this.name,
      required this.nameAr,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.isSummary});

  factory SaleModel.fromJson(parameters json) => SaleModel(
      name: json['name'],
      nameAr: json['name_ar'],
      quantity:json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      isSummary: json['is_summary']);
}

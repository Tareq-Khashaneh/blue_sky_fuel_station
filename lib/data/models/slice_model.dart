
import '../../core/constants/typedef.dart';

class Slice {
  final String shortcut;
  final String shortcutAr;
  final int sliceOrder;
  final double quota;
  final double price;

  Slice(
      {required this.shortcut,
      required this.shortcutAr,
      required this.sliceOrder,
      required this.quota,
      required this.price});

  factory Slice.fromJson(parameters json) => Slice(
      shortcut: json['shortcut'],
      shortcutAr: json['shortcut_ar'],
      sliceOrder: json['slice_order'],
      quota: json['quota'],
      price: json['price']);
}

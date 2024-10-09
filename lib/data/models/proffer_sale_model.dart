
import 'package:blue_sky_station/data/models/slice_proffer_model.dart';

import '../../core/constants/typedef.dart';

class ProfferSaleModel {
  final String cardSellId;
  final String sellDate;
  final String plateNumber;
  final String invoiceNumber;
  final List<SliceProfferModel> slices;

  ProfferSaleModel(
      {required this.cardSellId,
      required this.sellDate,
      required this.plateNumber,
      required this.invoiceNumber,
      required this.slices});
  factory ProfferSaleModel.fromJson(parameters json) => ProfferSaleModel(
        cardSellId: json['card_sell_id'],
        sellDate: json['sell_date'],
        plateNumber: json['plate_number'],
        invoiceNumber: json['invoice_number'],
        slices: (json['slices'] as List)
            .map((sliceMap) => SliceProfferModel.fromJson(sliceMap))
            .toList(),
      );
}

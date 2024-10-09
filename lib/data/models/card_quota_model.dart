
import 'package:blue_sky_station/data/models/slice_model.dart';

import '../../core/constants/typedef.dart';

class CardQuotaModel {
  final int type;
  final List<Slice> slices;
  final double maxQuantity;

  CardQuotaModel(
      {required this.type, required this.slices, required this.maxQuantity});
  factory CardQuotaModel.fromJson(parameters json) => CardQuotaModel(
      type: json['data']['type'],
      slices: (json['data']['slices'] as List)
          .map((sliceMap) => Slice.fromJson(sliceMap))
          .toList(),
      maxQuantity: json['data']['max_quantity']);
}

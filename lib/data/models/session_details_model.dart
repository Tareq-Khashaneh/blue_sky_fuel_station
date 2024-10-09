



import 'package:blue_sky_station/data/models/sale_model.dart';

import '../../core/constants/typedef.dart';

class SessionDetailsModel {
  final String? sessionId;
  final String? username;
  final String? startTime;
  final String? endTime;
  final List<SaleModel> sales;
  final double? total;

  SessionDetailsModel(
      {required this.sessionId,
      required this.username,
      required this.startTime,
      required this.endTime,
      required this.sales,
      required this.total});

  factory SessionDetailsModel.fromJson(parameters json)
    => SessionDetailsModel(
        sessionId: json['session_id'],
        username: json['username'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        sales: [
          for (parameters sale in json['sales']) SaleModel.fromJson(sale)
        ],
        total: json['total']);

}

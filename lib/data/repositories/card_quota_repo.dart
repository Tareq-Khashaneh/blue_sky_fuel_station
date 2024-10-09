import 'dart:convert';

import '../../connection/api_service.dart';
import '../../core/constants/api_endpoint.dart';
import '../../core/constants/typedef.dart';

class CardQuotaRepo {
  final ApiService _apiService;

  CardQuotaRepo({required ApiService apiService}) : _apiService = apiService;
  Future<Map<String, dynamic>?> getCardQuota(
       parameters params) async {
    try {
      dioRes? response = await _apiService.get(Api.cardQuota, params);
      if (response != null) {
        Map<String, dynamic> data = jsonDecode(response.data);
        return data;
      } else {
        print("error in get CardQuotaRepo");
        return null;
      }
    } catch (e) {
      print("error in CardQuotaRepo  $e");
      return null;
    }
  }
}

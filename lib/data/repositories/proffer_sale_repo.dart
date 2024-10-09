import 'dart:convert';

import '../../connection/api_service.dart';
import '../../core/constants/api_endpoint.dart';
import '../../core/constants/typedef.dart';

class ProfferSaleRepo {
  final ApiService _apiService;

  ProfferSaleRepo({required ApiService apiService}) : _apiService = apiService;

  Future<Map<String, dynamic>?> profferSale(parameters params) async {
    try {
      dioRes? response = await _apiService.get(Api.profferSale, params);
      if (response != null) {
        Map<String, dynamic> data = jsonDecode(response.data);
        return data['data'];
      } else {
        print("error in get ProfferSaleRepo");
        return null;
      }
    } catch (e) {
      print("error in ProfferSaleRepo  $e");
      return null;
    }
  }
}

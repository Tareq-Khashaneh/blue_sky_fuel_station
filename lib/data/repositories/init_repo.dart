import 'dart:convert';
import '../../connection/api_service.dart';
import '../../core/constants/api_endpoint.dart';
import '../../core/constants/typedef.dart';

class InitRepository {
  final ApiService _apiService;

  InitRepository({required ApiService apiService}) : _apiService = apiService;
  Future<Map<String, dynamic>?> getMainData(parameters params) async {
    try {
      dioRes? response = await _apiService.get(Api.ping, params);
      if (response != null) {
        Map<String, dynamic> data = jsonDecode(response.data);
        return data;
      } else {
        print("error in get InitRepository");
        return null;
      }
    } catch (e) {
      print("error in InitRepository  $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> printData(parameters params) async {
    try {
      dioRes? response = await _apiService.get(Api.print, params);
      if (response != null) {
        parameters data = jsonDecode(response.data);
        return data;
      } else {
        print("error in get InitRepository printData");
        return null;
      }
    } catch (e) {
      print("error in InitRepository  printData $e");
      return null;
    }
  }
}

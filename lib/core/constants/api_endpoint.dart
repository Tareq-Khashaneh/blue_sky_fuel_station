
abstract class Api {
  static String _baseUrl = "" ;
  static const String ping = '/ping-json';
  static const String login = '/login';
  static const String cardQuota = '/get-card-quota-json';
  static const String profferSale = '/sell1-json';
  static const String print = '/print';
  static const String logout = '/logout';
  static setBaseUrl({required String ip ,required String port})
  =>    _baseUrl =  "http://$ip:$port/proffer/web/POS/v602/dev-api";
  static String get baseUrl
   =>  _baseUrl;
}

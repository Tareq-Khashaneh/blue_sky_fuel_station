

import 'package:blue_sky_station/data/models/product_model.dart';
import 'package:blue_sky_station/data/models/settings_model.dart';
import 'package:blue_sky_station/data/models/user_model.dart';

import 'city_model.dart';

class DataModel {

  final String? adminPass;
  final String? facilityName;
  final int? facilityType;
  final String? svTm;
  final String? devSn;
  final String? sellCenter;
  final List<UserModel> users;
  final List<ProductModel> products;
  final List<CityModel> cities;
  final List<dynamic>  devicesQuota;
  final String? gasId;
  final SettingsModel settings;
  DataModel(
      {required this.facilityName,
      required this.facilityType,
      required this.svTm,
      required this.users,
      required this.products,
      required this.cities,
        required this.devicesQuota,
      required this.gasId,
        required this.sellCenter,
      required this.adminPass,
      required this.devSn,
      required this.settings});
  factory DataModel.fromJson(Map<String, dynamic> data) => DataModel(
        svTm: data['sv_tm'],
        facilityName: data['data']['fac_name'],
        facilityType: data['data']['fac_type'],
        // users:List<Map<String, dynamic>>.from(data['users']).map((userMap) =>  UserModel.fromJson(userMap)).toList(),
        users: (data['data']['users'] as List<dynamic>).map((userMap) => UserModel.fromJson(userMap)).toList(),
        products: (data['data']['products'] as List<dynamic>).map((productMap) => ProductModel.fromJson(productMap)).toList(),
        cities:(data['data']['cities'] as List<dynamic>).map((cityMap) => CityModel.fromJson(cityMap)).toList(),
        sellCenter: data['data']['sell_center'],
        gasId: data['data']['fac_name'],
        adminPass: data['data']['admin_pass'],
        devicesQuota: data['data']['devices_quota'],
        devSn: data['data']['dev_sn'],
        settings: SettingsModel.fromJson(data['data']['settings']),
      );
}

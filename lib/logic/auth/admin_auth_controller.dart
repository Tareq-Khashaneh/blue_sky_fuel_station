import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/constants/errors.dart';
import '../connectivity/connectivity _controller.dart';
import '../getx_service/app_service.dart';

class AdminAuthController extends GetxController {
  bool isAdmin() {
    if (password.text.isNotEmpty) {
      if (password.text != adminPassword) {
        Alerts.showSnackBar("كلمة المرور خاطئة");
        return false;
      }
      return true;
    }
    Alerts.showSnackBar("كلمة المرور فارغة");
    return false;
  }

  @override
  void onInit() async {
    // connectivityController.subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((List<ConnectivityResult> result) async {
    //   await Future.delayed(const Duration(seconds: 15));
    //   if (result.contains(ConnectivityResult.mobile) ||
    //       result.contains(ConnectivityResult.wifi)) {
    //     if (_appService.storage.read("ip") != null && _appService.storage.read("port") != null) {
    //      await _appService.initializeDataDetails(
    //           ip: _appService.storage.read("ip"),
    //           port: _appService.storage.read("port")
    //       );
    //       // if (isServerConnected) {
    //       //   print("here");
    //         // Get.offAllNamed(AppRoutes.splash);
    //       // }
    //     }
    //   }
    // });
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    // connectivityController.subscription.cancel();
    super.dispose();
  }

  // final ConnectivityController connectivityController = Get.find();
  late TextEditingController password;
  final adminPassword = "1111";
  final AppService _appService = Get.find();
}

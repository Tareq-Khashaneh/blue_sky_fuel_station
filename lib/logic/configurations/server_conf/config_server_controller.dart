import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/errors.dart';
import '../../getx_service/app_service.dart';

class ConfigServerController extends GetxController {
  @override

  void onInit() {
    initTextEditingControllers();
    super.onInit();
  }

  @override
  void dispose(){
    super.dispose();
    serverIpController.dispose();
    portController.dispose();
  }

  Future<bool> checkConnectToServer() async {
    isLoading = true;
    update();
    final Completer<bool> completer = Completer<bool>();
    bool isConnected = false;
    try {
      if (await appService.checkConnectivity()) {
        await appService.initializeDataDetails(
            ip: serverIpController.text, port: portController.text);
        if (appService.dataDetails != null) {
          appService.storage.write("ip", serverIpController.text);
          appService.storage.write("port", portController.text);
          isConnected = true;

        } else {
          print("data details is  null in setting controller");
          Alerts.showSnackBar("خطأ في الاتصال مع المخدم");
          isConnected = false;
        }
      } else {

        isConnected = false;
        Alerts.showSnackBar("يرجى تشغيل الشبكة");
      }
    } catch (e) {
      completer.completeError(e);
    }

    isLoading = false;
    update();
    return isConnected;
  }

  void initTextEditingControllers() {
    serverIpController = TextEditingController();
    portController = TextEditingController();
    if (appService.storage.read("ip") != null && appService.storage.read("port") != null) {
      serverIpController.text = appService.storage.read("ip");
      portController.text = appService.storage.read("port");
    }
  }


  late TextEditingController serverIpController;
  late TextEditingController portController;

  final AppService appService = Get.find();
  bool isLoading = false;
}

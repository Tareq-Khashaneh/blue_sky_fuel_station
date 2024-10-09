import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/errors.dart';
import '../../getx_service/app_service.dart';

class ConfigPumpController extends GetxController {
  @override
  void onInit() {
    initTextEditingControllers();
    super.onInit();
  }
  @override
  void dispose(){
    super.dispose();
    pumpIpController.dispose();
    pumpPortController.dispose();
    pumpIdController.dispose();

  }
  Future<bool> connectToPump() async {
    isLoading = true;
    update();
    try {
      await appService.connect(
          pumpIp: pumpIpController.text,
          pumpPort: int.parse(pumpPortController.text));
      await appService.listenToSocket();
      print("isSocketConnect ${appService.isSocketConnect}");
      if (appService.isSocketConnect) {
        appService.storage.write("pumpIp", pumpIpController.text);
        appService.storage.write("pumpPort", pumpPortController.text);
        appService.storage.write("pumpId", pumpIdController.text);
        Alerts.showSnackBar("نجح الاتصال");
        print("connect in pump controller");
      }else{
        Alerts.showSnackBar("خطأ في الاتصال مع المضخة");
      }
    } catch (e) {
      print("error in connectToPump");
    }
    isLoading = false;
    update();
    return appService.isSocketConnect;
  }

  void initTextEditingControllers() {
    pumpIpController = TextEditingController();
    pumpPortController = TextEditingController();
    pumpIdController = TextEditingController();
    if (appService.storage.read("pumpIp") != null &&
        appService.storage.read("pumpPort") != null &&
        appService.storage.read("pumpId") != null) {
      pumpIpController.text = appService.storage.read("pumpIp");
      pumpPortController.text = appService.storage.read("pumpPort");
      pumpIdController.text = appService.storage.read("pumpId");
    }
  }

  late TextEditingController pumpIpController;
  late TextEditingController pumpPortController;
  late TextEditingController pumpIdController;
  final serverFormKey = GlobalKey<FormState>();
  final AppService appService = Get.find();
  bool isLoading = false;
}

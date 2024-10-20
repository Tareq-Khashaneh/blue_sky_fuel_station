


import 'package:get/get.dart';
import '../../getx_service/app_service.dart';

class ConfigSysController extends GetxController{

  final AppService appService = Get.find();

  void switchPumpState(bool value) {
    appService.pumpState = value;
    appService.storage.write("pumpState", appService.pumpState);
    update();
  }
}
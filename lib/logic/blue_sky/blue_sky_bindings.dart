

import 'package:blue_sky_station/logic/blue_sky/blue_sky_controller.dart';
import 'package:get/get.dart';

class BlueSkyBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(BlueSkyController(),permanent: true);
  }
}
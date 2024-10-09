

import 'package:blue_sky_station/logic/socket_managing/socket_managing_controller.dart';
import 'package:get/get.dart';

class SocketManagingBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(SocketManagingController());
  }
}
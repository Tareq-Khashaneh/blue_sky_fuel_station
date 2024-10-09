

import 'package:get/get.dart';

import 'connectivity _controller.dart';

class ConnectivityBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(ConnectivityController());
  }
}
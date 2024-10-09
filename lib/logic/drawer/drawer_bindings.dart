


import 'package:get/get.dart';

import 'drawer_controller.dart';

class DrawerBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(DrawerGetxController(),
        // permanent: true
    );
  }
}
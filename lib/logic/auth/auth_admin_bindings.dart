

import 'package:get/get.dart';

import 'admin_auth_controller.dart';

class AuthAdminBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(AdminAuthController());
  }
}
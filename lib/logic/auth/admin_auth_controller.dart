
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/constants/errors.dart';

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
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  late TextEditingController password;
  final adminPassword = "1111";
}

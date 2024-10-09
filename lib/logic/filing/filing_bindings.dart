
import 'package:get/get.dart';

import 'filing_controller.dart';

class FilingBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(FilingController());
  }
}

import 'package:get/get.dart';

import 'filing_controller.dart';

class FillingBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(FillingController());
  }
}
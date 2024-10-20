import 'dart:typed_data';
import 'package:get/get.dart';
import '../getx_service/app_service.dart';

class SocketManagingController extends GetxController {
  final AppService appService = Get.find();

  Stream<Uint8List> getResponseStream() {
    return appService.responseController.stream;
  }

  Future<void> sendRequest(Uint8List request) async {
    try {
      appService.socket.add(request);
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}




import 'package:get/get.dart';
import '../../data/models/session_details_model.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/repositories/auth_repo.dart';
import '../auth/auth_controller.dart';
import '../getx_service/app_service.dart';

class DrawerGetxController extends GetxController {
  @override
  void onInit() {
    _authProvider = AuthProvider(authRepo: AuthRepo(apiService: _appService.apiService));
    super.onInit();
  }

  // void setDeviceTime() async {
  //   isLoadingSetTime = true;
  //   update();
  //   if (await _appService.setDateTime()) {
  //     isLoadingSetTime = false;
  //     showSnackBar("Time was set",
  //         isFail: false, snackPosition: SnackPosition.BOTTOM);
  //   } else {
  //     isLoadingSetTime = false;
  //     showSnackBar("Time was not set",
  //         isFail: true, snackPosition: SnackPosition.BOTTOM);
  //   }
  //   update();
  // }
  Future<bool> logout() async {
    try {
      logoutData =  await _authProvider.getLogoutData({
        'dev_sn': _appService.deviceSerialNum,
        'app_version': _appService.appVersion,
        'session_id': authenticateController.authModel!.sessionId,
      });
      if (logoutData != null) {
        // sessionController.printSessionInfo();
        return true;
      }
    } catch (e) {
      print("error in logout $e");
    }
    return false;
  }

  late bool isLoadingSetTime = false;
  final AuthController authenticateController = Get.find();
  // final HomeController homeController = Get.find();
  late AuthProvider _authProvider ;
  SessionDetailsModel? logoutData;
  final AppService _appService = Get.find<AppService>();
}

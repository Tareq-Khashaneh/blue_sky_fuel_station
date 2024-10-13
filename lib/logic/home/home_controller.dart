import 'dart:async';

import 'package:blue_sky_station/logic/blue_sky/blue_sky_controller.dart';
import 'package:blue_sky_station/logic/connectivity/connectivity%20_controller.dart';
import 'package:get/get.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/typedef.dart';
import '../../core/enums/enum_state.dart';
import '../../data/models/card_quota_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/card_quota_pro.dart';
import '../../data/repositories/card_quota_repo.dart';
import '../auth/auth_controller.dart';
import '../getx_service/app_service.dart';

class HomeController extends GetxController {
  final AppService appService = Get.find();
  final AuthController _authController = Get.find();
  final BlueSkyController blueSkyController = Get.find();
  int counterStatusIsEmpty = 0;
  late String cardId;
  late EnumStatus cardReadStatus;
  UserModel? currentUser;
  late bool isLoading;
  late bool isServerLoading;
  late CardQuotPro _cardQuotPro;
  CardQuotaModel? cardQuota;
  Map<String, int> status = {};
  late bool isPumpOff;
  bool isNozzleLift = false;
  bool isRunning = true;
  bool isRouterConnected = false;
  Timer? _pumpTimer;
  @override
  void onInit() async {
    cardId = '';
    isPumpOff = false;
    isLoading = false;
    isServerLoading = false;
    currentUser = _authController.currentUser;
    cardReadStatus = EnumStatus.initialize;
    _cardQuotPro = CardQuotPro(
        cardQuotaRepo: CardQuotaRepo(apiService: appService.apiService));
    if(appService.pumpState){
      startPumpConnectionCheck();
    }
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _pumpTimer?.cancel();
  }

  void startPumpConnectionCheck() {
    _pumpTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      await checkConnectionToPump();
    });
  }

  Future<void> checkConnectionToPump() async {
      status = await blueSkyController.readDispenserStatus();
      print("Status in home controller $status");
      if (status.isEmpty) {
        counterStatusIsEmpty++;
        print("status isEmpty home controller");
      } else {
        counterStatusIsEmpty = 0;
        if (status['control'] == 0) {
          await blueSkyController.askForControl();
        } else if (status['control'] == 1) {
          print("pump is Control");
        }
        if (status['nozzle'] == 1) {
          isNozzleLift = true;
        } else if (status['nozzle'] == 0) {
          isNozzleLift = false;
        }
      }if(counterStatusIsEmpty >= 4){
        isPumpOff = true;
      }
      update();
  }

  Future<bool> readCard() async {
    cardReadStatus = EnumStatus.loading;
    isLoading = true;
    update();
    return _readCard();
  }

  Future<bool> _readCard() async {
    try {
      final Map data = await appService.platformRead.invokeMethod('readCard');
      final bool isTimeOut = data['isTimeOut'];
      cardId = data['cardId'];
      if (isTimeOut == true) {
        cardReadStatus = EnumStatus.timeout;
        isLoading = false;
      } else if (cardId.isNotEmpty && currentUser != null) {
        isLoading = false;
        cardReadStatus = EnumStatus.success;
      }
    } catch (e) {
      Alerts.showSnackBar(
        'خطأ في قراءة البطاقة',
      );
      print('Error calling native method: $e');
      cardReadStatus = EnumStatus.failed;
      isLoading = false;
    }
    update();
    return cardReadStatus == EnumStatus.success ? true : false;
  }

  void stopRead() async {
    appService.platformRead.invokeMethod('stopRead').then((value) {
      if (value) {
        cardReadStatus = EnumStatus.stopped;
        isLoading = false;
      }
      update();
    });
  }


  Future<bool> getCardQuota() async {
    isServerLoading = true ;
    update();
    parameters params = {
      'user_id': _authController.currentUser!.id,
      'card_sn': cardId,
      'product_id': _authController.currentProduct!.id,
    };
    params.addAll(appService.params);
    try {
      cardQuota = await _cardQuotPro.getCardQuota(params);
    } catch (e) {
      print("error in getQardQuota ");
    }
    isServerLoading = false;
    update();
   return cardQuota != null ? true : false;

  }
}

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blue_sky_station/logic/blue_sky/blue_sky_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/routes.dart';
import '../../core/constants/typedef.dart';
import '../../core/enums/enum_state.dart';
import '../../data/models/card_quota_model.dart';
import '../../data/models/proffer_sale_model.dart';
import '../../data/providers/proffer_sale_pro.dart';
import '../../data/repositories/init_repo.dart';
import '../../data/repositories/proffer_sale_repo.dart';
import '../auth/auth_controller.dart';
import '../getx_service/app_service.dart';

class FillingController extends GetxController {
  final AppService appService = Get.find();
  final AuthController _authController = Get.find();
  final BlueSkyController blueSkyController = Get.find();
  CardQuotaModel? cardQuota;
  String orderLiters = '';
  ProfferSaleModel? profferSale;
  int counterPayment = 1;
  late int printStatus;
  late int randomInt;
  late EnumStatus filingStatus;
  late bool isNozzleLift;
  late Map<String, int> status;
  late Map<String, double> oldTotalizer;
  late Map<String, double> fuelingData;
  late AwesomeDialog dialogue;
  late ProfferSalePro _profferSalePro;
  late double sales;
  late double liters;
  late InitRepository _initRepo;
  late String? cardId;
  bool isLoading = false;
  late int onGoingFiling;
  late bool isRouterConnected;
  late bool timeOutNozzleUp;
  late bool isAchieveLimit;
  @override
  void onInit() async {
    fuelingData = {};
    status = {};
    oldTotalizer = {};
    printStatus = 0;
    timeOutNozzleUp = false;
    isAchieveLimit = false;
    isRouterConnected = appService.isRouterConnected.value;
    _initRepo = InitRepository(apiService: appService.apiService);
    filingStatus = EnumStatus.initialize;
    cardQuota = Get.arguments['cardQuota'];
    cardId = Get.arguments['cardId'];
    _profferSalePro = ProfferSalePro(
        profferSaleRepo: ProfferSaleRepo(apiService: appService.apiService));
    isNozzleLift = false;
    sales = 0.0;
    liters = 0.0;
    onGoingFiling = 0;
    appService.isServerConnected = true;
    if (appService.pumpState) {
      if (cardQuota != null) {
        if (cardQuota!.maxQuantity > 0) {
          await startUp().then((onValue) async {
            if (isRouterConnected) {
              if (status.isNotEmpty) {
                if ((status['nozzle'] == 0 && (liters > 0.1)) ||
                    isAchieveLimit) {
                  payment(orderLiters: liters).then((onValue) async {
                    if (onValue) {
                      await printInvoice(liters: liters, sales: sales).then(
                          (onValue) => Get.offNamed(AppRoutes.homeScreenRoute));
                    } else {
                      appService.isServerConnected = false;
                      appService.storage.write('liters', liters);
                      appService.checkPrePayment().then((onValue) async =>
                          await printInvoice(
                                  liters: liters,
                                  sales: sales,
                                  profferSaleModel: appService.profferSale)
                              .then((onValue) =>
                                  Get.offNamed(AppRoutes.homeScreenRoute)));
                    }
                  });
                }
              }
            } else {
              checkConnectionToPump().then((onValue) {
                payment(orderLiters: liters).then((onValue) async {
                  if (onValue) {
                    await printInvoice(liters: liters, sales: sales).then(
                        (onValue) => Get.offNamed(AppRoutes.homeScreenRoute));
                  } else {
                    appService.isServerConnected = false;
                    appService.storage.write('liters', liters);
                    appService.checkPrePayment().then((onValue) async =>
                        await printInvoice(
                                liters: liters,
                                sales: sales,
                                profferSaleModel: appService.profferSale)
                            .then((onValue) =>
                                Get.offNamed(AppRoutes.homeScreenRoute)));
                  }
                });
              });
            }
          });
        }
      }
    }
    super.onInit();
  }
void check(){

}
  @override
  void onReady() {
    super.onReady();
    appService.storage.write('cardId', cardId);
    appService.storage.write('productId', _authController.currentProduct!.id);
    appService.storage.write('sessionId', _authController.authModel!.sessionId);
    appService.storage.write('cityId', appService.dataDetails!.cities[0].id);
  }

  Future checkConnectionToPump() async {
    while (!appService.isRouterConnected.value) {
      await Future.delayed(const Duration(seconds: 1));
      isRouterConnected = false;
      if (appService.isRouterConnected.value) {
        isRouterConnected = true;
        await blueSkyController.askForControl();
        await blueSkyController.readDispenserStatus();
        Map<String, double> fuelingData =
            await blueSkyController.readFuelingData();
        Map<String, double> newTotalizer =
            await blueSkyController.readGeneralTotalizer();
        print("old Totlizer $oldTotalizer");
        print("new Totlizer $newTotalizer");
        if (oldTotalizer['volume'] == newTotalizer['volume']) {
          print("old is same new totalizer");
          Get.offNamed(AppRoutes.homeScreenRoute);
          break;
        } else {
          if (fuelingData.isNotEmpty) {
            if (fuelingData['volume'] != null) {
              print("last fueling Data ${fuelingData['volume']}");
              liters = fuelingData['volume'] ?? 0.0;
              sales = fuelingData['amount'] ?? 0.0;
              if (liters == newTotalizer['volume']) {
                print("liters is same newTotalizer");
              }
              print("liters after connect to Router $liters");
              print("sales after connect to Router $sales");

              break;
            }
          }
        }
      }
      update();
    }
  }

  Future<void> startUp() async {
    int nozzleUpCounter = 0;
    int nozzleUpCounterUnderLimit = 0;
    int routerCounter = 0;
    bool isNozzleUpAndDown = false;
    double volumeLimit = 2.0;
    if (await blueSkyController.askForControl()) {
      if (await blueSkyController.writePresetVolume(volume: volumeLimit)) {
        if (await blueSkyController.powerOn()) {
          while (true) {
            await Future.delayed(const Duration(seconds: 1));
            status = await blueSkyController.readDispenserStatus();
            print("status $status");
            if (status.isEmpty) {
              isRouterConnected = false;
            } else if (status.isNotEmpty) {
              isRouterConnected = true;
              oldTotalizer = await blueSkyController.readGeneralTotalizer();
              print("oldTotalizer $oldTotalizer");
              if (status['nozzle'] == 1) {
                print("nozzle up");
                isNozzleLift = true;
                fuelingData = await blueSkyController.readFuelingData();
                if (fuelingData.isNotEmpty) {
                  if (liters == fuelingData['volume']) {
                    nozzleUpCounterUnderLimit++;
                  } else if (liters != fuelingData['volume']) {
                    nozzleUpCounterUnderLimit = 0;
                  }
                  liters = fuelingData['volume'] ?? 0.0;
                  appService.storage.write('liters', liters);
                  sales = fuelingData['price'] ?? 0.0;
                  if (liters > 0.1) {
                    onGoingFiling = 1;
                    isNozzleUpAndDown = false;
                  }
                  if (onGoingFiling == 0) {
                    isNozzleUpAndDown = true;
                  }
                  print("liters $liters sales $sales");
                  if (nozzleUpCounterUnderLimit >= 20) {
                    await blueSkyController.powerOFF();
                    isAchieveLimit = true;
                    liters = fuelingData['volume']!;
                    sales = fuelingData['price']!;
                    print("nozzle is up end filling");
                    break;
                  }
                  if (liters == volumeLimit) {
                    nozzleUpCounter++;
                    print("liters $liters sales $sales the end");
                    print("end filing nozzle up");
                    if (nozzleUpCounter == 4) {
                      isNozzleLift = false;
                      timeOutNozzleUp = true;
                      update();
                    }
                    if (nozzleUpCounter >= 10) {
                      isAchieveLimit = true;
                      liters = fuelingData['volume']!;
                      sales = fuelingData['price']!;
                      break;
                    }
                  }
                } else {
                  print("fueling data is null");
                }
                update();
              } else if (status['nozzle'] == 0 && onGoingFiling == 1) {
                liters = fuelingData['volume']!;
                sales = fuelingData['price']!;
                print("liters $liters sales $sales the end");
                print("end filing");
                break;
              } else if (isNozzleUpAndDown) {
                await blueSkyController
                    .powerOFF()
                    .then((value) => Get.offNamed(AppRoutes.homeScreenRoute));
                break;
              }
            }
            if (isRouterConnected) {
              routerCounter = 0;
            } else if (!isRouterConnected) {
              routerCounter++;
            }
            if (routerCounter >= 7) {
              update();
              break;
            }
          }
        }
      }
    }
  }

  Future<bool> payment({required double orderLiters}) async {
    isLoading = true;
    update();
    DateTime now = DateTime.now();
    String localSerial = DateFormat('yyyyMMddHHmmss').format(now);
    appService.storage.write('localSerial', localSerial);
    try {
      parameters params = {
        'card_sn': cardId,
        'product_id': _authController.currentProduct!.id,
        'quantity': orderLiters,
        'plate_number': '12345',
        'city_id': '1',
        'counter': 1,
        'local_serial': localSerial,
      };
      params.addAll(appService.params);
      profferSale = await _profferSalePro.profferSale(params);
      if (profferSale != null) {
        Alerts.showSnackBar("تم خصم $orderLiters من الرصيد ");
        appService.isServerConnected = true;
      }
    } catch (e) {
      print("error in _payment ${e.toString()}");
      appService.isServerConnected = false;
    }
    if(profferSale == null){
      appService.isServerConnected = false;
    }
    isLoading = false;
    update();
    return profferSale != null ? true : false;
  }
  Future<bool> paymentIFFail({required double orderLiters}) async {
    isLoading = true;
    update();
    String localSerial =  appService.storage.read('localSerial');
    try {
      parameters params = {
        'card_sn': cardId,
        'product_id': _authController.currentProduct!.id,
        'quantity': orderLiters,
        'plate_number': '12345',
        'city_id': '1',
        'counter': ++counterPayment,
        'local_serial': localSerial,
      };
      params.addAll(appService.params);
      profferSale = await _profferSalePro.profferSale(params);
      if (profferSale != null) {
        Alerts.showSnackBar("تم خصم $orderLiters من الرصيد ");
        appService.isServerConnected = true;
      }
    } catch (e) {
      print("error in _payment ${e.toString()}");
      appService.isServerConnected = false;
    }
    if(profferSale == null){
      appService.isServerConnected = false;
    }
    isLoading = false;
    update();
    return profferSale != null ? true : false;
  }

  Future<void> printInvoice(
      {required double liters,
      required double sales,
      ProfferSaleModel? profferSaleModel}) async {
    try {
      profferSale = profferSaleModel ?? profferSale;
      String invoiceTemplate = '''
=========================
${appService.dataDetails!.facilityName}${"".padRight(20)}
=========================
رقم الفاتورة : ${profferSale!.invoiceNumber}
رقم بيع البطاقة : ${profferSale!.cardSellId},
تاريخ التعبئة : ${profferSale!.sellDate},
رقم البطاقة : $cardId,
رقم اللوحة : ${profferSale!.plateNumber},
اسم البائع : ${_authController.currentUser!.name}
-------------------------
 ${profferSale!.slices[0].shortcut} 
 ${profferSale!.slices[0].shortcutAr} 
 الباقي :${profferSale!.slices[0].remaining} 
الليترات المباعة : $liters 
-------------------------
المبلغ الإجمالي : ${sales.toStringAsFixed(0)}
=========================
${"".padRight(25)}شكرا
=========================
\n
\n
''';
      printStatus = await appService.platformPrint.invokeMethod(
        'print',
        {
          'invoiceTemplate': invoiceTemplate,
        },
      );
      parameters params = {
        'user_id': _authController.currentUser!.id,
        'card_sn': cardId,
        'product_id': _authController.currentProduct!.id,
        'print': printStatus,
        'transid': profferSale!.invoiceNumber
      };
      params.addAll(appService.params);
      await _initRepo.printData(params);
    } catch (e) {
      Alerts.showSnackBar("خطأ في الطباعة");
      print('Error in print: ${e.toString()}');
    }
  }

// void payment({required BuildContext context}) {
//   String price = (double.parse(orderLiters) * cardQuota!.slices[1].price)
//       .toStringAsFixed(0);
//   if (formKey.currentState!.validate()) {
//     dialogue = Alerts.showDialogue(
//       dialogType: DialogType.question,
//       context: context,
//       title: "تأكيد الدفع ؟",
//       desc:
//           "الكمية المطلوبة $orderLiters ليتر\nالسعر الإجمالي  $price ليرة سورية",
//       onPressYes: () => _payment(context: context),
//       onPressNo: () => Get.back(),
//     );
//   }
// }

// void _printWithDialogue({required BuildContext context}) {
//   dialogue = Alerts.showDialogue(
//       dialogType: DialogType.question,
//       context: context,
//       title: "هل تريد طباعة فاتورة التعبئة ؟",
//       onPressNo: () => Get.back(),
//       onPressYes: _printInvoice);
// }
}

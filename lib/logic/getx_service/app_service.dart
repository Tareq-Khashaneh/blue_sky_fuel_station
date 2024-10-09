import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../connection/api_service.dart';
import '../../core/constants/api_endpoint.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/typedef.dart';
import '../../data/models/data_model.dart';
import '../../data/models/proffer_sale_model.dart';
import '../../data/providers/init_provider.dart';
import '../../data/providers/proffer_sale_pro.dart';
import '../../data/repositories/init_repo.dart';
import '../../data/repositories/proffer_sale_repo.dart';
import '../connectivity/connectivity _controller.dart';

class AppService extends GetxService {
  late GetStorage storage;
  late ProfferSalePro _profferSalePro;
  final ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final StreamController<Uint8List> responseController =
      StreamController<Uint8List>.broadcast();
  final String appVersion = "NewProffer6.0.2.2";
  final MethodChannel platformMain =
      const MethodChannel('samples.flutter.dev/mainInfo');
  final MethodChannel platformRead =
      const MethodChannel('samples.flutter.dev/read');
  final MethodChannel platformPrint =
      const MethodChannel('samples.flutter.dev/print');
  bool pumpState = true;
  late Socket socket;
  ProfferSaleModel? profferSale;
  StreamSubscription<Uint8List>? subscription;
  StreamSubscription<List<ConnectivityResult>>? subscriptionConnectivityResult;
  Rx<bool> isRouterConnected = false.obs;
  late String deviceSerialNum;
  late parameters params;
  ApiServiceDio apiService = ApiServiceDio();
  late InitProvider initProvider;
  DataModel? dataDetails;
  bool isSocketConnect = false;
  final RxBool _isServerConnected = false.obs;
  late Stream<Uint8List> socketBroadcastStream;
  Future<void> connect({required String pumpIp, required int pumpPort}) async {
    try {
      print("ip $pumpIp port $pumpPort");
      socket = await Socket.connect(pumpIp, pumpPort);
      isSocketConnect = true;
      socketBroadcastStream = socket.asBroadcastStream();
    } catch (e) {
      isSocketConnect = false;
      print('Error connecting to socket: $e');
    }
    print('isSocket $isSocketConnect');
  }

  Future listenToSocket() async {
    try {
      if (subscription != null) {
        print(
            "Already listening to the socket, cancel the existing listener first.");
        return;
      }
      print("Listening to socket");
      subscription = socketBroadcastStream.listen(
        (Uint8List data) {
          handleReceivedData(data);
          print("Response in socket: $data");
        },
        onError: (error) {
          print('Error in socket subscription: ${error.toString()}');
        },
      );
    } catch (e) {
      print("Error in listenToSocket ${e.toString()}");
    }
  }

  void stopSocketListening() {
    if (subscription != null) {
      print("Stopping listening to socket");
      subscription!.cancel();
      subscription = null; // Set subscription to null after canceling
    } else {
      print("No active socket listener to stop");
    } // Cancel the stream subscription
  }

  Future<void> initializeDataDetails(
      {required String ip, required String port}) async {
    Api.setBaseUrl(ip: ip, port: port);
    apiService = ApiServiceDio();
    initProvider =
        InitProvider(initRepository: InitRepository(apiService: apiService));
    params = {
      'dev_sn': deviceSerialNum,
      'app_version': appVersion,
    };
    dataDetails = await initProvider.getMainData(params);
    if (dataDetails != null) {
      isServerConnected = true;
    } else {
      isServerConnected = false;
    }
    print("here $dataDetails");
    print("isServerConnect $isServerConnected");
    await setDateAndTime();
  }

  void handleReceivedData(Uint8List data) {
    responseController.add(data);
  }

  Future<void> getSerialNumber() async {
    try {
      deviceSerialNum = await platformMain.invokeMethod('readDeviceInfo');
    } catch (e) {
      print('Error calling native method: $e');
    }
  }

  Future<void> checkPrePayment({ApiService? apiServiceFromAuth}) async {
    _profferSalePro = ProfferSalePro(
        profferSaleRepo: ProfferSaleRepo(apiService: apiServiceFromAuth ?? apiService));
    bool isPayment = false;
    var liters = storage.read('liters');
    print("liters in checkprePayment $liters");
    var cardId = storage.read(
      'cardId',
    );
    var productId = storage.read(
      'productId',
    );
    var sessionId = storage.read(
      'sessionId',
    );
    var cityId = storage.read(
      'cityId',
    );
    var localSerial = storage.read(
      'localSerial',
    );
    int counter = 2;

    try {
      if (liters != null) {
        DioExceptions.showErrorMessage = false;
        while (!isPayment) {
          await Future.delayed(const Duration(seconds: 8));
          parameters params = {
            'dev_sn': deviceSerialNum,
            'app_version': appVersion,
            'session_id': sessionId,
            'card_sn': cardId,
            'product_id': productId,
            'quantity': liters,
            'plate_number': '12345',
            'city_id': cityId,
            'counter': counter,
            'local_serial': localSerial ?? DateTime.now().toString(),
          };
          params.addAll(params);
          profferSale = await _profferSalePro.profferSale(params);
          if (profferSale != null) {
            Alerts.showSnackBar("تم خصم $liters من الرصيد ");
            print("profferSale $profferSale");
            isPayment = true;
            isServerConnected = true;
          }
          counter++;
        }
      }
      if (isPayment) {
        storage.write('cardId', null);
        storage.write('liters', null);
        storage.write('productId', null);
        storage.write('sessionId', null);
        storage.write('cityId', null);
        storage.write('localSerial', null);
        DioExceptions.showErrorMessage = true;
      }
    } catch (e) {
      print("Error in checkPrePayment");
    }
  }

  Future<bool> setDateAndTime() async {
    bool isSet = false;
    try {
      if (dataDetails != null) {
        DateTime dateTime = DateTime.parse(dataDetails!.svTm!);
        String formattedDate = DateFormat('yyyyMMddHHmmss').format(dateTime);
        isSet = await platformMain.invokeMethod('setDateTime', formattedDate);
      }
    } catch (e) {
      print("error in setDateTime ${e.toString()}");
    }
    return isSet;
  }

  Future<AppService> init() async {
    try {
      await GetStorage.init();
      storage = GetStorage();
      subscriptionConnectivityResult = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) async {
        if (result.contains(ConnectivityResult.wifi)) {
          isRouterConnected.value = true;
          if (storage.read("pumpIp") != null &&
              storage.read("pumpPort") != null) {
            await connect(
                pumpIp: storage.read("pumpIp"),
                pumpPort: int.parse(storage.read("pumpPort")));
          }
          await listenToSocket();
          if (storage.read("ip") != null && storage.read("port") != null) {
            await initializeDataDetails(
                    ip: storage.read("ip"), port: storage.read("port"))
                .then((onValue) {});
          }
        } else {
          isRouterConnected.value = false;
          stopSocketListening();
        }
      });
      if (storage.read("pumpState") != null) {
        pumpState = storage.read("pumpState");
      }
      await getSerialNumber();
      print("ip server ${storage.read("ip")}");
    } catch (e) {
      print("Error in init ${e.toString()}");
    }
    return this;
  }

  @override
  void onClose() {
    socket.destroy();
    subscription?.cancel();
    responseController.close();
    subscriptionConnectivityResult?.cancel();
    super.onClose();
  }

  set isServerConnected(bool isServerConnected) =>
      _isServerConnected.value = isServerConnected;
  bool get isServerConnected => _isServerConnected.value;
  Future<bool> checkConnectivity() async =>
      await connectivityController.checkNetworkConnection();
  Future<void> initialize() async {
    await Get.putAsync(() => AppService().init());
  }
}

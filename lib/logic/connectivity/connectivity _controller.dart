import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConnectivityController extends GetxController {

   late List<ConnectivityResult>  connectivityResult  ;
   late StreamSubscription<List<ConnectivityResult>> subscription;
   Rx<bool> isRouterConnected = false.obs;

Future<bool> checkNetworkConnection() async {
    connectivityResult = await (Connectivity().checkConnectivity());

    return (connectivityResult.contains(ConnectivityResult.wifi)  || connectivityResult.contains( ConnectivityResult.mobile) );
  }
}

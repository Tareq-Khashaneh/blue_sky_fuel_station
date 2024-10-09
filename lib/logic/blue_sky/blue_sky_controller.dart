import 'dart:async';
import 'dart:typed_data';

import 'package:blue_sky_station/helpers/blue_sky_helper.dart';
import 'package:get/get.dart';

import '../socket_managing/socket_managing_controller.dart';
import 'package:xor_dart/xor_dart.dart';

class BlueSkyController extends GetxController {
  final SocketManagingController controller = Get.find();
  late Map<String, double>? fuelingData;

  //BlueSky
  Future<Map<String, int>> readDispenserStatus() async {
     Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xD5, 0x00]);
     int content;
     Map<String, int> status = {};
     msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
     print("message $msg");
     await controller.sendRequest(msg);
     StreamSubscription
      subscription = controller.getResponseStream().listen(
             (response) {
           print("response $response");
           if (response[0] != 0XF5) {
             print("Frame response error");
             status = {};
             return;
           }
           if (response[1] != 0x01) {
             print("hosepie number error");
             status = {};
             return;
           }

           if (response[2] != 0XA3) {
             print("response length error dispenser status");
             status = {};
             return;
           }
           content = response[3];
           if (BlueSkyHelper.xorCheckByte(response: response)) {
             int bit0 = (content >> 1) & 1;
             if (bit0 == 0) {
               print("NO ERROR");
               status!['error'] = 0;
             } else if (bit0 == 1) {
               print("ERROR");
               status!['error'] = 1;
             }
             int bit1 = (content >> 3) & 1;
             if (bit1 == 0) {
               print("NOT Controlled");
               status!['control'] = 0;
             } else if (bit1 == 1) {
               print("Controlled");
               status!['control'] = 1;
             }
             int bit5 = (content >> 5) & 1;
             if (bit5 == 0) {
               // print("NO FUELING");
               status!['fueling'] = 0;
             } else if (bit5 == 1) {
               // print("FUELING");
               status!['fueling'] = 1;
             }
             int bit7 = (content >> 7) & 1;
             if (bit7 == 0) {
               // print("NOZZLE UP");
               status!['nozzle'] = 1;
             } else if (bit7 == 1) {
               // print("NOZZLE DOWN");
               status!['nozzle'] = 0;
             }
           } else {
             status = {};
             return;
           }
         },
         onError: (error) {
           print('Error in response stream subscription: ${error.toString()}');
           status = {};
           return;
         }
     );
     await Future.delayed(const Duration(milliseconds: 500));
     subscription.cancel();
     return  status;
  }

  Future<Map<String, double>> readFuelingData() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xD9, 0x00]);
    int content;
    Map<String, double> data = {};
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    await controller.sendRequest(msg);

    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          data = {};
          return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          data = {};
          return;
        }

        if (response[2] != 0XAA) {
          print("response length error");
          data = {};
          return;
        }
        if (BlueSkyHelper.xorCheckByte(response: response)) {
          content = response[3];
          print("bit length ${content.bitLength}");
          int byte1 = ((content >> 4) & 15) * 10 + (content & 15);
          print("byte1 $byte1");
          content = response[4];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          content = response[5];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          content = response[6];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          double volume = byte1 / 100;
          print("volume $volume");
          data!['volume'] = volume;
          byte1 = 0;
          content = response[7];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          content = response[8];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          content = response[9];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          content = response[10];
          byte1 = (byte1 * 100) + ((content >> 4) & 15) * 10 + (content & 15);
          double price = byte1 / 10;
          print("price $price");
          data!['price'] = price;
        } else {
          print("Error in checkByte");
          data = {};
          return;
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
        data = {};
        return;
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
    return data;
  }

  void modifyUnitPrice({required double price}) async {
    Uint8List contentRequest =
        BlueSkyHelper.calculateContent(value: price, bytes: 3);
    //message
    Uint8List msg =
        Uint8List.fromList([0XF5, 0X01, 0XA5] + contentRequest + [0xB2, 0x00]);
    msg[7] = BlueSkyHelper.calculateCheckByte(message: msg);
    //request
    await controller.sendRequest(msg);
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          // result = null;
          // return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          // result = null;
          // return;
        }

        if (response[2] != 0XA3) {
          print("response length error");
          // result = null;
          // return;
        }

        if (BlueSkyHelper.xorCheckByte(response: response)) {
          if (response[3] == 0x59) {
            print("Success");
          } else if (response[3] == 0x4E) {
            print("Fail");
          }
        } else {
          print("Error in checkByte");
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
  }

  Future<bool> writePresetVolume({required double volume}) async {
    // Convert double to string with 2 decimal places and remove the decimal point
    volume *= 100;
    Uint8List contentRequest =
        BlueSkyHelper.calculateContent(value: volume, bytes: 4);
    print("content $contentRequest");
    bool result = false;
    //message
    Uint8List msg =
        Uint8List.fromList([0XF5, 0X01, 0XA6] + contentRequest + [0xB9, 0x00]);
    msg[8] = BlueSkyHelper.calculateCheckByte(message: msg);
    //request
    await controller.sendRequest(msg);
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          result = false;
          return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          result = false;
          return;
        }

        if (response[2] != 0XA2) {
          print("response length error");
          result = false;
          return;
        }

        if (BlueSkyHelper.xorCheckByte(response: response)) {
          result = true;
          return;
        } else {
          print("Error in checkByte");
          result = false;
          return;
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
        result = false;
        return;
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
    return result;
  }

  Future<Map<String,double>> readGeneralTotalizer() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xC5, 0x00]);
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    Map<String,double> totalizer = {};
    //request
    print("checkbyte before request ${msg[4]}");
    print("message $msg");
    await controller.sendRequest(msg);
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
         totalizer = {};
          return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          totalizer = {};
          return;
        }

        if (response[2] != 0XAE) {
          print("response length error");
          totalizer = {};
          return;
        }
        if (BlueSkyHelper.xorCheckByte(response: response)) {
          Uint8List volumeBCD =
              response.sublist(3, 9); // Bytes for volume (index 3 to 8)
          Uint8List amountBCD = response.sublist(9, 15);
          double volume = BlueSkyHelper.bcdToDouble(volumeBCD, 6);
          double amount = BlueSkyHelper.bcdToDouble(amountBCD, 6);
          volume /= 100;
          amount /= 10;
          print("Volume: $volume");
          print("Amount: $amount");
          totalizer = {'volume' : volume, 'amount' : amount};
          return;
        } else {
          print("Error in checkByte");
          totalizer = {};
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
    return totalizer;
  }

  Future<bool> powerOn() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xC3, 0x00]);
    bool result = false;
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    //request
    await controller.sendRequest(msg);
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          result = false;
          return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          result = false;
          return;
        }

        if (response[2] != 0XA3) {
          print("response length error");
          result = false;
          return;
        }

        if (BlueSkyHelper.xorCheckByte(response: response)) {
          if (response[3] == 0x59) {
            print("Success");
            result = true;
          } else if (response[3] == 0x4E) {
            print("Fail");
            result = false;
          }
        } else {
          print("Error in checkByte");
          result = false;
          return;
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
    return result;
  }

  Future<bool> powerOFF() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xCA, 0x00]);
    bool result = false;
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    print("message power off $msg");
    //request
    await controller.sendRequest(msg);
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          result = false;
          return;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          result = false;
          return;
        }

        if (response[2] != 0xA2) {
          print("response length error");
          result = false;
          return;
        }

        if (BlueSkyHelper.xorCheckByte(response: response)) {
          print("power off Success");
          result = true;
          return;
        } else {
          print("Error in checkByte");
          result = false;
          return;
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
    return result;
  }

  Future<bool> askForControl() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0X01, 0XA2, 0xE5, 0x00]);
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    //request
    await controller.sendRequest(msg);
    bool result = false;
    //response
    StreamSubscription subscription = controller.getResponseStream().listen(
      (response) {
        print("resposnse in blueSky $response");
        if (response[0] != 0XF5) {
          print("Frame response error");
          result = false;
        }
        if (response[1] != 0x01) {
          print("hosepie number error");
          result = false;
        }

        if (response[2] != 0XA2) {
          print("response length error");
          result = false;
        }

        if (!BlueSkyHelper.xorCheckByte(response: response)) {
          print("Error in checkByte");
          result = false;
        } else {
          result = true;
        }
      },
      onError: (error) {
        print('Error in response stream subscription: $error');
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();

    return result;
  }

  void readUnitPrice() async {
    Uint8List msg = Uint8List.fromList([0XF5, 0x01, 0XA2, 0xB6, 0x00]);
    msg[4] = BlueSkyHelper.calculateCheckByte(message: msg);
    print("msg $msg");
    await controller.sendRequest(msg);
    StreamSubscription subscription =
        controller.getResponseStream().listen((response) {
      print("resposnse in blueSky $response");
      if (response[0] != 0XF5) {
        print("Frame response error");
        // result = null;
        // return;
      }
      if (response[1] != 0x01) {
        print("hosepie number error");
        // result = null;
        // return;
      }

      if (response[2] != 0XA5) {
        print("response length error");
        // result = null;
        // return;
      }
      if (BlueSkyHelper.xorCheckByte(response: response)) {
        Uint8List contentResponse = response.sublist(3, 6);
        double unitPrice = BlueSkyHelper.bcdToDouble(contentResponse, 3);
        print("unitPrice $unitPrice");
      } else {
        print("Error in checkByte");
      }
    }, onError: (error) {
      print('Error in response stream subscription: $error');
    });
    await Future.delayed(const Duration(milliseconds: 500));
    subscription.cancel();
  }

  // Future<void> checkConnectionToPump() async {
  //   // isRunning = true;
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     Map<String,int> status = await readDispenserStatus();
  //     print("Status in home controller $status");
  //     if (status.isEmpty) {
  //       print("status isEmpty home controller");
  //     } else {
  //       if (status!['control'] == 0) {
  //         await askForControl();
  //       } else if (status!['control'] == 1) {
  //         // isPumpControlled = true;
  //         print("pump is Control");
  //       } if (status['nozzle'] == 1){
  //         isNozzleLift = true;
  //       }else if(status['nozzle'] == 0){
  //         isNozzleLift = false;
  //       }
  //     }
  //     update();
  //   }
  //   print("closed isRunning in home controller $isRunning");
  // }
}

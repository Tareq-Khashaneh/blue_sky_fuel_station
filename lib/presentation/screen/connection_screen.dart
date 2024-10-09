
import 'dart:typed_data';

import 'package:flip_panel_plus/flip_panel_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/blue_sky/blue_sky_controller.dart';
import '../../logic/socket_managing/socket_managing_controller.dart';

class ConnectionScreen extends StatelessWidget {
  ConnectionScreen({super.key});

  final SocketManagingController socketManagingController =
      Get.put(SocketManagingController());
  final BlueSkyController blueSkyController = Get.put(BlueSkyController());

  @override
  Widget build(BuildContext context) {
    List<TextButton> buttons = [
      TextButton(onPressed: () async {
        // blueSkyController.startUp();
      }, child: const Text("Start UP")),
      TextButton(onPressed: () async {
        blueSkyController.powerOn();
      }, child: Text("Power on ")),
      TextButton(onPressed: () async {
        blueSkyController.powerOFF();
      }, child: Text("Power off ")),
      TextButton(onPressed: () async {
        blueSkyController.readFuelingData();
      }, child: Text("Read Totalizer ")),
      TextButton(onPressed: () async {
        blueSkyController.readGeneralTotalizer();
      }, child: Text("Read general Totalizer ")),
      TextButton(
          onPressed: () async {
            blueSkyController.modifyUnitPrice(price: 10460.0);
          },
          child: Text("sendUnitPrice")),
      TextButton(
          onPressed: () async {
            blueSkyController.askForControl();
          },
          child: Text("ask For Control")),
      TextButton(
          onPressed: () async {
            blueSkyController.readUnitPrice();
          },
          child: Text("Read unit price")),
      TextButton(onPressed: () async {
        blueSkyController.writePresetVolume(volume: 0.0);
      }, child: Text("send Limit ")),
      TextButton(
          onPressed: () async {
            // Uint8List msg =
            // Uint8List.fromList([0xF5,0x01,0xA2,0xE5,0x33]);
            // await socketManagingController.sendRequest(msg);
            // int i = 0;
            // while(i == 0){
            // blueSkyController.askForControl();
              await Future.delayed(const Duration(seconds: 1));
              blueSkyController.readDispenserStatus();
            // }
          },
          child: Text("readStatus ")),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connection"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              children: buttons,
            )
        ),
      ),
    );
  }
}

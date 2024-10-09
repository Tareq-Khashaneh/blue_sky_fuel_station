import 'package:blue_sky_station/presentation/widgets/error_message_card.dart';
import 'package:flip_panel_plus/flip_panel_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/routes.dart';
import '../../logic/filing/filing_controller.dart';
import '../widgets/custom_card.dart';

class FilingScreen extends StatelessWidget {
  FilingScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final FilingController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     controller.appService.dataDetails?.facilityName ?? '',
            //     style: Theme.of(context)
            //         .textTheme
            //         .headlineMedium!
            //         .copyWith(color: AppColors.kWhiteColor),
            //   ),
            //   backgroundColor: AppColors.kMainColorGreen,
            // ),
            body: Obx(() => !controller.appService.isServerConnected
                ? const ErrorMessageCard(message: "لايوجد اتصال مع المخدم")
                : Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
                    child: controller.appService.pumpState
                        ? GetBuilder<FilingController>(builder: (controller) {
                            if (controller.isRouterConnected) {
                              if (controller.isNozzleLift) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "ليترات".padRight(5),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          Flexible(
                                            child: FlipPanelPlus<String>.stream(
                                              itemStream: Stream.periodic(
                                                  const Duration(
                                                      milliseconds: 100),
                                                  (liters) => controller.liters
                                                      .toStringAsFixed(2)),
                                              itemBuilder: (context, value) =>
                                                  Container(
                                                color: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0),
                                                child: Text(
                                                  '$value',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 50.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              initValue: 0.00.toString(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            " السعر",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          Flexible(
                                            child: FlipPanelPlus<String>.stream(
                                              itemStream: Stream.periodic(
                                                  const Duration(
                                                      milliseconds: 300),
                                                  (sales) => controller.sales
                                                      .toStringAsFixed(0)),
                                              itemBuilder: (context, value) =>
                                                  Container(
                                                color: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0),
                                                child: Text(
                                                  '$value',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 50.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              initValue: 0.00.toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Lottie.asset("assets/images/filing.json",
                                        width: 350, fit: BoxFit.cover)
                                  ],
                                );
                              }
                              else if (controller.timeOutNozzleUp) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("يرجى إرجاع الفرد",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                      SizedBox(
                                        height: Dimensions.height03,
                                      ),
                                      Lottie.asset(
                                          'assets/images/hosepipe.json',
                                          width: 200,
                                          fit: BoxFit.cover),
                                    ],
                                  ),
                                );
                              }
                              else {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "اسحب الفرد",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      SizedBox(
                                        height: Dimensions.height03,
                                      ),
                                      Lottie.asset(
                                          'assets/images/hosepipe.json',
                                          width: 200,
                                          fit: BoxFit.cover),
                                    ],
                                  ),
                                );
                              }
                            }
                            else {
                              const ErrorMessageCard(
                                message: "لايوجد اتصال",
                              );
                            }
                            return const SizedBox();
                          })
                        : CustomCard(
                            height: Dimensions.screenHeight * 0.8,
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 2),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      " رصيدك ${controller.cardQuota?.maxQuantity ?? ''} ليتر من البنزين\n  ما الكمية التي تريد تعبئتها ؟",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(
                                          hintText: "الكمية المطلوبة",
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: AppColors
                                                      .kMainColorGreenLight)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: AppColors
                                                      .kMainColorGreenLight)),
                                        ),
                                        onChanged: (value) {
                                          controller.orderLiters = value;
                                        },
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return "رجاء, أدخل الكمية";
                                            }
                                            if (value.isNotEmpty) {
                                              double valueDouble =
                                                  double.parse(value);
                                              print("val $valueDouble");
                                              if (valueDouble >
                                                  controller
                                                      .cardQuota!.maxQuantity) {
                                                return "الكمية أكبر من الرصيد";
                                              } else if (valueDouble <= 0) {
                                                return "الكمية خاطئة";
                                              }
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          controller
                                              .payment(
                                                  orderLiters: double.parse(
                                                      controller.orderLiters))
                                              .then((onValue) async {
                                            if (onValue) {
                                              controller
                                                  .printInvoice(
                                                      liters: double.parse(
                                                          controller
                                                              .orderLiters),
                                                      sales: (controller
                                                              .cardQuota!
                                                              .slices[1]
                                                              .price) *
                                                          double.parse(
                                                              controller
                                                                  .orderLiters))
                                                  .then((onValue) =>
                                                      Get.offNamed(AppRoutes
                                                          .homeScreenRoute));
                                            } else {
                                              controller.appService
                                                  .isServerConnected = false;
                                              controller.appService.storage
                                                  .write('liters',
                                                      controller.liters);
                                              await controller.appService
                                                  .checkPrePayment()
                                                  .then((onValue) async =>
                                                      await controller
                                                          .printInvoice(
                                                              liters: controller
                                                                  .liters,
                                                              sales: controller
                                                                  .sales)
                                                          .then((onValue) => Get
                                                              .offNamed(AppRoutes
                                                                  .homeScreenRoute)));
                                            }
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.kMainColorGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.screenHeight * 0.04),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.contentPadding2),
                                        side: const BorderSide(
                                            width: 0, color: Colors.white),
                                        elevation: 5,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 24.0),
                                        child: Text(
                                          "تعبئة",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: AppColors
                                                      .kMainColorGreenLighter),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )))));
  }
}

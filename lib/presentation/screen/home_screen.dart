import 'package:blue_sky_station/presentation/widgets/circular_loading.dart';
import 'package:blue_sky_station/presentation/widgets/error_message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/routes.dart';
import '../../core/enums/enum_state.dart';
import '../../logic/home/home_controller.dart';
import '../widgets/bottom_nav_bar_container.dart';
import '../widgets/drawer_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: GetBuilder<HomeController>(builder: (_) {
              if (!_.isPumpOff) {
                if (_.status['control'] == 1 && !_.isNozzleLift ||
                    !_.appService.pumpState) {
                  return _.isServerLoading
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BottomNavBarContainer(
                                fontSize: Get.size.height * 0.03,
                                width: Get.size.width * 0.4,
                                color: controller.isLoading
                                    ? AppColors.kMainColorGreenLighter
                                    : null,
                                text: 'امسح البطاقة',
                                onTap: !controller.isLoading
                                    ? () async {
                                        if (await controller.readCard()) {
                                          if (await controller.getCardQuota()) {
                                            Get.offNamed(
                                                AppRoutes.FillingScreenRoute,
                                                arguments: {
                                                  'cardQuota':
                                                      controller.cardQuota,
                                                  'cardId': controller.cardId
                                                });
                                          }
                                        }
                                      }
                                    : null),
                            BottomNavBarContainer(
                                fontColor: !controller.isLoading
                                    ? AppColors.kTextColorBlack26
                                    : AppColors.kWhiteColor,
                                fontSize: Get.size.height * 0.03,
                                width: Get.size.width * 0.4,
                                color: !controller.isLoading
                                    ? AppColors.kMainColorGreenLighter
                                    : null,
                                text: 'إلغاء',
                                onTap: controller.isLoading
                                    ? () async {
                                        controller.stopRead();
                                      }
                                    : null)
                          ],
                        );
                }
              }
              return const SizedBox();
            })),
        drawer: const DrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColors.kWhiteColor, // Change drawer icon color here
          ),
          title: Text(
            controller.appService.dataDetails?.facilityName ?? '',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.kWhiteColor),
          ),
          backgroundColor: AppColors.kMainColorGreen,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(AppRoutes.loginAdminRoute),
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.kWhiteColor,
                )),
          ],
        ),
        body: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GetBuilder<HomeController>(builder: (controller) {
                  if (!controller.isServerLoading) {
                    if (controller.appService.pumpState) {
                      if (!controller.isPumpOff) {
                        return controller.status['control'] == 0
                            ? const ErrorMessageCard(
                                message: "لايوجد تحكم بالمضخة")
                            : controller.isNozzleLift
                                ? const ErrorMessageCard(
                                    message: "يرجى مسح البطاقة قبل رفع الفرد")
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        elevation: 4,
                                        color: AppColors.kMainColorGreen
                                            .withOpacity(0.9),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.local_gas_station,
                                              color: AppColors.kWhiteColor,
                                              size: Dimensions.screenHeight *
                                                  0.08,
                                            ),
                                            title: Text(
                                                controller.currentUser?.name ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors
                                                            .kWhiteColor,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            trailing: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.size.height * 0.03,
                                      ),
                                      GetBuilder<HomeController>(builder: (_) {
                                        return _.cardReadStatus ==
                                                EnumStatus.loading
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50.0),
                                                child: Center(
                                                  child: Lottie.asset(
                                                      'assets/images/card_scan.json',
                                                      width: 500,
                                                      fit: BoxFit.cover),
                                                ),
                                              )
                                            : const SizedBox();
                                        // : const Column(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       TitleWidget(
                                        //         title: 'الجلسات السابقة',
                                        //         fontSize: 30,
                                        //       ),
                                        //       SizedBox(
                                        //         height: 12,
                                        //       ),
                                        // SizedBox(
                                        //   height: 275,
                                        //   child: ListView.builder(
                                        //       itemCount: controller.sessions.length,
                                        //       itemBuilder: (context, index) {
                                        //         return SessionCard(
                                        //             sessionInfo: controller
                                        //                 .sessions[index].sessionInfo,
                                        //             onTap: () {
                                        //               controller.sessionController
                                        //                   .getSession(int.parse(controller
                                        //                   .sessions[index].sessionId));
                                        //               Get.toNamed(AppRoutes.sessionRoute);
                                        //             });
                                        //       }),
                                        // ),
                                        //   ],
                                        // );
                                      })
                                    ],
                                  );
                      } else {
                        return const ErrorMessageCard(
                            message: "المضخة خارج الخدمة");
                      }
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            color: AppColors.kMainColorGreen.withOpacity(0.9),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_gas_station,
                                  color: AppColors.kWhiteColor,
                                  size: Dimensions.screenHeight * 0.08,
                                ),
                                title: Text(controller.currentUser?.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.kWhiteColor,
                                            fontWeight: FontWeight.bold)),
                                trailing: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.size.height * 0.03,
                          ),
                          GetBuilder<HomeController>(builder: (_) {
                            return _.cardReadStatus == EnumStatus.loading
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: Center(
                                      child: Lottie.asset(
                                          'assets/images/card_scan.json',
                                          width: 500,
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : const SizedBox();
                            // : const Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       TitleWidget(
                            //         title: 'الجلسات السابقة',
                            //         fontSize: 30,
                            //       ),
                            //       SizedBox(
                            //         height: 12,
                            //       ),
                            // SizedBox(
                            //   height: 275,
                            //   child: ListView.builder(
                            //       itemCount: controller.sessions.length,
                            //       itemBuilder: (context, index) {
                            //         return SessionCard(
                            //             sessionInfo: controller
                            //                 .sessions[index].sessionInfo,
                            //             onTap: () {
                            //               controller.sessionController
                            //                   .getSession(int.parse(controller
                            //                   .sessions[index].sessionId));
                            //               Get.toNamed(AppRoutes.sessionRoute);
                            //             });
                            //       }),
                            // ),
                            //   ],
                            // );
                          })
                        ],
                      );
                    }
                  } else {
                    return const CircularLoading();
                  }
                }))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/routes.dart';
import '../../logic/configurations/pump_conf/config_pump_controller.dart';
import '../widgets/circular_loading.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class ConfigurationPumpScreen extends StatelessWidget {
  ConfigurationPumpScreen({super.key});
  final ConfigPumpController controller = Get.put(ConfigPumpController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'ضبط المضخة',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColors.kWhiteColor,fontSize: 28),
            ),
            backgroundColor: AppColors.kMainColorGreen,
          ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
        child: GetBuilder<ConfigPumpController>(builder: (_) {
          return controller.isLoading
              ? const CircularLoading()
              : SingleChildScrollView(
                child: Form(
                  key: controller.serverFormKey,
                  child: Column(
                    children: [
                      CustomField(
                        controller: controller.pumpIpController,
                        label: "معرف المضخة",
                        filledColor: AppColors.kSecondColorOrange,
                        iconColor: AppColors.kWhiteColor,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "القيمة فارغة";
                            } else if (!value.isIPv4 || !value.isIPv4) {
                              return " معرف المخدم ليس صحيحا";
                            }
                          }
                          return null;
                        },
                        prefixIcon: Icons.wifi,
                      ),
                      SizedBox(
                        height: Dimensions.height01,
                      ),
                      CustomField(
                        controller: controller.pumpPortController,
                        label: "منفذ المضخة",
                        filledColor: AppColors.kSecondColorOrange,
                        iconColor: AppColors.kWhiteColor,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[,.-]')),
                        ],
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "الحقل فارغ";
                            }
                          }
                          return null;
                        },
                        prefixIcon: Icons.numbers,
                      ),
                      SizedBox(
                        height: Dimensions.height01,
                      ),
                      CustomField(
                        controller: controller.pumpIdController,
                        label: "ID",
                        filledColor: AppColors.kSecondColorOrange,
                        iconColor: AppColors.kWhiteColor,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[,.-]')),
                        ],
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "الحقل فارغ";
                            }
                          }
                          return null;
                        },
                        prefixIcon: Icons.numbers,
                      ),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.1,
                      ),
                      CustomButton(
                          onPressed: () async {
                            if (controller.serverFormKey.currentState!
                                .validate()) {
                              controller.connectToPump().then((value) {
                                if (value) {
                                  Get.offAllNamed(
                                      AppRoutes.loginScreenRoute);
                                }
                              });
                            }
                          },
                          label: "اتصال"),
                    ],
                  ),
                ),
              );
        }),
      ),
    ));
  }
}

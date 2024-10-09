import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/routes.dart';
import '../../logic/configurations/server_conf/config_server_controller.dart';
import '../widgets/circular_loading.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class ConfigurationServerScreen extends StatelessWidget {
  ConfigurationServerScreen({super.key});
  final serverFormKey = GlobalKey<FormState>();
  final ConfigServerController  controller = Get.put(ConfigServerController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                'ضبط المخدم',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: AppColors.kWhiteColor,fontSize: 28),
                ),
                backgroundColor: AppColors.kMainColorGreen,
              ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
        child: GetBuilder<ConfigServerController>(builder: (_) {
          return controller.isLoading
              ? const CircularLoading()
              : Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: serverFormKey,
                      child: Column(
                        children: [
                          CustomField(
                            controller: controller.serverIpController,
                            label: "معرف المخدم",
                            filledColor: AppColors.kSecondColorOrange,
                            iconColor: AppColors.kWhiteColor,
                            keyboardType: TextInputType.number,
                            errorColor: Colors.red,
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return "الحقل فارغ, يرجى إدخال قيمة";
                                } else if (!value.isIPv4 || !value.isIPv4) {
                                  return " معرف المخدم ليس صحيحا";
                                }
                              }
                              return null;
                            },
                            prefixIcon: Icons.wifi,
                          ),
                          SizedBox(
                            height: Dimensions.height03,
                          ),
                          CustomField(
                            controller: controller.portController,
                            label: "منفذ الخادم",
                            errorColor: Colors.red,
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
                                if (serverFormKey.currentState!.validate()) {
                                  controller
                                      .checkConnectToServer()
                                      .then((value) {
                                    if (value) {
                                      Get.offAllNamed(AppRoutes.loginScreenRoute);
                                      Alerts.showSnackBar("نجح الاتصال",
                                          isFail: false);
                                    }
                                  });
                                }
                              },
                              label: "اتصال"),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    ));
  }
}

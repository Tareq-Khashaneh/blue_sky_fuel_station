import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/routes.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        appBar: buildAppBar(
          title: "ضبط الاتصال",
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
          child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        fontSize: 16,
                          onPressed: () async {
                            Get.toNamed(
                                AppRoutes.configurationSystemRoute);
                          },
                          label: "ضبط المنظومة"),
                      CustomButton(
                          fontSize: 16,
                          onPressed: () async {
                            Get.toNamed(
                                AppRoutes.configurationPumpRoute);
                          },
                          label: "ضبط المضخة"),
                      CustomButton(

                          fontSize: 16,
                          onPressed: () async {
                            Get.toNamed(
                                AppRoutes.configurationServerRoute);
                          },
                          label: "ضبط المخدم"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

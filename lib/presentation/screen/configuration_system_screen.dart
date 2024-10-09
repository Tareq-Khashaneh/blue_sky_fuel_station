import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/routes.dart';
import '../../logic/configurations/sys_conf/config_sys_controller.dart';
import '../widgets/custom_button.dart';

class ConfigurationSystemScreen extends StatelessWidget {
  ConfigurationSystemScreen({super.key});
  final ConfigSysController controller = Get.put(ConfigSysController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'ضبط المنظومة',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: AppColors.kWhiteColor),
              ),
              backgroundColor: AppColors.kMainColorGreen,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetBuilder<ConfigSysController>(builder: (controller) {
                    return SwitchListTile(
                        title: Text(
                          "تشغيل المضخة",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                        tileColor: AppColors.kMainColorGreenLighter,
                        activeColor: AppColors.kSecondColorOrange,
                        inactiveTrackColor: AppColors.kMainColorGreenLighter,
                        value: controller.appService.pumpState,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        onChanged: controller.switchPumpState);
                  }),
                  CustomButton(
                      onPressed: () =>
                          Get.offAllNamed(AppRoutes.loginScreenRoute),
                      label: "تأكيد")
                ],
              ),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/routes.dart';
import '../../logic/auth/admin_auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/image_container.dart';

class LoginAdminScreen extends GetView<AdminAuthController> {
  const LoginAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: AppColors.kMainColorGreen,
          body: SafeArea(
            child: Stack(
              children: [
                // Image
                ImageContainer(image: "assets/images/pump.jpg"),
                ListView(
                  children: [
                    // Login Fields Container
                    Padding(
                      padding:
                          EdgeInsets.only(top: Dimensions.screenHeight * 0.4),
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        height: Get.size.height * 0.58,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Flexible(child: IconButton(onPressed: () => Get.toNamed(AppRoutes.languageRoute), icon: const Icon(Icons.language_outlined)))
                            Align(
                              alignment: Alignment.center,
                              child: Text("أهلا بك أدمن",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontSize: 30,
                                          color: AppColors.kMainColorGreen,
                                          fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: Get.size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Get.size.height * 0.02,
                              ),
                              child: CustomField(
                                controller: controller.password,
                                label: "كلمة المرور",
                                filledColor: AppColors.kSecondColorOrange,
                                isSecure: true,
                                iconColor: AppColors.kWhiteColor,
                                prefixIcon: Icons.lock_outline,
                              ),
                            ),
                            SizedBox(
                              height: Get.size.height * 0.04,
                            ),
                            // Login Button
                            Padding(
                                padding: EdgeInsets.only(
                                    top: Dimensions.screenHeight * 0.08,
                                    bottom: Dimensions.screenHeight * 0.02),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                      fontSize: 18,
                                      onPressed: () {
                                        if (controller.isAdmin()) {
                                          Get.offNamed(AppRoutes.settingsRoute);
                                        }
                                        controller.password.clear();
                                      },
                                      label: "تسجيل الدخول"),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

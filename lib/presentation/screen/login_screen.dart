import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/routes.dart';
import '../../logic/auth/auth_controller.dart';
import '../widgets/circular_loading.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/image_container.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          ImageContainer(
            image: "assets/images/pump.jpg",
          ),
          Positioned(
            left: 2,
            top: 1,
            child: Row(
              children: [
                Text(
                  controller.appService.pumpState
                      ? "المضخة مفعلة"
                      : "المضخة غير مفعلة",
                  style: TextStyle(color: AppColors.kWhiteColor, fontSize: 14),
                ),
                IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.loginAdminRoute),
                    icon: Icon(Icons.settings,
                        color: AppColors.kWhiteColor,
                        size: Dimensions.screenHeight * 0.06)),
              ],
            ),
          ),
          Positioned.fill(
              child: Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.padding05,
                    right: Dimensions.padding05,
                    top: Dimensions.screenHeight * 0.08,
                    bottom: Dimensions.screenHeight * 0.02),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تسجيل الدخول",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: AppColors.kWhiteColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Dimensions.screenHeight * 0.06,
                        ),
                        Text(
                          'اسم المستخدم',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: AppColors.kWhiteColor,
                                  fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: Dimensions.screenHeight * 0.009,
                        ),
                        GetBuilder<AuthController>(
                          init: AuthController(),
                          builder: (controller) => DropdownButtonFormField(
                              decoration: InputDecoration(
                                errorStyle:
                                    TextStyle(color: AppColors.kWhiteColor),
                                prefixIcon: const Icon(
                                  Icons.local_gas_station_rounded,
                                  color: AppColors.kMainColorGreenLighter,
                                ),
                                hintText: "الاسم",
                                filled: true,
                                fillColor:
                                    AppColors.kWhiteColor.withOpacity(0.5),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.screenHeight * 0.05)),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.kWhiteColor
                                          .withOpacity(0.4),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimensions.radius05))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimensions.radius05)),
                                    borderSide: BorderSide.none),
                              ),
                              items: controller.appService.dataDetails?.users
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u.name)))
                                  .toList(),
                              onChanged: (value) {
                                controller.currentUser = value;
                              },
                              validator: (value) {
                                if (controller.currentUser == null) {
                                  return "يرجي إدخال اسم المستخدم";
                                }
                                return null;
                              }),
                        ),
                        SizedBox(
                          height: Dimensions.height01,
                        ),
                        CustomField(
                          label: "كلمة المرور",
                          labelColor: AppColors.kWhiteColor,
                          prefixIcon: Icons.lock_rounded,
                          onChange: (value) {
                            controller.password = value;
                          },
                          validator: (value) => controller.validate(value,
                              message: 'يرجى إدخال كلمة المرور'),
                        ),
                        SizedBox(
                          height: Dimensions.height01,
                        ),
                        SizedBox(
                          height: Dimensions.screenHeight * 0.08,
                        ),
                        GetBuilder<AuthController>(builder: (controller) {
                          return controller.isLoading
                              ? const CircularLoading()
                              : Align(
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                      onPressed: () async {
                                        if (await controller.login(
                                            formKey: formKey)) {
                                          Alerts.showDialogue(
                                            dialogType: DialogType.success,
                                            context: context,
                                            onPressYes: () => controller
                                                        .currentProduct !=
                                                    null
                                                ? Get.offAllNamed(
                                                    AppRoutes.homeScreenRoute)
                                                : null,
                                            dismissOnTouchOutside: false,
                                            body: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'اسم المنتج',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                          color: AppColors
                                                              .kTextColorBlack26,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  child:
                                                      DropdownButtonFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            errorStyle: const TextStyle(
                                                                color: AppColors
                                                                    .kWhiteColor),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.settings,
                                                              color: AppColors
                                                                  .kMainColorGreenLighter,
                                                            ),
                                                            hintText: "الاسم",
                                                            filled: true,
                                                            fillColor: AppColors
                                                                .kWhiteColor
                                                                .withOpacity(
                                                                    0.5),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    Dimensions
                                                                        .contentPadding044),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        Dimensions.screenHeight *
                                                                            0.05)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: AppColors
                                                                          .kWhiteColor
                                                                          .withOpacity(
                                                                              0.4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(Dimensions.radius05))),
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        Dimensions
                                                                            .radius05)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                          ),
                                                          items: controller
                                                              .appService
                                                              .dataDetails
                                                              ?.products
                                                              .map((p) =>
                                                                  DropdownMenuItem(
                                                                      value: p,
                                                                      child: Text(
                                                                          p.nameAr!)))
                                                              .toList(),
                                                          onChanged: (value) {
                                                            controller
                                                                    .currentProduct =
                                                                value;
                                                          },
                                                          validator: (value) {
                                                            if (controller
                                                                    .currentProduct ==
                                                                null) {
                                                              return "يرجي إدخال اسم المنتج";
                                                            }
                                                            return null;
                                                          }),
                                                ),
                                              ],
                                            ),
                                          ).show();
                                        }
                                      },
                                      label: "دخول"));
                        })
                      ],
                    ),
                  ),
                )),
          ))
        ],
      ),
    ));
  }
}

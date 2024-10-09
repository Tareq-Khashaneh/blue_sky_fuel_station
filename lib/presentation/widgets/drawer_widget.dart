import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/routes.dart';
import '../../logic/drawer/drawer_controller.dart';


class DrawerWidget extends GetView<DrawerGetxController> {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.kWhiteColor,

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/pump.jpg",
                    ),
                    fit: BoxFit.cover)),
            child: null,
          ),
          _buildListTile(
            icon: Icons.home_rounded,
            text: "الصفحة الرئيسية",
            onTap: () {
              Get.offNamed(AppRoutes.homeScreenRoute);
            },
          ),
          SizedBox(
            height: Dimensions.height01,
          ),
          const Divider(),
          _buildListTile(
            icon: Icons.logout_rounded,
            text: "تسجيل الخروج",
            onTap: () async{
              if(await  controller.logout()){

                Get.offAllNamed(AppRoutes.loginScreenRoute);
              }

            },
          ),
        ],
      ),
    );
  }
  _buildListTile(
          {required IconData icon,
          required String text,
          Function()? onTap,
          Widget? trailing}) =>
      Container(
          margin: const EdgeInsets.only(bottom: 7),
          child: ListTile(
              leading: Icon(
                icon,
              ),
              title: Text(
                text,
              ),
              trailing: trailing,
              onTap: onTap));
}

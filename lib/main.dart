import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/routes.dart';
import 'logic/getx_service/app_service.dart';
import 'logic/socket_managing/socket_managing_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          fontFamily: "Cairo",
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColors.kWhiteColor, fontSize: 28),
              backgroundColor: AppColors.kMainColorGreen,
            ),),
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
        initialBinding: SocketManagingBindings(),
        initialRoute: AppRoutes.loginScreenRoute,
        getPages: AppRoutes.pages
    );
  }
}

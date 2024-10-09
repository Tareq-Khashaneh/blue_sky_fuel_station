import 'package:blue_sky_station/logic/blue_sky/blue_sky_bindings.dart';
import 'package:get/get.dart';
import '../../logic/auth/auth_admin_bindings.dart';
import '../../logic/auth/auth_bindings.dart';
import '../../logic/drawer/drawer_bindings.dart';
import '../../logic/filing/filing_bindings.dart';
import '../../logic/home/home_bindings.dart';
import '../../presentation/screen/configuration_pump_screen.dart';
import '../../presentation/screen/configuration_server_screen.dart';
import '../../presentation/screen/configuration_system_screen.dart';
import '../../presentation/screen/filing_screen.dart';
import '../../presentation/screen/home_screen.dart';
import '../../presentation/screen/login_admin_screen.dart';
import '../../presentation/screen/login_screen.dart';
import '../../presentation/screen/settings_screen.dart';

abstract class AppRoutes {
  static String homeScreenRoute = '/home';
  static String filingScreenRoute = '/filing';
  static String loginScreenRoute = '/login';
  static String loginAdminRoute = '/login-admin';
  static const String settingsRoute = '/settings';
  static const String configurationSystemRoute = '/config-sys';
  static const String configurationPumpRoute = '/config-pump';
  static const String configurationServerRoute = '/config-server';
  static List<GetPage> pages = [
    GetPage(
      name: loginScreenRoute,
      page: () => LoginScreen(),
      binding: AuthBindings(),
    ),
    GetPage(name: filingScreenRoute, page: () => FilingScreen(), bindings: [
      BlueSkyBindings(),
      FilingBindings(),
    ]),
    GetPage(
        name: homeScreenRoute,
        page: () => const HomeScreen(),
        bindings: [BlueSkyBindings(),HomeBindings(), DrawerBindings()]),
    GetPage(
        name: loginAdminRoute,
        page: () => const LoginAdminScreen(),
        binding: AuthAdminBindings()),
    GetPage(
      name: AppRoutes.settingsRoute,
      page: () => const SettingsScreen(),
    ),
    GetPage(
        name: AppRoutes.configurationPumpRoute,
        page: () => ConfigurationPumpScreen()),
    GetPage(
        name: AppRoutes.configurationSystemRoute,
        page: () => ConfigurationSystemScreen()),
    GetPage(
        name: AppRoutes.configurationServerRoute,
        page: () => ConfigurationServerScreen()),
  ];
}

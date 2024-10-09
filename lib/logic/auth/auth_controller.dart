import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/errors.dart';
import '../../core/constants/typedef.dart';
import '../../data/models/auth_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/repositories/auth_repo.dart';
import '../getx_service/app_service.dart';

class AuthController extends GetxController {
  late String password;
  late AuthProvider _authProvider;
  final AppService appService = Get.find();
  AuthModel? authModel;
  UserModel? currentUser;
  ProductModel? currentProduct;
  late List<UserModel> users;
  late List<ProductModel> products;
  bool isLoading = false;
  late String configState;
  @override
  void onInit() {
    password = '';
    configState = '';
    super.onInit();
  }

  bool checkConfiguration() {
    if (!appService.isSocketConnect && !appService.isServerConnected) {
      configState = "يرجى ضبط الإعدادات";
    } else if (appService.pumpState && !appService.isSocketConnect) {
      configState = "يرجى ضبط المضخة";
    } else if (!appService.isServerConnected) {
      configState = "يرجى ضبط المخدم";
    } else {
      configState = "";
    }
    if (appService.pumpState && !appService.isSocketConnect) {
      return false;
    } else if (!appService.isServerConnected) {
      return false;
    }
    return true;
  }

  Future<bool> login({GlobalKey<FormState>? formKey}) async {
    _authProvider =
        AuthProvider(authRepo: AuthRepo(apiService: appService.apiService));
    try {
      if (checkConfiguration()) {
        isLoading = true;
        update();
        if (formKey!.currentState!.validate()) {
          String hashPassword = _generateMd5(password).toUpperCase();
          if (currentUser!.pin != hashPassword) {
            Alerts.showSnackBar('كلمة المرور خاطئة');
            isLoading = false;
            update();
            return false;
          }
          parameters loginParams = {
            'user_id': currentUser!.id,
            'pass': hashPassword,
          };
          loginParams.addAll(appService.params);
          authModel = await _authProvider.getAuthData(loginParams);
          if (authModel != null) {
            Alerts.showSnackBar("جاري البحث عن عمليات دفع غير مكتملة",duration: const Duration(seconds: 8));
           await appService
                .checkPrePayment(apiServiceFromAuth: appService.apiService,);
            isLoading = false;
            update();
            return true;
          }
        }
      } else {
        Alerts.showSnackBar(configState);
      }
    } catch (e) {
      isLoading = false;
      update();
      return false;
    }
    isLoading = false;
    update();
    return false;
  }

  String? validate(String? value, {required String message}) {
    if (value!.isEmpty) {
      return message;
    }
    return null;
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

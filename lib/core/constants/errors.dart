import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blue_sky_station/logic/getx_service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'app_colors.dart';

abstract class Exceptions {
  static void getExceptionType(dio.DioException e) {}
}

class DioExceptions implements Exceptions {
 static final AppService appService = Get.find();
 static bool showErrorMessage = true;
  static void getExceptionType(dio.DioException e) {
    String message = '';

    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
        print(e.toString());
        message = 'الاتصال بالخادم تجاوز المهلة. حاول مرة أخرى لاحقاً';
        break;
      case dio.DioExceptionType.receiveTimeout:
        print(e.toString());
        message = 'استغرق استلام البيانات وقتاً طويلاً. يرجى المحاولة لاحقاً';
        break;
      case dio.DioExceptionType.sendTimeout:
        print(e.toString());
        message = 'استغرق إرسال البيانات وقتاً طويلاً. تأكد من اتصالك وحاول مجدداً';
        break;
      case dio.DioExceptionType.badCertificate:
        print(e.toString());
        message = 'شهادة الخادم غير صالحة. لا يمكن إكمال الاتصال';
        break;
      case dio.DioExceptionType.badResponse:
        print(e.toString());
        message = 'حدث خطأ أثناء استلام الاستجابة. يرجى المحاولة لاحقاً';
        break;
      case dio.DioExceptionType.cancel:
        message = 'تم إلغاء الطلب';
        print(e.toString());
        break;
      case dio.DioExceptionType.connectionError:
        print(e.toString());
        message = 'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت';
        break;
      // TODO: Handle this case.
      case dio.DioExceptionType.unknown:
        message = 'حدث خطأ غير معروف. حاول مرة أخرى';
        break;
      default:
        message = 'حدث خطأ غير متوقع';
    }
    if(showErrorMessage && message.isNotEmpty){
      Alerts.showSnackBar(message);
    }
  }
}

abstract class Alerts {
  static void showSnackBar(String? message,
      {bool isFail = false,
      snackPosition = SnackPosition.TOP,
      Color fontColor = Colors.white,
      Color? color,
      Duration? duration}) {
    Get.snackbar(
      '',
      message ?? "no error message",
      messageText: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Text(
          message ?? 'no error message',
          style: TextStyle(fontSize: Get.size.height * 0.03, color: fontColor),
          textAlign: TextAlign.center,
        ),
      ),
      isDismissible: true,
      snackPosition: snackPosition,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: isFail ? Colors.red : AppColors.kMainColorGreenLight,
      colorText: Colors.white,
      // duration: duration ?? const Duration(milliseconds: 3500),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.only(bottom: 10, left: 10.0, right: 10),
    );
  }

  static AwesomeDialog showDialogue({
    String? title,
    String desc = '',
    dismissOnTouchOutside = true,
    required DialogType dialogType,
    required BuildContext context,
    bool autoDismiss = true,
    Function()? onPressYes,
    Function()? onPressNo,
    Widget? body,
    Widget? customHeader,
  })  =>
      AwesomeDialog(
          context: context,
          dialogType: dialogType,
          animType: AnimType.scale,
          title: title,
          desc: desc,
          body: body,
          customHeader: customHeader,
          dismissOnTouchOutside: dismissOnTouchOutside,
          headerAnimationLoop: false,
          autoDismiss: autoDismiss,
          btnOkColor: AppColors.kMainColorGreen,
          btnOkText: 'نعم',
          btnCancelColor: Colors.grey.withOpacity(0.65),
          btnCancelText: "لا",
          btnCancelOnPress: onPressNo,
          btnOkOnPress: onPressYes);
}

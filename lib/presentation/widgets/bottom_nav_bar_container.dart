import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';

class BottomNavBarContainer extends StatelessWidget {
  BottomNavBarContainer(
      {super.key,
      required this.text,
      required this.onTap,
      this.color,
      this.width,
      this.height,
      this.fontSize,
      this.fontColor});
  final String text;
  final Function()? onTap;
  double? width;
  double? height;
  Color? color;
  final double? fontSize;
  final Color? fontColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width ?? double.infinity,
        height: height ?? Get.size.height * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: color ?? AppColors.kMainColorGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 20.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset:   const Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ]),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: fontColor ?? Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}

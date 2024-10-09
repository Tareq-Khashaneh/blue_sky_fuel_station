import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/constants/app_colors.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key,this.color });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator(
      color: color ?? AppColors.kSecondColorOrange,
      ),
    );
  }
}

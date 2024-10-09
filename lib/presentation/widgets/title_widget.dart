import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title, this.fontSize});
  final String title;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: AppColors.kMainColorGreenLight, fontWeight: FontWeight.bold,
        fontSize: fontSize,
        ),
      ),
    );
  }
}

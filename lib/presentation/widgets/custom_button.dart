
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.label, this.fontSize});
  final Function() onPressed;
  final String label;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kMainColorGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              Dimensions.screenHeight * 0.04),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.contentPadding2),
        side:
        const BorderSide(width: 0, color: Colors.white),
        elevation: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0),
        child: Text(
         label,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 22,
              color: AppColors.kMainColorGreenLighter),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

AppBar buildAppBar({required String title,required BuildContext context,List<Widget>? actions ,}) {
  return AppBar(
    title: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(color: AppColors.kWhiteColor),
    ),automaticallyImplyLeading: false,
    centerTitle: true,
    backgroundColor: AppColors.kMainColorGreen,
    actions: actions,

  );
}
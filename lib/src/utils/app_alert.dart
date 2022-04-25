import 'package:flutter/material.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/app_styles.dart';

dynamic showAppSnackBar(BuildContext context, String message) {
  var snackBar = SnackBar(
      content: Text(
    message,
    style: AppStyles.textBodyDefault.copyWith(color: AppColors.white),
  ));

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

import 'package:flutter/material.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/app_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.icon,
    this.iconColor,
    this.buttonText,
    this.buttonColor,
    this.textColor = Colors.white,
    this.onPressed,
    this.borderRadius,
    this.height,
    this.width,
  }) : super(key: key);
  final String? buttonText;
  final Color? iconColor;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? borderRadius;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon != null ? icon! : const SizedBox.shrink(),
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
        ),
        label: Text(
          buttonText ?? "",
          textAlign: TextAlign.center,
          style: AppStyles.textBody1.copyWith(
            fontSize: 18.0,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

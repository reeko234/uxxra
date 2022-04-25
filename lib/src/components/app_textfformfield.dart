import 'package:flutter/material.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';

typedef ValidatorFunction = String? Function(String?);

class AppTextFormField extends StatelessWidget {
  final IconData? icon;
  final String? hint;
  final String? errorText;
  final bool? isObscure;
  final bool? isIcon;
  final String? label;
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final EdgeInsets? padding;
  final Color? hintColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final ValidatorFunction? validator;
  final bool? autoFocus;
  final TextInputAction? inputAction;
  final IconButton? suffixIcon;
  final int? maxLines;
  final Color? enabledBorderColor;
  final String? restorationId;
  final Color borderColor;
  final Color? focusBorderColor;
  final Color? disabledBorder;
  final Widget? prefixIcon;
  final bool? enableSuggestion;
  final String? intialValue;
  const AppTextFormField({
    Key? key,
    this.icon,
    this.hint,
    this.errorText,
    this.isObscure = false,
    this.keyboardType,
    this.textController,
    this.isIcon = true,
    this.validator,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = AppColors.black,
    this.iconColor = AppColors.black,
    this.backgroundColor = AppColors.transparent,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.label,
    this.suffixIcon,
    this.maxLines,
    this.enabledBorderColor,
    this.restorationId,
    required this.borderColor,
    this.disabledBorder,
    this.focusBorderColor,
    this.prefixIcon,
    this.enableSuggestion,
    this.intialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.99,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
      ),
      padding: padding,
      child: TextFormField(
        initialValue: textController == null ? intialValue : null,
        controller: intialValue == null ? textController : null,
        obscuringCharacter: "*",
        enableSuggestions: enableSuggestion ?? true,
        keyboardType: keyboardType,
        textInputAction: inputAction,
        obscureText: isObscure ?? false,
        restorationId: restorationId,
        autofocus: autoFocus ?? false,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: borderColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:
                BorderSide(color: focusBorderColor ?? AppColors.greyBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:
                BorderSide(color: enabledBorderColor ?? AppColors.greyBorder),
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: disabledBorder ?? Colors.black38)),
          label: Text(label ?? ""),
          hintText: hint,
          hintStyle:
              Theme.of(context).textTheme.bodyText1?.copyWith(color: hintColor),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorText: errorText,
          labelStyle: TextStyle(color: hintColor),
          contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        ),
      ),
    );
  }
}

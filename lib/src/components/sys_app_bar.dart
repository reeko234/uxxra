import 'package:flutter/material.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/app_styles.dart';

class SysAppBar extends StatelessWidget {
  const SysAppBar(
      {Key? key,
      required this.title,
      required this.showBackArrow,
      this.fontSize})
      : super(key: key);
  final String title;
  final bool showBackArrow;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 1.0,
      height: size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: showBackArrow,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
              child: Text(
            title,
            style:
                AppStyles.textTitleDefault.copyWith(fontSize: fontSize ?? 28),
          ))
        ],
      ),
    );
  }
}

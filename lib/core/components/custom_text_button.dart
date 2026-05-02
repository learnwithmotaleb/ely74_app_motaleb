import 'package:flutter/material.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderSide? border;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  const CustomTextButton({
    super.key,
    required this.title,
    this.onPressed,
    this.textColor = AppColors.kLightTextColor,
    this.backgroundColor,
    this.padding,
    this.border,
    this.borderRadius,
    this.fontSize, this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          overlayColor: AppColors.kPrimaryColor,// Remove minimum tap area
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            side: border ?? BorderSide.none,
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Padding(
          padding: padding8,
          child: Text(title,
              style: poppinsRegular.copyWith(
                fontSize: fontSize ?? getFontSizeSemiSmall(),
                fontWeight: fontWeight ?? FontWeight.w500,
                color: AppColors.kPrimaryColor
              )),
        ));
  }
}

import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';

class AuthSubTextWidget extends StatelessWidget {
  final String text;
  const AuthSubTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      textAlign: TextAlign.center,
      text: text,
      style: poppinsLight,
      color: AppColors.kExtraLightGreyTextColor,
    );
  }
}

class AuthTitleTextWidget extends StatelessWidget {
  final String title;
  const AuthTitleTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      style: poppinsMedium,
      fontSize: getFontSizeExtraLarge(),
    );
  }
}
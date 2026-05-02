import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_loading_widget.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';

import '../../../core/components/custom_text_button.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/pagination_loading_widget.dart';
import '../../../core/constants/text_style_constant.dart';

class ViewAllRow extends StatelessWidget {
  final String title;
  final String? buttonText;
  final Function() onPressed;
  const ViewAllRow({
    super.key, required this.title, required this.onPressed, this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: title,
            fontSize: getFontSizeDefault(),
            style: poppinsSemiBold,
          ),
        ),
        CustomTextButton(onPressed: onPressed, title: buttonText?? AppStaticStrings.viewAll.tr, )
      ],
    );
  }
}
Widget buildLoadingOverlay() {
  return Positioned.fill(
    child: Container(
      color: Colors.white.withValues(alpha: 0.5),
      child:CustomLoadingWidget(
        height: ScreenUtil().screenHeight,
        size: 30.sp,
        width: ScreenUtil().screenWidth,
      ),
    ),
  );
}
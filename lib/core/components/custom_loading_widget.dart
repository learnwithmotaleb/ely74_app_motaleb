
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_place/core/constants/image_constants.dart';

import '../constants/image_constants.dart';
class CustomLoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? size;
  const CustomLoadingWidget({
    super.key, this.height, this.width, this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?? ScreenUtil().screenWidth,
        height:height?? ScreenUtil().screenHeight -
            (kToolbarHeight +
                MediaQuery.of(context).viewPadding.top+MediaQuery.of(context).viewPadding.bottom+80.sp),
        child: Center(
            child: Image.asset(
              loadingImg,
              height:size?? 100.w,
            )));
  }
}
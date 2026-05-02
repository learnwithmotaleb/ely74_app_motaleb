import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_place/core/constants/padding_constant.dart';

import 'color_constants.dart';

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding12,
        child: SizedBox(
          height: 10.w,
          width: 10.w,
          child: CircularProgressIndicator(
            color: AppColors.kPrimaryColor,
            strokeWidth: 2.sp,
          ),
        ),
      ),
    );
  }
}
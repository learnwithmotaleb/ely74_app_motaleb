import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/padding_constant.dart';
class ConversationLoadingWidget extends StatelessWidget {
  const ConversationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 12.h,
      children: List.generate(10, (index) {
        return shimmerMessageCard();
      }),
    )
    ;
  }
}

Widget shimmerMessageCard() {
  return Shimmer.fromColors(
    baseColor: const Color(0xffE8F5E9),
    highlightColor: const Color(0xffC8E6C9),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12.r,
          ),
        ],
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          // Circle avatar placeholder
          Container(
            height: 50.w,
            width: 50.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Container(
                  height: 14.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 8.h),
                // Message preview
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


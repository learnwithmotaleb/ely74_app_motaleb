import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class NotificationCardLoading extends StatelessWidget {
  const NotificationCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h, // Your vertical spacing
      children: List.generate(
        10, // Number of shimmer items
            (index) => Shimmer.fromColors(
          baseColor: const Color(0xffE8F5E9),
          highlightColor: const Color(0xffC8E6C9),
          child: Container(
            padding: padding12H,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.kWhiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 12.r,
                ),
              ],
            ),
            child: Padding(
              padding: padding6V,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo placeholder
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Text placeholders
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title placeholder
                        Container(
                          width: 180.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Subtitle placeholder
                        Container(
                          width: double.infinity,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Additional text placeholder
                        Container(
                          width: 240.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

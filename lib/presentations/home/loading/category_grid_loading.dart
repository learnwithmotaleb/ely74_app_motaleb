import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
class CategoryGridLoading extends StatelessWidget {
  const CategoryGridLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // spacing: 8.w,
      // runSpacing: 8.w,
      children: List.generate(
        8,
            (index) => Shimmer.fromColors(
          baseColor: const Color(0xffE8F5E9),
          highlightColor: const Color(0xffC8E6C9),
          period: const Duration(milliseconds: 1500),
          child: Container(
            width: (MediaQuery.of(context).size.width / 3) - 16.w,
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 8.h),
                // Title placeholder
                Container(
                  height: 16.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle placeholder
                Container(
                  height: 12.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

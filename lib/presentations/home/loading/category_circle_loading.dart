import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCircleLoading extends StatelessWidget {
  const CategoryCircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8.w,
      runSpacing: 8.w,
      children: List.generate(
        8, // Shows 8 shimmer placeholders
            (index) => SizedBox(
          width: 80.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular image placeholder
              Shimmer.fromColors(
                baseColor: const Color(0xffE8F5E9), // Lighter green (50)
                highlightColor: const Color(0xffC8E6C9), // Lighter green (100)
                period: const Duration(milliseconds: 1500),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // Text placeholder
              Shimmer.fromColors(
                baseColor: const Color(0xffE8F5E9),
                highlightColor: const Color(0xffC8E6C9),
                period: const Duration(milliseconds: 1500),
                child: Container(
                  width: 70.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

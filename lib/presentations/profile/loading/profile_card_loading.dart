
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCardShimmer extends StatelessWidget {
  final bool showEditButton;

  const ProfileCardShimmer({super.key, this.showEditButton = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image placeholder
        ShimmerContainer(
          width: 80.w,
          height: 80.w,
         borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name placeholder
              ShimmerContainer(
                width: 120.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(height: 4.h),
              // Email row placeholder
              Row(
                children: [
                  ShimmerContainer(
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ShimmerContainer(
                      width: ScreenUtil().screenWidth/2,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              // Phone row placeholder
              Row(
                children: [
                  ShimmerContainer(
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ShimmerContainer(
                      width: ScreenUtil().screenWidth/2,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showEditButton) ...[
          SizedBox(width: 12.w),
          ShimmerContainer(
            width: 80.w,
            height: 32.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      ],
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffE8F5E9), // Lighter green (50)
      highlightColor: const Color(0xffC8E6C9), // Lighter green (100)
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? borderRadius ?? BorderRadius.circular(8.r)
              : null,
        ),
      ),
    );
  }
}
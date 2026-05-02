import 'package:flutter/material.dart';
import 'package:market_place/core/constants/color_constants.dart';

class CustomRefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const CustomRefreshIndicatorWidget({
    super.key,
    required this.child, required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.kWhiteColor,
      color: AppColors.kPrimaryDarkColor,
      onRefresh: onRefresh,
      displacement: 10, // Adjust this value to control how far down the indicator appears
      strokeWidth: 2.0,
      child: child,

    );
  }
}

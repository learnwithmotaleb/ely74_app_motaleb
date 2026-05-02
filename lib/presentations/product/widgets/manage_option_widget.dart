import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_place/core/components/custom_button.dart';

class ManageOptionWidget extends StatelessWidget {
  final Color color;
  final String title;
  final String icon;
  final Function() action;
  final bool? isLoading;
  const ManageOptionWidget({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    required this.action, this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: CustomButton(
        isLoading: isLoading,
        loadingColor: color,
        borderColor: color,
        textColor: color,
        fillColor: color.withValues(alpha: .1),
        prefixWidget: Padding(
          padding:  EdgeInsets.only(right: 8.w),
          child: SvgPicture.asset(icon, height: 20.w),
        ),
        onTap: action,
        title: title,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/presentations/notification/model/notification_model.dart';

import '../../../core/constants/custom_text.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/helper/helper_function.dart';

class NotificationCardItem extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationCardItem({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          spacing: 8.w,
          children: [
            notificationModel.user==null || notificationModel.user?.img == null
                ? SvgPicture.asset(logoIcon, height: 40.w)
                : CustomNetworkImage(
                  imageUrl:
                      "${ApiService().baseUrl}/${notificationModel.user?.img}", height: 40.w,boxShape: BoxShape.circle,
                ),

            ///------------------------dynamic title-------------------------///
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: notificationModel.title.toString(),
                    style: poppinsSemiBold,
                  ),
                   CustomText(
                    text: notificationModel.message.toString(),
                    style: poppinsRegular,
                    color: AppColors.kExtraLightGreyTextColor,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ),
            CustomText(
              text: dateFormateChange(date: notificationModel.createdAt.toString()),
              style: poppinsLight,
              fontSize: 8.sp,
            ),
          ],
        ),
      ),
    );
  }
}

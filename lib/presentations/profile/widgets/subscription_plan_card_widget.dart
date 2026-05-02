import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/auth/controller/auth_controller.dart';
import 'package:market_place/presentations/profile/model/package_model.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/constants/padding_constant.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  final PackageModel? package;
  const SubscriptionPlanWidget({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return package == null
        ? SizedBox.shrink()
        : Padding(
          padding: padding12V.copyWith(top: 0),
          child: Container(
            padding: padding16,
            decoration: BoxDecoration(
              color: AppColors.kWhiteColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 16.r,
                ),
              ],
            ),
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "${package!.type} Plan",
                      style: poppinsSemiBold,
                      fontSize: getFontSizeDefault(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryDarkColor.withValues(
                          alpha: .1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: CustomText(
                        text: package!.name.toString(),
                        color: AppColors.kPrimaryDarkColor,
                        fontSize: getFontSizeSmall(),
                      ),
                    ),
                  ],
                ),
                CustomText(
                  text: "UM ${package!.price} /${package!.type}",
                  style: poppinsBold,
                  color: AppColors.kPrimaryColor,
                  fontSize: getButtonFontSizeLarge(),
                ),
                if (package!.features != null && package!.features!.isNotEmpty)
                  ...List.generate(
                    package!.features!.length,
                    (index) => CustomText(
                      text: "✓ ${package!.features![index]}",
                      fontSize: getFontSizeSmall(),
                    ),
                  ),
                Obx(
               () {
                    return CustomButton(
                      isLoading: AccountInformationController.to.isLoadingSubscribe.value,
                      onTap: () {
                        AccountInformationController.to.subscribeNowRequest(subscribeId: package!.sId.toString());
                      },
                      title: AppStaticStrings.subscribeNow.tr,
                    );
                  }
                ),
              ],
            ),
          ),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/auth/views/login_page.dart';
import 'package:market_place/presentations/navigation/views/navigation_page.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/splash_controller.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../../../core/utils/hive_boxes.dart';
class OnboardingItemContentWidget extends StatelessWidget {
  final OnboardingModel onboardingModel;
  const OnboardingItemContentWidget({
    super.key,
    required this.onboardingModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 12.h ,
      children: [


         Padding(
           padding: padding16V,
           child: SvgPicture.asset(
             onboardingModel.frontImgUrl ?? '',
           ),
         )
      ,
        Padding(
          padding: padding16H,
          child: CustomText(
            textAlign: TextAlign.center,
            text: onboardingModel.title,
            style: poppinsMedium,
            fontSize: getFontSizeExtraLarge(),
          ),
        ), Padding(
          padding: padding16H,
          child: CustomText(
            textAlign: TextAlign.center,
            text: onboardingModel.message,
            style: poppinsRegular,
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightTextColor,
          ),
        ),
        space16H,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.w,
          children: List.generate(
            onboardingData.length,
                (index) => Obx(() {
              return Container(
                height: 4,
                width: OnboardingController.to.currentIndex.value == index
                    ? 20.w:4.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    color:
                    OnboardingController.to.currentIndex.value == index
                        ? AppColors.kPrimaryColor
                        : AppColors.kTextColor.withValues(alpha: .3)),
              );
            }),
          ),
        ),
        Spacer(),
        Padding(
          padding: padding16H,
          child: CustomButton(
            title:AppStaticStrings.next.tr,
            onTap: () {
              if (OnboardingController.to.currentIndex.value <
                  onboardingData.length - 1) {
                OnboardingController.to.pageController.value.animateToPage(
                    OnboardingController.to.currentIndex.value + 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);

              } else {
                Boxes.getUserData().put(initialKey, true);
                Get.offAllNamed(NavigationPage.routeName);
              }
            },
          ),
        ),
        space16H,
      ],
    );
  }
}

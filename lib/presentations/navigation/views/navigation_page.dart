import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/common_controller.dart';
import 'package:market_place/core/utils/hive_boxes.dart';
import 'package:market_place/presentations/auth/views/login_page.dart';
import 'package:market_place/presentations/notification/views/notification_page.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/views/payment_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/utils/variable.dart';
import '../controller/navigation_controller.dart';

class NavigationPage extends StatelessWidget {
  static const String routeName = "/nav";

  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> appbarTitle = [
      AppStaticStrings.myListings.tr,
      AppStaticStrings.addNewListing.tr,
      AppStaticStrings.messages.tr,
      AppStaticStrings.profile.tr,
    ];
    List<String> labels = [
      AppStaticStrings.home.tr,
      AppStaticStrings.myListings.tr,
      AppStaticStrings.sellNow.tr,
      AppStaticStrings.messages.tr,
      AppStaticStrings.profile.tr,
    ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          NavigationController.to
              .existApp(); // This works only for physical back press
        }
      },
      /*    canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        NavigationController.to.existApp();
      },*/
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            return NavigationController.to.selectedNavIndex.value == 0
                ? Builder(
                  builder: (context) {
                    return CustomHomeAppbar(
                      onActionTap: () {
                        if (NavigationController.to.isLoggedIn) {
                          Get.toNamed(NotificationPage.routeName);
                        } else {
                          Get.toNamed(LoginPage.routeName);
                        }
                      },
                    );
                  },
                )
                : CustomDefaultAppbar(
                  onLeading: () {
                    NavigationController.to.selectedNavIndex.value = 0;
                  },
                  title:
                      appbarTitle[NavigationController
                              .to
                              .selectedNavIndex
                              .value -
                          1],
                );
          }),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return IndexedStack(
                  index: NavigationController.to.selectedNavIndex.value,
                  children: NavigationController.to.getPages(),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: padding6H,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(radiusCommon),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 20.r,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  List.generate(
                    NavigationController.to.icons.length,
                    (index) => Expanded(
                      // Add Expanded to distribute space evenly
                      child: ButtonTapWidget(
                        onTap: () async {
                          final isLoggedIn = NavigationController.to.isLoggedIn;
                          final indexToOpen = index;

                          // Not logged in and trying to access premium tabs
                          if (!isLoggedIn && indexToOpen != 0) {
                            Get.toNamed(LoginPage.routeName);
                            return;
                          }

                          // Check if subscription is required (index 1 or 2)
                          if ((indexToOpen == 1 || indexToOpen == 2)) {
                            final isSubscribed = await NavigationController.to.isSubscribed();

                            if (isSubscribed) {
                              NavigationController.to.selectedNavIndex.value = indexToOpen;
                              return;
                            }

                            final createdAtStr = AccountInformationController.to.userModel.value.createdAt.toString();
                            final createdAt = DateTime.parse(createdAtStr);
                            final bool isInGrace = DateTime.now().toUtc().isBefore(createdAt.add(const Duration(days: 90)));


                            final bool hasSeenPopup = Boxes.getAppBox().get('shownFreeTrialPopup', defaultValue: false);

                            if (isInGrace && !hasSeenPopup) {
                              warningCustomDialog(
                                onCancel: () async{
                                  await Boxes.getAppBox().put('shownFreeTrialPopup', true);
                                  Get.back();

                                },
                                typeText: AppStaticStrings.freeAccessTitle.tr,
                                title: AppStaticStrings.freeAccessMessage.tr,
                                fillButtonText: AppStaticStrings.subscribeNow.tr,
                                outlineButtonText: AppStaticStrings.skip.tr,
                                onTap: () {
                                  
                                  Get.toNamed(SubscriptionPage.routeName);
                                },
                                loading: AccountInformationController.to.isLoadingLogout,
                              );
                              return;
                            }

                            if (!isInGrace) {
                                                                Get.toNamed(SubscriptionPage.routeName);

                              return;
                            }

                            NavigationController.to.selectedNavIndex.value = indexToOpen;
                            return;
                          }

                          NavigationController.to.selectedNavIndex.value = indexToOpen;
                        },

                        child: Padding(
                          padding: padding6V,
                          child: Obx(() {
                            bool isSelected =
                                NavigationController
                                    .to
                                    .selectedNavIndex
                                    .value ==
                                index;
                            return Column(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Use min to prevent column from expanding
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (isSelected)
                                  AnimatedContainer(
                                    duration: const Duration(microseconds: 10),
                                    curve: Curves.linear,

                                    transform: Matrix4.translationValues(
                                      0,
                                      -20,
                                      0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,

                                      // border: Border.all(
                                      //   width: 6.w,
                                      //   color: AppColors.kWhiteColor,
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.kPrimaryColor
                                              .withValues(alpha: .2),
                                          blurRadius: 4.r,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: padding6,
                                    child: Container(
                                      padding: padding12,
                                      // transform: Matrix4.translationValues(0, -20, 0),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.green
                                                : Colors.transparent,
                                        shape: BoxShape.circle,

                                        // border: Border.all(
                                        //   width: 6.w,
                                        //   color: AppColors.kWhiteColor,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.kPrimaryColor
                                                .withValues(alpha: .2),
                                            blurRadius: 4.r,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        NavigationController.to.icons[index],
                                        colorFilter: ColorFilter.mode(
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  SvgPicture.asset(
                                    NavigationController.to.icons[index],
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                if (!isSelected)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.w),
                                    child: CustomText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: getFontSizeSmall(),
                                      style: poppinsMedium,
                                      text: labels[index],
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

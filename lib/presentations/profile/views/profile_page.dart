import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/common_controller.dart';
import 'package:market_place/presentations/my-listings/views/listing_product_page.dart';

import 'package:market_place/presentations/notification/views/notification_page.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/loading/profile_card_loading.dart';
import 'package:market_place/presentations/profile/views/account_settings_page.dart';
import 'package:market_place/presentations/profile/views/my_subscription_page.dart';
import 'package:market_place/presentations/profile/views/term_policy_help_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_refresh_indicator.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../widgets/language_change_dialog.dart';
import '../widgets/profile_action_item_widget.dart';
import '../widgets/profile_info_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return AccountInformationController.to.getUserProfileRequest();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: padding12.copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColors.kWhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kExtraLightGreyTextColor.withValues(
                            alpha: .3,
                          ),
                          blurRadius: 6.r,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: padding6,
                      child: Obx(() {
                        return AccountInformationController
                            .to
                            .isLoadingProfile
                            .value
                            ? ProfileCardShimmer()
                            : ProfileInfoDetailsWidget(
                          email:
                          AccountInformationController
                              .to
                              .userModel
                              .value
                              .email,
                          img:
                          AccountInformationController.to.userModel.value.img!=null?"${ApiService().baseUrl}/${AccountInformationController.to.userModel.value.img??""}":"",
                          name:
                          AccountInformationController
                              .to
                              .userModel
                              .value
                              .name,
                          phone:
                          AccountInformationController
                              .to
                              .userModel
                              .value
                              .phone,
                        );
                      }),
                    ),
                  ),
                  ProfileActionItemWidget(
                    img: settingIcon,
                    title: AppStaticStrings.accountSetting.tr,
                    onTap: () {
                      Get.toNamed(AccountSettingsPage.routeName);
                    },
                  ),
                  ProfileActionItemWidget(
                    img: favItemIcon,
                    title: AppStaticStrings.favoriteItems.tr,
                    onTap: () {

                      Get.toNamed(
                        ListingProductPage.routeName,
                        arguments: {'title':AppStaticStrings.favoriteItems.tr,
                          'products':AccountInformationController.to.favProductList,
                          'load':AccountInformationController.to.isLoadingFavProduct},
                      );
                    },
                  ),
                  ProfileActionItemWidget(
                    img: languageIcon,
                    title: AppStaticStrings.language.tr,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => LanguageChangeDialog(),
                      );
                    },
                  ),
                  ProfileActionItemWidget(
                    img: notificationOutlineIcon,
                    title: AppStaticStrings.notification.tr,
                    onTap: () {
                      Get.toNamed(NotificationPage.routeName);
                    },
                  ),
                  ProfileActionItemWidget(
                    img: subscriptionIcon,
                    title: AppStaticStrings.subscriptionStatus.tr,
                    onTap: () {
                      Get.toNamed(MySubscriptionPage.routeName);
                    },
                  ),

                  CustomText(
                    text: AppStaticStrings.more.tr,
                    fontSize: getFontSizeDefault(),
                    style: poppinsSemiBold,
                  ),
                  ProfileActionItemWidget(
                    img: termsIcon,
                    title: AppStaticStrings.termsAndCondition.tr,
                    onTap: () {
                      Get.toNamed(
                        TermsPolicyHelpPage.routeName,
                        arguments: AppStaticStrings.termsAndCondition.tr,
                      );
                    },
                  ),
                  ProfileActionItemWidget(
                    img: privacyPolicyIcon,
                    title: AppStaticStrings.privacyPolicy.tr,
                    onTap: () {
                      Get.toNamed(
                        TermsPolicyHelpPage.routeName,
                        arguments: AppStaticStrings.privacyPolicy.tr,
                      );
                    },
                  ),

                  ProfileActionItemWidget(
                    img: logoutIcon,
                    title: AppStaticStrings.logOut.tr,
                    onTap: () {
                      warningCustomDialog(

                        title: AppStaticStrings.logoutConfirmation.tr,
                        onTap: () {
                          AccountInformationController.to.logoutRequest();
                        },
                        loading: AccountInformationController.to.isLoadingLogout,
                      );
                      // NavigationController.to.logoutRequest();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

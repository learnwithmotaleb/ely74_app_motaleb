import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/components/custom_refresh_indicator.dart';
import 'package:market_place/core/components/custom_textfield.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/views/payment_page.dart';
 
class MySubscriptionPage extends StatefulWidget {
  static const String routeName = "/my-subscription";

  const MySubscriptionPage({super.key});

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(
        title: AppStaticStrings.subscriptionStatus.tr,
      ),
      body: CustomRefreshIndicatorWidget(
        onRefresh: () => AccountInformationController.to.getUserSubscriptionPackageRequest(),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
       slivers: [
        SliverToBoxAdapter(
          child:  Padding(
            padding: padding12,
            child: Obx(() {
              return Column(
                spacing: 8.h,
                children: [
                  CustomTextField(
                    textEditingController: TextEditingController(
                      text: AccountInformationController.to.packageModel.value
                          .type??'N/A',
                    ),
                    fillColor: AppColors.kWhiteColor,
                    title: AppStaticStrings.subscriptionType.tr,
                  ),
                  CustomTextField(
                    textEditingController: TextEditingController(
                      text: (AccountInformationController.to.packageModel.value
                          .isActive??'N/A').toString(),
                    ),
                    fillColor: AppColors.kWhiteColor,
                    title: AppStaticStrings.subscriptionStatus.tr,
                  ), CustomTextField(
                    textEditingController: TextEditingController(
                      text: (AccountInformationController.to.packageModel.value
                          .price??'0.00').toString(),
                    ),
                    fillColor: AppColors.kWhiteColor,
                    title: AppStaticStrings.price.tr,
                  ),
                  CustomTextField(
                    textEditingController: TextEditingController(
                      text:  dateFormateChange(date: AccountInformationController
                          .to.packageModel.value
                          .expiresIn),
                    ),
                    fillColor: AppColors.kWhiteColor,
                    title: AppStaticStrings.subscriptionExpiryDate.tr,
                  ),
                  space8H,
                  //
                  // Obx(() {
                  //   return CustomButton(
                  //     isLoading: AccountInformationController.to
                  //         .isLoadingRenewSubscribe.value,
                  //     onTap: () {
                  //       AccountInformationController.to.subscribeRenewRequest(
                  //           subscribeId: AccountInformationController.to
                  //               .packageModel.value
                  //               .subscriptionId.toString());
                  //     },
                  //     title: AppStaticStrings.renewSubscription.tr,
                  //   );
                  // }),
                  CustomButton(
                    fillColor: Colors.transparent,
                    textColor: AppColors.kPrimaryColor,

                    onTap: () {
                                                        Get.toNamed(SubscriptionPage.routeName);

                    },
                    title:AccountInformationController.to.packageModel.value
                        .isActive=="Expired"?AppStaticStrings.renewSubscription.tr: AppStaticStrings.changeSubscription.tr,
                  ),
                ],
              );
            }),
          ),
        )
       ],
        ),
      ),
    );
  }
}

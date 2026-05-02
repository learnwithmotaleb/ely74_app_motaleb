import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/components/custom_refresh_indicator.dart';
import '../../../core/components/custom_textfield.dart';

class EditProfilePage extends StatelessWidget {
  static const String routeName = "/edit-profile";
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: AppStaticStrings.editProfile.tr),
      body: CustomRefreshIndicatorWidget(
        onRefresh: () {
          return AccountInformationController.to.getUserProfileRequest();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child:Center(
                child: Padding(
                  padding: padding12,
                  child: Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12.h,
                      children: [
                        Stack(
                          children: [
                            AccountInformationController
                                .to
                                .profileImgPath
                                .value
                                .isEmpty
                                ? CustomNetworkImage(
                              imageUrl:
                              "${ApiService().baseUrl}/${AccountInformationController.to.userModel.value.img}",
                              boxShape: BoxShape.circle,
                              height: 150.w,
                              width: 150.w,
                            )
                                : ClipOval(
                              child: Image.file(
                                File(
                                  AccountInformationController
                                      .to
                                      .profileImgPath
                                      .value,
                                ),
                                fit: BoxFit.cover,
                                height: 150.w,
                                width: 150.w,
                              ),
                            ),

                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: ButtonTapWidget(
                                onTap: () {
                                  pickImages(context: context,
                                    singleImagePath:
                                    AccountInformationController
                                        .to
                                        .profileImgPath,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.kPrimaryAccentColor,
                                  ),
                                  padding: padding4,
                                  child: SvgPicture.asset(
                                    cameraIcon,
                                    height: 20.w,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.kPrimaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          fillColor: AppColors.kWhiteColor,
                          title: AppStaticStrings.name.tr,
                          textEditingController:
                          AccountInformationController.to.nameController.value,
                        ),
                        CustomTextField(
                          fillColor: AppColors.kWhiteColor,
                          title: AppStaticStrings.email.tr,
                          isEnable: false,
                          textEditingController:
                          AccountInformationController.to.emailController.value,
                        ),
                        CustomTextField(
                          fillColor: AppColors.kWhiteColor,
                          title: AppStaticStrings.contactNumber.tr,
                          textEditingController:
                          AccountInformationController
                              .to
                              .contactNumberController
                              .value,
                        ),
                        space8H,
                        CustomButton(
                          isLoading:
                          AccountInformationController
                              .to
                              .isLoadingUpdateProfile
                              .value,
                          onTap: () async {
                            await AccountInformationController.to
                                .updateProfileRequest();
                          },
                          title: AppStaticStrings.update.tr,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

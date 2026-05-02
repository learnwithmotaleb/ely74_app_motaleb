import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/components/custom_textfield.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';

class ChangePasswordPage extends StatelessWidget {
  static const String routeName = '/change-pass';

  ChangePasswordPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: AppStaticStrings.changePassword.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Form(
            key: formKey,
            child: Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textEditingController:
                      AccountInformationController.to.currentPasswordController,
                  fillColor: AppColors.kWhiteColor,
                  title: AppStaticStrings.currentPass.tr,
                  isPassword: true,
                ),
                CustomTextField(
                  textEditingController:
                      AccountInformationController.to.newPasswordController,

                  fillColor: AppColors.kWhiteColor,
                  title: AppStaticStrings.newPass.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired.tr;
                    } else if (value.length < 8) {
                      return AppStaticStrings.passMustbe6.tr;
                    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return AppStaticStrings.passMustContain.tr;
                    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return AppStaticStrings.passwordLowercase.tr;
                    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return AppStaticStrings.passwordNumber.tr;
                    } else if (!RegExp(
                      r'[!@#\$&*~%^()_+\-=\[\]{};:"\\|,.<>\/?]',
                    ).hasMatch(value)) {
                      return AppStaticStrings.passwordSpecialChar.tr;
                    }
                    return null;
                  },
                  isRequired: true,
                  isPassword: true,
                ),
                CustomTextField(
                  textEditingController:
                      AccountInformationController.to.confirmPasswordController,

                  fillColor: AppColors.kWhiteColor,
                  title: AppStaticStrings.confirmPassword.tr,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired.tr;
                    } else if (value !=
                        AccountInformationController
                            .to
                            .newPasswordController
                            .text) {
                      return AppStaticStrings.passNotMatch.tr;
                    }
                    return null;
                  },
                  isRequired: true,
                ),
                space8H,
              CustomButton(

                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        warningCustomDialog(

                          title: AppStaticStrings.changePasswordConfirmation.tr,
                          onTap: () async{
                            AccountInformationController.to.changePassRequest();
                            Get.back();
                          },
                          loading:  AccountInformationController
                              .to
                              .isLoadingChangePass
                              ,
                        );

                      }
                    },
                    title: AppStaticStrings.save.tr,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

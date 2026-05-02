import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/components/custom_checkbox_widget.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/enum.dart';
import 'package:market_place/presentations/auth/controller/auth_controller.dart';
import 'package:market_place/presentations/auth/views/login_page.dart';
import 'package:market_place/presentations/profile/views/term_policy_help_page.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../widgets/auth_title_widget.dart';

class SignUpPage extends StatelessWidget {
  static const String routeName = "/sign-up";
  SignUpPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: CustomAuthAppbar(),
      body: Padding(
        padding: padding12.copyWith(
          top: 0,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthTitleTextWidget(
                    title: AppStaticStrings.createYourAccount.tr,
                  ),
                  AuthSubTextWidget(
                    text: AppStaticStrings.signUpToGetStarted.tr,
                  ),
                  CustomTextField(
                    textEditingController:
                        AuthController.to.nameSignUpController,
                    fillColor: Colors.transparent,
                    title: AppStaticStrings.fullName.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.nameRequired.tr;
                      }
                      return null;
                    },
                    isRequired: true,
                  ),
                  CustomTextField(
                    textEditingController:
                        AuthController.to.emailSignUpController.value,
                    fillColor: Colors.transparent,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.emailRequired.tr;
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return AppStaticStrings.enterValidEmail.tr;
                      }
                      return null;
                    },
                    isRequired: true,
                    title: AppStaticStrings.email.tr,
                  ),
                  // CustomTextField(
                  //   textEditingController:
                  //       AuthController.to.phoneSignUpController,
                  //   fillColor: Colors.transparent,
                  //   isRequired: true,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return AppStaticStrings.phoneRequired.tr;
                  //     } else if (value.length < 8) {
                  //       return AppStaticStrings.phoneMustbe11.tr;
                  //     }
                  //
                  //     return null;
                  //   },
                  //   title: AppStaticStrings.phoneNumber.tr,
                  //   keyboardType: TextInputType.number,
                  // ),

                  CustomTextField(
                    textEditingController:
                        AuthController.to.passSignUpController,
                    fillColor: Colors.transparent,
                    title: AppStaticStrings.password.tr,
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
                        r'[!@#$&*~%^()_+\-=\[\]{};:"\\|,.<>/?]',
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
                        AuthController.to.confirmPassSignUpController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.passRequired.tr;
                      } else if (value !=
                          AuthController.to.passSignUpController.value.text) {
                        return AppStaticStrings.passNotMatch.tr;
                      }
                      return null;
                    },
                    isRequired: true,
                    fillColor: Colors.transparent,

                    title: AppStaticStrings.confirmPassword.tr,
                    isPassword: true,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckBoxWidget(
                        isChecked: AuthController.to.isCheckTermsCondition,
                      ),
                      space6W,
                      Expanded(
                        child: ButtonTapWidget(
                             onTap:  () {
                               Get.toNamed(TermsPolicyHelpPage.routeName);
                             },
                          child: CustomText(
                            text: AppStaticStrings.agreeToPrivacyPolicy.tr,
                            // fontSize: getFontSizeSmall(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(orImg, width: ScreenUtil().screenWidth),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStaticStrings.alreadyHaveAccount.tr,
                        style: poppinsRegular,
                      ),
                      CustomTextButton(
                        onPressed: () {
                          Get.toNamed(LoginPage.routeName);
                        },
                        title: AppStaticStrings.signIn.tr,
                        fontSize: getFontSizeSemiSmall(),
                        textColor: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Obx(() {
                    return CustomButton(
                      isLoading:
                          AuthController.to.loadingProcess.value ==
                          AuthProcess.signUp,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if(AuthController.to.isCheckTermsCondition.value){
                            AuthController.to.signUpRequest();
                          }else{
                            showCustomSnackbar(title: AppStaticStrings.warning.tr, message: "Please agree to the Bazarya privacy policy");
                          }
                        }
                      },
                      title: AppStaticStrings.createAccount.tr,
                    );
                  }),
                  space12H,

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

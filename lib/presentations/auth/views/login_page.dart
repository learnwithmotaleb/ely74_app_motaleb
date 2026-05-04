import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/enum.dart';
import 'package:market_place/presentations/auth/controller/auth_controller.dart'
    show AuthController;
import 'package:market_place/presentations/auth/views/signup_page.dart';
import 'package:market_place/presentations/auth/views/verify_email_page.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_checkbox_widget.dart';
import '../../../core/components/custom_text_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../widgets/auth_title_widget.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = "/login";
  LoginPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppbar(),
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
                  AuthTitleTextWidget(title: AppStaticStrings.welcomeBack.tr),
                  AuthSubTextWidget(text: AppStaticStrings.logInToContinue.tr),
                  space12H,
                  CustomTextField(
                    fillColor: Colors.transparent,
                    title: "Email Or Phone".tr,
                    hintText: "email or phone",
                    textEditingController: AuthController.to.emailLoginController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email or Phone is required".tr;
                      }
                      // If it contains '@', validate as email, otherwise as phone
                      if (value.contains('@')) {
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return AppStaticStrings.enterValidEmail.tr;
                        }
                      } else {
                        if (value.length < 6) {
                          return "Enter a valid phone number".tr;
                        }
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    fillColor: Colors.transparent,
                    title: AppStaticStrings.password.tr,
                    hintText: "password",
                    textEditingController:
                        AuthController.to.passLoginController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.passRequired.tr;
                      }
                      return null;
                    },
                    isPassword: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomCheckBoxWidget(
                              isChecked: AuthController.to.isRememberMe,
                            ),
                            Expanded(
                              child: CustomText(
                                text: AppStaticStrings.rememberMe.tr,
                                // fontSize: getFontSizeSmall(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      CustomTextButton(
                        title: AppStaticStrings.forgetPassword.tr,
                        onPressed: () {
                          Get.toNamed(
                            VerifyEmailPage.routeName,
                            arguments: true,
                          );
                        },
                      ),
                    ],
                  ),
                  SvgPicture.asset(orImg, width: ScreenUtil().screenWidth),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStaticStrings.dontHaveAccount.tr.tr,
                        style: poppinsRegular,
                      ),
                      CustomTextButton(
                        onPressed: () {
                          Get.toNamed(SignUpPage.routeName);
                        },
                        title: AppStaticStrings.signUp.tr,
                        fontSize: getFontSizeSemiSmall(),
                        textColor: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),

                  Obx(
                    () {
                      return CustomButton(
                        isLoading: AuthController.to.loadingProcess.value==AuthProcess.login,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            AuthController.to.signInRequest();
                          }                    },
                        title: AppStaticStrings.signIn.tr,
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

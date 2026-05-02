import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/utils/enum.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/utils/variable.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_title_widget.dart';

class VerifyEmailPage extends StatelessWidget {
  static const String routeName = "/verify-email";
  VerifyEmailPage({super.key});
  final arg = Get.arguments;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: CustomAuthAppbar(),
      body: Padding(
        padding: padding12.copyWith(
          top: 0,
        ),
        child: Center(
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTitleTextWidget(title: AppStaticStrings.verifyYourEmail.tr),
              AuthSubTextWidget(text: AppStaticStrings.weWillSendACode.tr),
              Form(
                  key: formKey,
                child: CustomTextField(
                  title: AppStaticStrings.email.tr,
                  fillColor: Colors.transparent,
                  textEditingController: arg!=null&& arg==verifyEmail?
                  AuthController.to.emailSignUpController.value:
                  AuthController.to.emailForgetController.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.emailRequired;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppStaticStrings.enterValidEmail;
                    }
                    return null;
                  },
                ),
              ),

              space4H,
              Obx(
             () {
                  return CustomButton(
                    isLoading: AuthController.to.loadingProcess.value ==AuthProcess.forgetPassword,
                    onTap: () {
                      if(formKey.currentState!.validate()){
                        AuthController.to.forgetPasswordRequest(email: AuthController.to.emailForgetController.value.text);
                      }                },
                    title: AppStaticStrings.continueButton.tr,
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

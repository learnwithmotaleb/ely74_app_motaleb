import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/padding_constant.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_title_widget.dart';

class SetNewPasswordPage extends StatelessWidget {
  static const String routeName = "/set-new-pass";
  SetNewPasswordPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: CustomAuthAppbar(),
      body: Padding(
        padding: padding12.copyWith(
          top: 0,
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTitleTextWidget(
                  title: AppStaticStrings.resetYourPassword.tr,
                ),
                AuthSubTextWidget(text: AppStaticStrings.createAnewPassword.tr),
                space6H,
                CustomTextField(
                  textEditingController: AuthController.to.passNewController,

                  fillColor: Colors.transparent,
                  title: AppStaticStrings.newPassword.tr,
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
                  isPassword: true,
                ),
                CustomTextField(
                  fillColor: Colors.transparent,
                  textEditingController:
                      AuthController.to.confirmPassNewController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired;
                    } else if (value !=
                        AuthController.to.passNewController.text) {
                      return AppStaticStrings.passNotMatch;
                    }
                    return null;
                  },
                  title: AppStaticStrings.confirmNewPassword.tr,
                  isPassword: true,
                ),
                space4H,
                Obx(() {
                  return CustomButton(
                    isLoading:
                        AuthController.to.loadingProcess.value ==
                        AuthProcess.resetPassword,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        AuthController.to.resetPasswordRequest();
                      }
                      logger.d(
                        Boxes.getUserData().get(verifyTokenKey).toString(),
                      );
                    },
                    title: AppStaticStrings.confirm.tr,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

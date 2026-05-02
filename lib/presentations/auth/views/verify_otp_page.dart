import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/utils/enum.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_otp_field.dart';
import '../../../core/components/custom_text_button.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_title_widget.dart';

class VerifyOtpPage extends StatelessWidget {
  static const String routeName = "/otp";
  VerifyOtpPage({super.key});
  final arg = Get.arguments;

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
              AuthTitleTextWidget(title: AppStaticStrings.sixDigitCode.tr),
              AuthSubTextWidget(text: AppStaticStrings.enterCodeSent.tr),
              space6H,
              OtpTextField(),
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                  onPressed: () {
                    AuthController.to.forgetPasswordRequest(email:arg != null && arg == verifyEmail
                        ? AuthController.to.emailSignUpController.value.text
                        : AuthController.to.emailForgetController.value.text);

                  },
                  title: AppStaticStrings.resendOtp.tr,
                  fontSize: getFontSizeSmall(),
                ),
              ),
              space4H,
              CustomButton(
                isLoading:
                    AuthController.to.loadingProcess.value ==
                    AuthProcess.activateAccount,
                onTap: () {
                  if (AuthController.to.checkOtpProvided()) {
                    AuthController.to.verifyEmailRequest(
                      isAccVerify:
                          arg != null && arg == verifyEmail ? true : false,
                      email:
                          arg != null && arg == verifyEmail
                              ? AuthController
                                  .to
                                  .emailSignUpController
                                  .value
                                  .text
                              : AuthController
                                  .to
                                  .emailForgetController
                                  .value
                                  .text,
                    );
                  } else {
                    showCustomSnackbar(
                      title: 'Failed',
                      message: AppStaticStrings.otpFieldRequired,
                      type: SnackBarType.failed,
                    );
                  }
                },
                title: AppStaticStrings.confirm.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

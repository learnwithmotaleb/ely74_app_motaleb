import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:market_place/presentations/auth/views/verify_otp_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../navigation/views/navigation_page.dart';
import '../views/login_page.dart';
import '../views/set_new_password_page.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 1), () {
      return showCredentialsDialog();
    });
    reinitializeSignUpControllers();

    super.onInit();
  }

  RxBool isRememberMe = false.obs;
  RxBool isCheckTermsCondition = false.obs;

  var tabContent = <Widget>[].obs;
  Rx<AuthProcess> loadingProcess = AuthProcess.none.obs;
  bool isLoading(AuthProcess process) => loadingProcess.value == process;
  bool get isAnyLoading => loadingProcess.value != AuthProcess.none;

  ///=============================controller for signUp ========================///

  Rx<TextEditingController> emailSignUpController = TextEditingController().obs;
  TextEditingController nameSignUpController = TextEditingController();
  TextEditingController phoneSignUpController = TextEditingController();
  Rx<TextEditingController> ageSignUpController = TextEditingController().obs;
  TextEditingController passSignUpController = TextEditingController();

  TextEditingController confirmPassSignUpController = TextEditingController();
  Rx<TextEditingController> emailForgetController = TextEditingController().obs;

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passLoginController = TextEditingController();

  TextEditingController passNewController = TextEditingController();

  TextEditingController confirmPassNewController = TextEditingController();

  ///------------------------------ sign up method -------------------------///
  Future<void> signUpRequest() async {
    try {
      // Set loading state for this specific process
      loadingProcess.value = AuthProcess.signUp;

      final response = await ApiService().request(
        endpoint: signupEndPoint,
        method: 'POST',
        body: {
          "name": nameSignUpController.text,
          "email": emailSignUpController.value.text,
          "phone": "000000000000",
          "password": passSignUpController.text,
          "confirm_password": confirmPassSignUpController.text,
        },
        useAuth: false,
      );

      // Clear loading state
      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        Get.toNamed(VerifyOtpPage.routeName, arguments: verifyEmail);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      loadingProcess.value = AuthProcess.none;
    }
  }

  ///------------------------------ verify email method -------------------------///
  Future<void> verifyEmailRequest({
    required String email,
    required bool isAccVerify,
  }) async {
    try {
      loadingProcess.value = AuthProcess.activateAccount;

      final response = await ApiService().request(
        endpoint: verifyEmailEndPoint,
        useAuth: false,
        method: 'POST',
        body: {
          "email": email,
          "code": otpControllers.map((e) => e.value.text).join(),
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        Boxes.getUserData().put(verifyTokenKey, response['data']['resetToken']);
        logger.d(
          Boxes.getUserData().put(
            verifyTokenKey,
            response['data']['resetToken'],
          ),
        );
        showCustomSnackbar(title: 'Success', message: response['message']);

        if (isAccVerify) {
          Get.offAllNamed(LoginPage.routeName);
        } else {
          Get.toNamed(SetNewPasswordPage.routeName);
        }
      } else {
        logger.e(response);
        clearOtp();
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
      clearOtp();
    } finally {
      loadingProcess.value = AuthProcess.none;
    }
  }

  ///------------------------------ sign in method -------------------------///
  Future<void> signInRequest() async {
    try {
      loadingProcess.value = AuthProcess.login;

      final response = await ApiService().request(
        endpoint: signInEndPoint,
        method: 'POST',
        useAuth: false,
        body: {
          "email": AuthController.to.emailLoginController.text,
          "password": AuthController.to.passLoginController.text,
        },
      );

      loadingProcess.value = AuthProcess.none;
logger.d(response);

      if (response['success'] == true) {
        logger.d(response);
        if (isRememberMe.value) {
          saveCredentials(
            AuthController.to.emailLoginController.text,
            AuthController.to.passLoginController.text,
            isRememberMe.value,
          );
        }
        showCustomSnackbar(title: 'Success', message: response['message']);
        Boxes.getUserData().put(tokenKey, response['token']);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response['token']);
        ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      await Purchases.logIn(decodedToken["id"]);
        Get.offAllNamed(NavigationPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      loadingProcess.value = AuthProcess.none;
    }
  }

  ///------------------------------ forget password method -------------------------///
  Future<void> forgetPasswordRequest({required String email}) async {
    try {
      loadingProcess.value = AuthProcess.forgetPassword;

      final response = await ApiService().request(
        endpoint: forgetPassEndPoint,
        method: 'POST',
        body: {"email": email},
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        Get.toNamed(VerifyOtpPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      loadingProcess.value = AuthProcess.none;
    }
  }

  ///------------------------------ reset password method -------------------------///
  Future<void> resetPasswordRequest() async {
    try {
      loadingProcess.value = AuthProcess.resetPassword;

      ApiService().setAuthToken(
        Boxes.getUserData().get(verifyTokenKey).toString(),
      );

      final response = await ApiService().request(
        endpoint: resetPasswordEndPoint,
        method: 'POST',
        body: {
          "confirm_password": confirmPassNewController.text,
          "password": passNewController.text,
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        ApiService().clearAuthToken();
        Get.offAllNamed(LoginPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      loadingProcess.value = AuthProcess.none;
    }
  }

  clearSignUpController() {
    emailSignUpController.value.clear();
    nameSignUpController.clear();
    passSignUpController.clear();
    confirmPassSignUpController.clear();
  }

  @override
  void onClose() {
    emailSignUpController.value.dispose();
    nameSignUpController.dispose();
    passSignUpController.dispose();
    confirmPassSignUpController.dispose();
    passNewController.dispose();
    confirmPassNewController.dispose();
    super.onClose();
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      emailSignUpController.value.text = 'vaxag42656@bamsrad.com';
      nameSignUpController.text = 'vaxag42656';
      phoneSignUpController.text = '01566026603';
      passSignUpController.text = '12345aA*';
      confirmPassSignUpController.text = '12345aA*';
      ///test  subscribed acc
      // emailLoginController.text = 'kimij58616@namestal.com';
      ///test expired subscription acc
     // emailLoginController.text = 'bifilig760@skateru.com';
       emailLoginController.text = 'seloce4741@lhory.com';
      passLoginController.text = '12345aA*';

      emailForgetController.value.text = 'seloce4741@lhory.com';
      passNewController.text = '12345aA*';
      confirmPassNewController.text = '12345aA*';
    }
  }

  ///------------------------------- OTP section ------------------------------///
  final List<Rx<TextEditingController>> otpControllers = List.generate(
    6,
    (index) => TextEditingController().obs,
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus(); // Move to next field
      }
    } else if (index > 0) {
      focusNodes[index - 1]
          .requestFocus(); // Move to previous field on backspace
    }
  }

  bool checkOtpProvided() {
    for (var controller in otpControllers) {
      if (controller.value.text.isEmpty) {
        return false; // If any field is empty, return false
      }
    }
    return true; // All fields are filled
  }

  String getOtp() {
    return otpControllers.map((e) => e.value.text).join();
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.value.clear();
    }
    focusNodes[0].requestFocus();
  }
}

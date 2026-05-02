import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:market_place/core/api-client/api_endpoints.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/hive_boxes.dart';
import 'package:market_place/presentations/profile/model/setting_model.dart';

import '../../../core/utils/variable.dart';

class PrivacyPolicyController extends GetxController {
  static PrivacyPolicyController get to => Get.find();

  Rx<SettingsModel> policyModel = SettingsModel().obs;
  Rx<SettingsModel> termsModel = SettingsModel().obs;
  RxBool isLoadingPolicy = false.obs;

  @override
  void onInit() {
    // getPrivacyPolicyRequest(endPoint: settingTermsEndPoint);
    super.onInit();
  }

  Future<void> getPrivacyPolicyRequest({required String endPoint}) async {
    try {
      isLoadingPolicy.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: endPoint,
        method: 'GET',
      );

      if (response['success'] == true) {
        logger.d(response);
        // SettingsModel genecric = endPoint==settingTermsEndPoint?termsModel.value:policyModel.value;
        policyModel.value= SettingsModel.fromJson(response['data']);
      } else if (response['message'] == AppStaticStrings.noInternet) {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
          noInternet: true,
        );
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingPolicy.value = false;
    }finally{
      isLoadingPolicy.value = false;
    }
  }
}

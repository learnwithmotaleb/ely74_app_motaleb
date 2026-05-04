import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:market_place/presentations/auth/views/login_page.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/profile/model/profile_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/common_controller.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../model/package_model.dart';
import '../views/payment_page.dart';
import '../widgets/subscription_plan_card_widget.dart';
import '../../home/model/product_model.dart';
import '../model/setting_model.dart';

class AccountInformationController extends GetxController {
  static AccountInformationController get to => Get.find();
  RxString profileImgPath = "".obs;

  RxBool isLoadingSubscribe = false.obs;
  RxBool isLoadingDeleteAcc = false.obs;
  RxBool isLoadingRenewSubscribe = false.obs;
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  var tabContent = <Widget>[].obs;
  RxBool isLoadingProfile = false.obs;
  RxBool isLoadingLogout = false.obs;

  RxBool isLoadingMyPackage = false.obs;
  RxBool isLoadingUpdateProfile = false.obs;
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  RxBool isLoadingChangePass = false.obs;
  RxList<ProductModel> favProductList = <ProductModel>[].obs;
  Rx<AuthProcess> loadingProcess = AuthProcess.none.obs;

  bool isLoading(AuthProcess process) => loadingProcess.value == process;

  ///=====================add dynmic name ====================///
  Rx<TextEditingController> nameController = TextEditingController().obs;

  ///=====================add dynmic email ====================///
  Rx<TextEditingController> emailController = TextEditingController().obs;

  ///=====================add dynmic contactNumber ====================///
  Rx<TextEditingController> contactNumberController =
      TextEditingController().obs;
  Rx<ProfileModel> userModel = ProfileModel().obs;
  Rx<MyPackageModel> packageModel = MyPackageModel().obs;

  ///====================product pagination variable========================///

  final RxInt currentFavProductPage = 1.obs;
  final RxInt itemsFavProductPerPage = 10.obs;
  final RxInt totalFavProductPages = 5.obs;
  final RxBool isFavProductLoadingMore = false.obs;
  RxBool isLoadingFavProduct = false.obs;
  RxList<String> tabLabels =
      [AppStaticStrings.monthly, AppStaticStrings.yearly].obs;
  @override
  void onInit() {
    getUserProfileRequest();
    getFavProductListRequest();
    getPackagesRequest();
    reinitializeProfileControllers();
    getUserSubscriptionPackageRequest();
    ever(packageList, (_) => updateTabContent());

    super.onInit();
  }

  ///------------------------------ get User profile method -------------------------///

  Future<void> getUserProfileRequest() async {
    try {
      isLoadingProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getProfileEndPoint,
        method: 'GET',
      );
      isLoadingProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        userModel.value = ProfileModel.fromJson(response['data']);

        if (userModel.value.img != null && userModel.value.img!.isNotEmpty) {
          await preloadImagesFromUrls([userModel.value.img.toString()]);
        }
            reinitializeProfileControllers();
      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProfile.value = false;
    }
  }

  ///------------------------------ get my subscription method -------------------------///


  Future<void> getUserSubscriptionPackageRequest() async {
    try {
      isLoadingMyPackage.value = true;

      // 1) Customer info + entitlement
      final info = await Purchases.getCustomerInfo();
      final ent = info.entitlements.all['seller_access'];

    logger.d(info);
    logger.d(ent);
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } catch (_) {
        offerings = null;
      }
      logger.d(offerings);


      // 3) স্ট্যাটাস বের করা
      final bool isActive = ent?.isActive == true;
      final bool isExpired = (ent != null && !ent.isActive && ent.expirationDate != null);

      // 4) প্রাইস নির্ধারণ (promo হলে productId ম্যাচ করবেন না)
      String? priceString;
      if (ent?.productIdentifier != null && ent?.store == Store.appStore) {
        // প্রোডাক্ট আইডি App Store-এর হলে only then match
        final pkg = _findPackageByProductId(offerings, ent!.productIdentifier);
        priceString = pkg?.storeProduct.priceString;
      }
      // fallback: current offering থেকে কোন একটা প্রাইস দেখান
      priceString ??= offerings?.current?.monthly?.storeProduct.priceString
          ?? offerings?.current?.annual?.storeProduct.priceString;

      // 5) UI মডেল সব অবস্থাতেই সেট করুন
      packageModel.value = MyPackageModel(
        type: ent?.periodType.name ?? 'N/A',        // trial / intro / normal
        isActive: isActive ? 'Active' : (isExpired ? 'Expired' : 'No Subscription'),
        price: priceString,                         // promo হলে reference price
        expiresIn: ent?.expirationDate?.toString(),
        // promo হলে productIdentifier অপ্রাসঙ্গিক, তাই null/খালি রাখুন
        subscriptionId: (ent?.store == Store.promotional) ? null : ent?.productIdentifier,
      );
    } catch (e) {
      print('Error fetching subscription info: $e');
      packageModel.value = MyPackageModel(); // safe fallback
    } finally {
      isLoadingMyPackage.value = false;
    }
  }

  /// Offerings থেকে কোনো package খুঁজে আনে যার storeProduct.identifier == productId
  Package? _findPackageByProductId(Offerings? offerings, String? productId) {
    if (offerings == null || productId == null) return null;
    // current
    final cur = offerings.current;
    for (final p in (cur?.availablePackages ?? const [])) {
      if (p.storeProduct.identifier == productId) return p;
    }
    // all offerings
    for (final off in offerings.all.values) {
      for (final p in off.availablePackages) {
        if (p.storeProduct.identifier == productId) return p;
      }
    }
    return null;
  }


  ///------------------------------ update profile method -------------------------///

  Future<void> updateProfileRequest() async {
    try {
      isLoadingUpdateProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      Map<String, String> fields = {
        'name': nameController.value.text,
        'phone': contactNumberController.value.text,
      };
      Map<String, dynamic> files = {};
      if (profileImgPath.value.isNotEmpty) {
        files['img'] = File(profileImgPath.value);
      }

      final response = await ApiService().multipartRequest(
        endpoint: updateProfileEndPoint,
        method: 'PATCH',
        fields: fields,
        files: files,
      );
      isLoadingUpdateProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        profileImgPath.value = "";
        getUserProfileRequest();
      } else {
        logger.e(response);

          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );

      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingUpdateProfile.value = false;
    }
  }

  ///------------------------------ subscribe now method -------------------------///

  Future<void> subscribeNowRequest({required String subscribeId}) async {
    try {
      isLoadingSubscribe.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: subscribeEndPoint,
        method: 'POST',
        useAuth: true,
        body: {"subscription_id": subscribeId},
      );

      isLoadingSubscribe.value = false;

      if (response['success'] == true) {
        logger.d(response);
        CommonController.to.stripeUrl.value = response["url"];
        // Get.toNamed(PaymentScreen.routeName);
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        logger.e(response);

          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );

      }
    } catch (e) {
      isLoadingSubscribe.value = false;
      logger.e(e.toString());
    }
  }

  ///------------------------------ subscribe renew method -------------------------///

  Future<void> subscribeRenewRequest({required String subscribeId}) async {
    try {
      isLoadingRenewSubscribe.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: subscribeRenewEndPoint,
        method: 'PATCH',
        useAuth: true,
        body: {"subscription_id": subscribeId},
      );

      isLoadingRenewSubscribe.value = false;

      if (response['success'] == true) {
        logger.d(response);
        CommonController.to.stripeUrl.value = response["url"];
        // Get.toNamed(PaymentScreen.routeName);
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        logger.e(response);

          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );

      }
    } catch (e) {
      isLoadingRenewSubscribe.value = false;
      logger.e(e.toString());
    }
  }

  ///------------------------------ get product list method -------------------------///

  Future<void> getFavProductListRequest({bool loadMore = false}) async {
    try {
      // Don't load more if we've reached the last page
      if (loadMore &&
          currentFavProductPage.value >= totalFavProductPages.value) {
        return;
      }

      if (loadMore) {
        isFavProductLoadingMore.value = true;
        currentFavProductPage.value++;
        // Don't increment page here - we'll do it after successful response
      } else {
        isLoadingFavProduct.value = true;
        currentFavProductPage.value = 1;
      }

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: favoriteProductEndPoint,
        method: 'GET',

        queryParams: {
          'page': currentFavProductPage.value.toString(),
          'limit': itemsFavProductPerPage.value.toString(),
        },
      );

      isLoadingFavProduct.value = false;
      isFavProductLoadingMore.value = false;

      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentFavProductPage.value =
              response['pagination']['currentPage'] ?? 1;
          totalFavProductPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line
          itemsFavProductPerPage.value =
              response['pagination']['itemsPerPage'] ?? 10;
        }

        final newProducts =
            (response['data'] as List)
                .map((e) => ProductModel.fromJson(e))
                .toList();
        final imageUrls = newProducts
            .map((cat) => "${ApiService().baseUrl}/${cat.img}")
            .where((url) => url.isNotEmpty)
            .toList();

        preloadImagesFromUrls(imageUrls);
        if (loadMore) {
          // Only increment page after successful load

          favProductList.addAll(newProducts);
        } else {
          favProductList.value = newProducts;
        }
        logger.d(response);
      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingFavProduct.value = false;
      isFavProductLoadingMore.value = false;
    }
  }

  ///------------------------------ change pass method -------------------------///

  Future<void> changePassRequest() async {
    try {
      isLoadingChangePass.value = true;
      final response = await ApiService().request(
        endpoint: changePassEndPoint,
        method: 'POST',
        body: {
          "confirm_password": confirmPasswordController.text,
          "password": newPasswordController.text,
          "old_password": currentPasswordController.text,
        },
      );
      isLoadingChangePass.value = false;
      if (response['success'] == true) {
        showCustomSnackbar(title: 'Success', message: response['message']);
        clearControllers();

        logger.d(response);
        // Get.back();
      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      isLoadingChangePass.value = false;

      logger.e(e.toString());
    }
  }

  ///------------------------------ log out method -------------------------///

  Future<void> logoutRequest() async {
    try {
      isLoadingLogout.value = true;
      final response = await ApiService().request(
        endpoint: logoutEndPoint,
        method: 'POST',
      );
      isLoadingLogout.value = false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        
        Boxes.getUserData().delete(tokenKey);
        Boxes.getAppBox().delete("shownFreeTrialPopup");
        
        try {
          await Purchases.logOut();
        } catch (e) {
          logger.e("Purchases logOut error: $e");
        }
        
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close the logout confirmation dialog
        }
        Get.offAllNamed(LoginPage.routeName);
      } else {
        logger.e(response);
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close the dialog so user isn't stuck
        }
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      isLoadingLogout.value = false;
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the dialog
      }
      logger.e(e.toString());
    }
  }


  ///-----------------------------get package list method------------------------------///

  Future<void> getPackagesRequest() async {
    try {
      loadingProcess.value = AuthProcess.packageGet;

      final response = await ApiService().request(
        endpoint: packageAllListEndPoint,
        method: 'GET',
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        packageList.value =
            (response['data'] as List)
                .map((e) => PackageModel.fromJson(e))
                .toList();
        if (packageList.isNotEmpty) {
          tabLabels.value =
              packageList.map((e) => e.type ?? "Unknown").toList();
        } else {
          tabLabels.value = [
            AppStaticStrings.monthly,
            AppStaticStrings.yearly,
          ]; // Fallback
        }
      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }

  void updateTabContent() {
    tabContent.clear();
    for (var package in packageList) {
      tabContent.add(SubscriptionPlanWidget(package: package));
    }

    if (packageList.isEmpty) {
      tabContent.addAll([
        SubscriptionPlanWidget(package: PackageModel(type: 'monthly')),
        SubscriptionPlanWidget(package: PackageModel(type: 'yearly')),
      ]);
      tabLabels.value = [AppStaticStrings.monthly, AppStaticStrings.yearly];
    } else {
      tabLabels.value = packageList.map((p) => p.type ?? 'Unknown').toList();
    }
  }

  reinitializeProfileControllers() {
    nameController.value.text = userModel.value.name ?? 'n/a';

    ///=====================add dynmic email ====================///
    emailController.value.text = userModel.value.email ?? 'n/a';

    ///=====================add dynmic contactNumber ====================///
    contactNumberController.value.text = userModel.value.phone ?? 'n/a';
  }

  clearControllers() {
    confirmPasswordController.clear();
    newPasswordController.clear();
    currentPasswordController.clear();
  }
  ///------------------------------ subscribe now method -------------------------///

  Future<void> deleteAccRequest({required String password}) async {
    try {
      isLoadingDeleteAcc.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: deleteEndPoint,
        method: 'DELETE',
        useAuth: true,
        body: {"password": password},
      );



      if (response['success'] == true) {
        logger.d(response);
logoutRequest();
        // Get.toNamed(LoginPage.routeName);
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      isLoadingDeleteAcc.value = false;
      logger.e(e.toString());
    }finally{
      isLoadingDeleteAcc.value = false;
    }
  }

}

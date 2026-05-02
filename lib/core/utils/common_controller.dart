import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_place/core/api-client/api_endpoints.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../presentations/navigation/views/navigation_page.dart';
import 'hive_boxes.dart';

class CommonController extends GetxController {
 static CommonController get to => Get.find();
 WebViewController? webController;
 var isLoading = true.obs;
 RxString stripeUrl =''.obs;
 final RxString selectedLanguageCode = 'en'.obs;


 @override
 void onInit() {
  super.onInit();
  selectedLanguageCode.value = Boxes.getSettingsData().get(
      languageKey,
      defaultValue: 'en'
  );
 }
 void initializeWebViewController() {
  if (webController != null) {
   return; // Avoid re-initialization
  }
  webController = WebViewController()
   ..setJavaScriptMode(JavaScriptMode.unrestricted)
   ..setUserAgent('Mozilla/5.0 (Mobile; rv:52.0) Gecko/52.0 Firefox/52.0')
   ..setNavigationDelegate(
    NavigationDelegate(
     onProgress: (int progress) {
      debugPrint("WebView progress: $progress");
      isLoading.value = progress < 100;
     },
     onPageStarted: (String url) {
      debugPrint("Page started loading: $url");
      isLoading.value = true;
     },
     onPageFinished: (String url) {
      debugPrint("Page finished loading: $url");
      isLoading.value = false;
     },
     onHttpError: (HttpResponseError error) {
      debugPrint("HTTP Error: $error");
     },
     onWebResourceError: (WebResourceError error) {
      debugPrint("Web Resource Error: ${error.description}");
     },

     onNavigationRequest: (NavigationRequest request) {
      /* if (request.url.startsWith("https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwj4-qy6koSLAxVLRmwGHT7zHXIQPAgI")) {
              return NavigationDecision.prevent;
            }*/
      if (request.url.contains('/payment/success')) {
       if(NavigationController.to.isLoggedIn){
        AccountInformationController.to.getUserProfileRequest();
        Get.offAllNamed(NavigationPage.routeName);
       }


      }
      return NavigationDecision.navigate;
     },
    ),
   )
   ..loadRequest(Uri.parse(stripeUrl.value));
 }
 Future<bool> getSubscriptionStatus() async {
  try {
   ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

   final response = await ApiService().request(
    endpoint: subscriptionShowEndPoint,
    method: 'GET',
   );

   // More explicit checking
   if (response['success'] == true) {
    return response['show'];
   }

   // Handle failure case
   logger.e(response);
   if (kDebugMode) {
    showCustomSnackbar(
     title: 'Failed',
     message: response['message'],
     type: SnackBarType.failed,
    );
   }
   return false;

  } catch (e) {
   logger.e(e.toString());
   return false;
  }
 }
 Future<void> changeLanguage(Locale locale) async {
  selectedLanguageCode.value = locale.languageCode;
  await Boxes.getSettingsData().put(languageKey, locale.languageCode);
  Get.updateLocale(locale);
  logger.d("Updated locale to: ${Get.locale?.languageCode}");
// This forces the entire app to rebuild
 }
}



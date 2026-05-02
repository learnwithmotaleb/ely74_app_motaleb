import 'package:get/get.dart';
import 'package:market_place/core/utils/common_controller.dart'
    show CommonController;
import 'package:market_place/core/utils/hive_boxes.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/notification/controller/notification_controller.dart';
import 'package:market_place/presentations/profile/controllers/privacy_policy_controlller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';
import 'package:market_place/presentations/splash/controller/onboarding_controller.dart';

import '../../presentations/auth/controller/auth_controller.dart';
import '../../presentations/home/controller/home_controller.dart';
import '../../presentations/message/controllers/message_controller.dart';
import '../../presentations/my-listings/controller/listings_controller.dart';
import '../../presentations/product/controller/product_controller.dart';
import '../../presentations/profile/controllers/account_information_controller.dart';
import '../../presentations/sell-now/controller/sell_controller.dart';
import '../../presentations/splash/controller/splash_controller.dart';
import '../services/app_strings.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}

class CommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommonController(), permanent: true);
    Get.put(AppTranslations());
  }
}

//
class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());

    Get.put(HomeController());
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).isNotEmpty) {
      Get.put(AccountInformationController());
      Get.put(MessageController());
      Get.put(SellController());
      Get.put(ListingsController());
    }
    // Get.lazyPut(()=>CartController());
  }
}

class ListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListingsController());
    // Get.lazyPut(()=>CartController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}

class AccountInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountInformationController());
  }
}
class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PrivacyPolicyController());
  }
}

//
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}

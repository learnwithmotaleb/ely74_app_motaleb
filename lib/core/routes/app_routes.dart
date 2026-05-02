import 'package:get/get.dart';
import 'package:market_place/core/bindings/bindings.dart';
import 'package:market_place/presentations/profile/views/payment_page.dart';
import 'package:market_place/presentations/auth/views/set_new_password_page.dart';
import 'package:market_place/presentations/profile/views/my_subscription_page.dart';
import 'package:market_place/presentations/profile/views/my_subscription_page.dart';
 import 'package:market_place/presentations/auth/views/verify_email_page.dart';
import 'package:market_place/presentations/auth/views/verify_otp_page.dart';
import 'package:market_place/presentations/home/views/category_page.dart';
import 'package:market_place/presentations/home/views/search_page.dart';
import 'package:market_place/presentations/message/views/chatting_page.dart';
import 'package:market_place/presentations/my-listings/views/listing_product_page.dart';
import 'package:market_place/presentations/notification/views/notification_page.dart';
import 'package:market_place/presentations/product/views/product_details_page.dart';
import 'package:market_place/presentations/product/views/seller_profile_page.dart';
import 'package:market_place/presentations/profile/views/account_settings_page.dart';
import 'package:market_place/presentations/profile/views/change_password_page.dart';
import 'package:market_place/presentations/profile/views/edit_profile_page.dart';
import 'package:market_place/presentations/splash/views/onboarding_page.dart';

import '../../presentations/auth/views/login_page.dart';
import '../../presentations/auth/views/signup_page.dart';
import '../../presentations/navigation/views/navigation_page.dart';
import '../../presentations/profile/views/term_policy_help_page.dart';
import '../../presentations/splash/views/splash_page.dart';

class AppRoutes {
  static route() => [
    GetPage(
      name: SplashPage.routeName,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: OnboardingPage.routeName,
      page: () => OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: LoginPage.routeName,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
GetPage(
      name: MySubscriptionPage.routeName,
      page: () => MySubscriptionPage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: SignUpPage.routeName,
      page: () => SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: VerifyEmailPage.routeName,
      page: () => VerifyEmailPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: VerifyOtpPage.routeName,
      page: () => VerifyOtpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: SetNewPasswordPage.routeName,
      page: () => SetNewPasswordPage(),
      binding: AuthBinding(),
    ),GetPage(
      name: SubscriptionPage.routeName,
      page: () => SubscriptionPage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: CategoryPage.routeName,
      page: () => CategoryPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: NavigationPage.routeName,
      page: () => NavigationPage(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: SearchPage.routeName,
      page: () => SearchPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: NotificationPage.routeName,
      page: () => NotificationPage(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: ListingProductPage.routeName,
      page: () => ListingProductPage(),
      bindings: [ListingsBinding(), AccountInformationBinding()],
    ),
    GetPage(
      name: ChattingPage.routeName,
      page: () => ChattingPage() /*binding: SettingsBinding()*/,
    ),
    GetPage(
      name: AccountSettingsPage.routeName,
      page: () => AccountSettingsPage() /*binding: SettingsBinding()*/,
    ),
    GetPage(
      name: ChangePasswordPage.routeName,
      page: () => ChangePasswordPage() /*binding: SettingsBinding()*/,
    ),
    GetPage(
      name: TermsPolicyHelpPage.routeName,
      page: () => TermsPolicyHelpPage(), binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: EditProfilePage.routeName,
      page: () => EditProfilePage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: ProductDetailsPage.routeName,
      page: () => ProductDetailsPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: SellerProfilePage.routeName,
      page: () => SellerProfilePage(),
      binding: ProductBinding(),
    ),
  ];
}

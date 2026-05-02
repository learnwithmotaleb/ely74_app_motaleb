import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/utils/enum.dart';

String dummyProfileImage =
    'https://www.webxcreation.com/event-recruitment/images/profile-1.jpg';
// String dummyImgImg ='https://images.pexels.com/photos/62613/heliconius-melpomene-butterfly-exotic-62613.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
// String dummyCatImg ='https://site-images.similarcdn.com/image?url=fpoimg.com&t=4&s=1&h=1449187c387db98af0e1271f320f3e5714296230aef41d228ed0c7fd47ea936c';
var logger = Logger(printer: PrettyPrinter());
String imageUrl =
    'https://images.pexels.com/photos/27781997/pexels-photo-27781997/free-photo-of-a-blue-butterfly-is-sitting-on-top-of-a-plant.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
String userBoxName = 'user';
String initialKey = 'initial';
String verifyEmail = 'verify email';
String tokenKey = 'token';
String subscribed = 'is_subscribed';
String verifyTokenKey = 'verify token';
// Condition options
final List<String> condition = ['NEW', 'USED'];

// Sort By options
final List<String> sortBy = [
  'Latest First',
  'Price: Low to High',
  'Price: High to Low',

];
final List<String> reportType =["SPAM", "INAPPROPRIATE", "OTHER", "FAKE", "HARASSMENT"];
List<OnboardingModel> onboardingData = [
  OnboardingModel(
      title: AppStaticStrings.discoverUniqueFinds.tr,
      message: AppStaticStrings.browseThousandsOfItems.tr,
      frontImgUrl: onboardImg1),
  OnboardingModel(
      title: AppStaticStrings.sellAnythingAnytime.tr,
      message: AppStaticStrings.sellingMadeSimple.tr,
      frontImgUrl: onboardImg2),
  OnboardingModel(
    title: AppStaticStrings.chatDealTrade.tr,
    message: AppStaticStrings.chatTrustMessage.tr,
    frontImgUrl: onboardImg3,
  ),
];

class OnboardingModel {
  final String title;
  final String message;
  final String? backgroundImgUrl;
  final String? frontImgUrl;

  OnboardingModel(
      {required this.title,
        required this.message,
        this.backgroundImgUrl,
        this.frontImgUrl});
}
class LanguageModel {
  final String name;
  final String code;

  LanguageModel({
    required this.name,
    required this.code,
  });
}
final List<LanguageModel> languageList = [
  LanguageModel(name: 'English', code: 'en'),
  LanguageModel(name: 'Français', code: 'fr'),
  LanguageModel(name: 'عربي', code: 'ar'),
];

// Category options
final List<String> category = [
  'Electronics',
  'Jewelry',
  "Men's Fashion",
  "Women's Fashion",
  'Home Decor',
  'Kitchen Tools',
  'Health Products',
  'Kids & Toys',
  'Others',
];

class MyListingsModel {
  final String img;
  final String title;
  final Status productStatus;

  MyListingsModel( {required this.img, required this.title, required this.productStatus,});
}

String dummyDesc =
    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for  will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).';
const String settingBox = 'settings';
const String authBox = 'auth';
const String languageKey = 'language';
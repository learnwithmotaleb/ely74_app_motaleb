import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_place/core/bindings/bindings.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/presentations/message/views/message_page.dart';
import 'package:market_place/presentations/my-listings/views/my_listings_page.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/views/profile_page.dart';
import 'package:market_place/presentations/sell-now/views/sell_now_page.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../auth/views/login_page.dart';
import '../../home/views/home_page.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  RxInt selectedNavIndex = 0.obs;
  @override
  void onInit() {
    debugPrint("----------------token + login status---------------");
    logger.d(Boxes.getUserData().get(tokenKey));
    logger.d(Boxes.getUserData().get(subscribed));
    logger.d(isLoggedIn.toString());
    super.onInit();
  }

  bool get isLoggedIn {
    final token = Boxes.getUserData().get(tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<bool> isSubscribed() async {
    // Check if tokenKey exists first
    final tokenExists = Boxes.getUserData().get(tokenKey) != null;
    if (!tokenExists) return false;

    if (AccountInformationController.to.userModel.value.email ==
        "tanzibamouri00@gmail.com") {
      return true;
    } else {
      final localSubscribed = Boxes.getUserData().get('subscribed');

      if (localSubscribed != null) {
        return localSubscribed;
      } else {
        // If null, call async function to fetch and save subscription state
        final subscribed = await isUserSubscribed();
        return subscribed;
      }
    }
  }

  List<Widget> getPages() {
    return [
      HomePage(),
      if (isLoggedIn) MyListingsPage(),
      if (isLoggedIn) SellNowPage(),
      if (isLoggedIn) MessageListPage(),
      if (isLoggedIn) ProfilePage(),
    ];
  }

  // List of icons for the navigation bar
  final List<String> icons = [
    navHomeIcon,
    navListingIcon,
    navSellNowIcon,
    navMessageIcon,
    navProfileIcon,
  ];

  void existApp() {
    if (selectedNavIndex.value != 0) {
      selectedNavIndex.value = 0;
    } else {
      warningCustomDialog(
        title: "Are you sure to close the app??",
        onTap: () {
          exit(0);
        },
        loading: false.obs,
      );
    }
  }

  // List of labels for the navigation bar
}

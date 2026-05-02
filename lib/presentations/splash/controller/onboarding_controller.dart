import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController{
  static OnboardingController get to => Get.find();
  Rx<PageController> pageController=PageController(initialPage: 0).obs;
  RxInt currentIndex = 0.obs;

}
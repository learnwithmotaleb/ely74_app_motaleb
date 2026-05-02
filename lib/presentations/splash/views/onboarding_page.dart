import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_text_button.dart';
import 'package:market_place/presentations/navigation/views/navigation_page.dart';


import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../auth/views/login_page.dart';
import '../controller/onboarding_controller.dart';
import '../controller/splash_controller.dart';
import '../widgets/onboarding_item_content_widget.dart';

class OnboardingPage extends StatelessWidget {
  static const String routeName = "/onboarding";
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: false,
      onPopInvokedWithResult: (didPop, result) {
if(OnboardingController.to.currentIndex.value>0){
  OnboardingController.to.pageController.value.animateToPage(
      OnboardingController.to.currentIndex.value - 1,
      duration: Duration(milliseconds: 300),
      curve: Easing.linear);
}else{
  Get.back();
}
      },
      child: Scaffold(
        appBar: AppBar(

          actions: [CustomTextButton(title: 'Skip',onPressed: () {
            Boxes.getUserData().put(initialKey, true);
 Get.offAllNamed( NavigationPage.routeName);

          },)],
        ),
        body: PageView.builder(
          controller: OnboardingController.to.pageController!.value,
          onPageChanged: (value) {

            OnboardingController.to.currentIndex.value=value;
          },
          itemCount: onboardingData.length,
          itemBuilder: (context, index) {
            return OnboardingItemContentWidget(
              onboardingModel: onboardingData[index],
            );
          },
        ),
      ),
    );
  }
}

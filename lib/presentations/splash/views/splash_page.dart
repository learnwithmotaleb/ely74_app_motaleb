import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/utils/hive_boxes.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/auth/views/login_page.dart';
import 'package:market_place/presentations/splash/views/onboarding_page.dart';

class SplashPage extends StatelessWidget {
  static const String routeName ="/";
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        Column(
          spacing: 8.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(logoIcon,height: 200.w,),
            SvgPicture.asset(appNameImg),
          ],
        ),
      ),
    );
  }
}

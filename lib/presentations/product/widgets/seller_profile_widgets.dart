import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/message/controllers/message_controller.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/navigation/views/navigation_page.dart';

class CallAndChatButtons extends StatelessWidget {
  final String number;
  final String userID;

  const CallAndChatButtons({
    super.key,
    required this.number,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        // Expanded(
        //   child: CustomButton(
        //     prefixWidget: Padding(
        //       padding: EdgeInsets.only(right: 12.w),
        //       child: SvgPicture.asset(callIcon),
        //     ),
        //     onTap: () {
        //       callOnPhone(phoneNumber: number);
        //     },
        //     title: AppStaticStrings.callNow.tr,
        //   ),
        // ),
        Expanded(
          child: Obx(() {
            return CustomButton(
              isLoading: MessageController.to.isLoadingCreateConversation.value,
              prefixWidget: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SvgPicture.asset(chatIcon),
              ),
              onTap: () {
                MessageController.to.createConversationRequest(userId: userID);
              },
              title: AppStaticStrings.chatNow.tr,
            );
          }),
        ),
      ],
    );
  }
}

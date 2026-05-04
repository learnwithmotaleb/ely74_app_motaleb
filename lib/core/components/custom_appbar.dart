import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../utils/variable.dart';

class CustomAuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  /*final String title;*/

  const CustomAuthAppbar({super.key, /*required this.title*/});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: ButtonTapWidget(
        shape: CircleBorder(),
        onTap: () {
          Get.back();
        },
        child: Padding(padding: padding8, child: SvgPicture.asset(backIcon)),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDefaultAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final Widget? titleWidget;
  final Function()? onLeading;
  final List<Widget>? action;

  const CustomDefaultAppbar({
    super.key,
    this.title,
    this.leading,
    this.action,
    this.titleWidget, this.onLeading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,

      // backgroundColor: AppColors.kPrimaryColor,
      // foregroundColor: AppColors.kWhiteColor,
      centerTitle: true,
      leading: leading ??
          ButtonTapWidget(
            shape: CircleBorder(),
            onTap: onLeading ?? () {
              Get.back();
            },
            child: Padding(padding: padding8, child: SvgPicture.asset(backIcon)),
          ),
      actions: action,
      title:
      titleWidget ??
          CustomText(
            text: title ?? "",
            style: poppinsMedium,
            fontSize: getFontSizeDefault(),
            color: Colors.black,
          ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomHomeAppbar extends StatelessWidget {
  final Function()? onActionTap;

  const CustomHomeAppbar({super.key, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actionsPadding: EdgeInsets.zero,
      // backgroundColor: AppColors.kPrimaryColor,
      // foregroundColor: AppColors.kWhiteColor,
      title: Row(
        spacing: 12.w,
        children: [
          SvgPicture.asset(
            logoIcon,

            height: kToolbarHeight - 6,
            width: kToolbarHeight - 6,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return CustomText(
                    text:
                    'Hello ${NavigationController.to.isLoggedIn? AccountInformationController.to.userModel.value
                        .name ?? "Guest User" :"User".obs}',
                    style: poppinsBold,
                    fontSize: getFontSizeSemiSmall(),
                  );
                }),
                CustomText(
                  text: 'Welcome to Bazarya',

                  style: poppinsRegular,
                  fontSize: getFontSizeSmall(),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onActionTap,
          icon: SvgPicture.asset(notificationIcon),
        ),
      ],
    );
  }
}

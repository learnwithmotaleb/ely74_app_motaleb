import 'package:market_place/core/components/custom_textfield.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/views/change_password_page.dart';
import 'package:market_place/presentations/profile/widgets/profile_action_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';

class AccountSettingsPage extends StatefulWidget {
  static const String routeName = '/acc-settings';
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomDefaultAppbar(title: AppStaticStrings.accountSetting.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding12,
          child: Column(
            spacing: 12.h,
            children: [
              ProfileActionItemWidget(
                img: chngPassIcon,
                title: AppStaticStrings.changePassword.tr,
                onTap: () => Get.toNamed(ChangePasswordPage.routeName),
              ),
              ProfileActionItemWidget(
                img: deleteIcon,
                title: AppStaticStrings.deleteAccount.tr,
                onTap:
                    () => warningCustomDialog(
                      title:
                          "Are you sure you want to permanently delete your account? This action cannot be undone.",
                      loading:
                          AccountInformationController.to.isLoadingDeleteAcc,
                      onTap: () {
                       if(formKey.currentState!.validate()) {
                          AccountInformationController.to.deleteAccRequest(
                            password: passwordController.text,
                          );
                        }
                      },
                      widget: Padding(
                        padding: padding8V,
                        child: Form(
                          key: formKey,
                          child: CustomTextField(
                            isPassword: true,
                            title: AppStaticStrings.password.tr,
                            hintText: AppStaticStrings.enterPassword.tr,
                            textEditingController: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStaticStrings.passRequired.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

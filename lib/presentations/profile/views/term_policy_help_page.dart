import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:market_place/core/api-client/api_endpoints.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:market_place/presentations/profile/controllers/privacy_policy_controlller.dart';
import 'package:market_place/presentations/profile/controllers/privacy_policy_controlller.dart';
import 'package:market_place/presentations/profile/controllers/privacy_policy_controlller.dart';

import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/pagination_loading_widget.dart';
import '../../../core/constants/text_style_constant.dart';

class TermsPolicyHelpPage extends StatefulWidget {
  static const String routeName = '/terms';
  TermsPolicyHelpPage({super.key});

  @override
  State<TermsPolicyHelpPage> createState() => _TermsPolicyHelpPageState();
}

class _TermsPolicyHelpPageState extends State<TermsPolicyHelpPage> {
  final arg = Get.arguments;
  @override
  void initState() {
    PrivacyPolicyController.to.getPrivacyPolicyRequest(
      endPoint:
          arg == AppStaticStrings.termsAndCondition.tr
              ? settingTermsEndPoint
              : settingPrivacyEndPoint,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: arg),
      body: Padding(
        padding: padding12,
        child: Obx(() {
          return PrivacyPolicyController.to.isLoadingPolicy.value
              ? PaginationLoadingWidget()
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // CustomText(text: PrivacyPolicyController.to.termsModel.value.desc.toString()),
                    HtmlWidget(
                      '''${PrivacyPolicyController.to.policyModel.value.desc}
                        ''',
                      textStyle: poppinsRegular.copyWith(
                        fontSize: getFontSizeDefault(),
                      ),
                    ),
                  ],
                ),
              );
        }),
      ),
    );
  }
}

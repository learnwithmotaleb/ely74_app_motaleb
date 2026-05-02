import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/utils/common_controller.dart';
import 'package:market_place/core/utils/variable.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageChangeDialog extends StatelessWidget {
  const LanguageChangeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: languageList.map((lang) {
            return CheckboxListTile(

              value: CommonController.to.selectedLanguageCode.value == lang.code,
              title: CustomText(text:lang.name,style: poppinsMedium,),
              onChanged: (_) async{
                await CommonController.to.changeLanguage(Locale(lang.code));
               Get.back();
              },
            );
          }).toList(),
        );
      }),
    );
  }
}

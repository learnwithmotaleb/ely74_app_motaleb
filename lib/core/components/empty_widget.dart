import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/custom_text.dart';
import '../constants/text_style_constant.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  const EmptyWidget({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/lottie/empty_list.json"),
        CustomText(text: text,style: poppinsSemiBold,)
      ],
    );
  }
}

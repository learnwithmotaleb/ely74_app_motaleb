import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/presentations/home/widgets/product_card_item_widget.dart';

class ProductDetailsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  const ProductDetailsCardWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding6V,
          child: Row(
            children: [
              Expanded(child: CustomText(text: title)),
              GreenAccentContainerWidget(
                radius: 4.r,

                child: Padding(
                  padding: padding2,
                  child: CustomText(
                    text: value,
                    fontSize: 10.sp,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

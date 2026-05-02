import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/presentations/home/controller/home_controller.dart';
import 'package:market_place/presentations/home/model/category_subcategory_model.dart';

class CategoryCardItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryCardItemWidget({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: ButtonTapWidget(
        onTap: () async{
          HomeController.to.filterOnCategory(categoryModel);

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              imageUrl: "${
              ApiService().baseUrl
              }/${categoryModel.img}",
              boxShape: BoxShape.circle,
              height: 60.w,
              width: 60.w,
            ),
            CustomText(
              textAlign: TextAlign.center,
              text: categoryModel.name??"Dummy Category",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailsCardItemWidget extends StatelessWidget {
  final  CategoryModel categoryModel;
  const CategoryDetailsCardItemWidget({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(width: .5, color: Colors.black),
      ),
      width: 110.w,
      child: ButtonTapWidget(
        onTap: () {
          HomeController.to.filterOnCategory(categoryModel);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              imageUrl: "${
                  ApiService().baseUrl
              }/${categoryModel.img}",
              height: 150.w,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
            ),
            Padding(
              padding: padding6,
              child: CustomText(
                text:categoryModel.name?? "Women's Fashion	",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

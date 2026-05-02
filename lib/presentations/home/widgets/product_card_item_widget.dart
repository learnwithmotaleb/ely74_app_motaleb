import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/components/empty_widget.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/presentations/home/model/product_model.dart';
import 'package:market_place/presentations/product/controller/product_controller.dart';
import 'package:market_place/presentations/product/views/product_details_page.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardItemWidget extends StatelessWidget {
  final bool fromSeller;
  final ProductModel product;

  const ProductCardItemWidget({
    super.key,
    this.fromSeller = false,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 24.r,
          ),
        ],
      ),
      child: ButtonTapWidget(
        radius: 4.r,
          // lib/widgets/product_card_item_widget.dart

          onTap: () {
            // Correctly check the CURRENT route
            if (Get.currentRoute == ProductDetailsPage.routeName) {
              // If we're already on a details page, replace it
              Get.offAndToNamed(ProductDetailsPage.routeName, arguments: {
                "fromSeller": fromSeller,
                "id": product.sId.toString()
              });
            } else {
              // Otherwise, push a new details page
              Get.toNamed(ProductDetailsPage.routeName, arguments: {
                "fromSeller": fromSeller,
                "id": product.sId.toString()
              });
            }
          },
        child: Padding(
          padding: padding4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomNetworkImage(
                      imageUrl: "${ApiService().baseUrl}/${product.img}",
                      // height: 150.w,
                      radius: 4.r,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 6,
                    child: GreenAccentContainerWidget(
                      child: CustomText(
                        text: product.condition.toString(),
                        style: poppinsSemiBold,
                        color: AppColors.kPrimaryColor,
                        fontSize: getFontSizeSmall(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: padding4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsSemiBold,
                    ),
                    CustomText(
                      text: product.categoryName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsRegular,
                      color: AppColors.kExtraLightTextColor,
                    ),
                    CustomText(
                      text: "UM ${product.price.toString()}",
                      maxLines: 2,
                      style: poppinsMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductGridWidget extends StatelessWidget {
  final bool fromSeller;
  final int? length;
  final List<ProductModel> productList;
  final bool isLoading; // Add loading state

  const ProductGridWidget({
    super.key,
    this.fromSeller = false,
    required this.productList,
    this.isLoading = false,
    this.length,
  });

  @override
  Widget build(BuildContext context) {
    // Show shimmer when loading or empty list
    if (isLoading) {
      return _buildShimmerGrid();
    } else if (productList.isEmpty) {
      return EmptyWidget(text: "Product List is Empty!!");
    }

    return Wrap(
       crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 8.w,
      runSpacing: 12.w,
      children: List.generate(
        length ?? productList.length,
        (index) => SizedBox(
          width:
              MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.width > 600 ? 3 : 2) -
              20.w,
          // height: 265.w, // Equivalent to mainAxisExtent
          child: ProductCardItemWidget(
            fromSeller: fromSeller,
            product: productList[index],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6, // Number of shimmer items
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 12.w,
        mainAxisExtent: 265.w,
        maxCrossAxisExtent: 210.w,
      ),
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

// Product Card Shimmer Widget
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffE8F5E9),
      highlightColor: const Color(0xffC8E6C9),
      child: Padding(
        padding: padding4,
        child: Column(
          children: [
            // Image section (flex: 3)
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Container(
                        width: 40.w,
                        height: 12.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section (flex: 2)
            Expanded(
              flex: 2,
              child: Padding(
                padding: padding4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category title (2 lines)
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Category name
                    Container(
                      height: 14.h,
                      width: 120.w,
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Price
                    Container(
                      height: 16.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GreenAccentContainerWidget extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const GreenAccentContainerWidget({
    super.key,
    required this.child,
    this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color:
            color == null
                ? AppColors.kPrimaryAccentColor
                : color!.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(radius ?? radiusCommon),
        border: Border.all(
          width: .5,
          color: color == null ? AppColors.kPrimaryColor : color!,
        ),
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/components/custom_drop_down_button.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';

import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/home/controller/home_controller.dart';

import '../constants/text_style_constant.dart';

class FilterDrawerWidget extends StatefulWidget {
  const FilterDrawerWidget({super.key});

  @override
  State<FilterDrawerWidget> createState() => _FilterDrawerWidgetState();
}

class _FilterDrawerWidgetState extends State<FilterDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.kPrimaryAccentColor,
        width: MediaQuery.sizeOf(context).width / 1.5,
        child: Padding(
          padding: padding12,
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                spacing: 12.h,
                children: [
                  CustomDropdown(
                    isLoading: HomeController.to.isLoadingCategory.value,
                    title: AppStaticStrings.category.tr,
                    items: HomeController.to.catList,
                    onChanged: (value) async{

                      if (value != null) {

                        // Clear the subcategory list first
                        HomeController.to.subCatList.clear();
                        HomeController.to.subCatList.value = [];

                        // Important: Set selectedSubCategory to null BEFORE refreshing the list
                        HomeController.to.selectedSubCategory.value = null;

                        // Set new category
                        HomeController.to.selectedCategory.value = value;

                        // Load new subcategories
                        await HomeController.to.getSubCategoryListRequest(
                          catId: value.sId.toString(),
                        );


                        // Force UI update
                        HomeController.to.subCatList.refresh();

                      }
                    },
                    displayText: (cat) => cat.name.toString(),
                    selectedValue: HomeController.to.selectedCategory.value,
                  ),
                  CustomDropdown(
                    isLoading: HomeController.to.isLoadingSubCategory.value,
                    displayText: (cat) => cat.name.toString(),
                    title: AppStaticStrings.subCategory.tr,
                    items: HomeController.to.subCatList,
                    onChanged: (value) {
                      HomeController.to.selectedSubCategory.value= value;
                    },
                    selectedValue: HomeController.to.selectedSubCategory.value,
                  ),
                  CustomDropdown(
                    isLoading: HomeController.to.isLoadingDivision.value,
                    title: AppStaticStrings.wilaya.tr,
                    items: HomeController.to.divisionList,
                    onChanged: (value) async{
                      if (value != null) {
                        // Clear the subcategory list first
                        HomeController.to.cityList.clear();
                        HomeController.to.cityList.value = [];

                        // Important: Set selectedSubCategory to null BEFORE refreshing the list
                        HomeController.to.selectedCity.value = null;

                        // Set new category
                        HomeController.to.selectedWilaya.value = value;

                        // Load new subcategories
                        await HomeController.to.getCityListRequest(
                          division: value.sId.toString(),
                        );


                        // Force UI update
                        HomeController.to.cityList.refresh();

                      }
                    },
                    displayText: (cat) => cat.name.toString(),
                    selectedValue: HomeController.to.selectedWilaya.value,
                  ),
                  CustomDropdown(
                    isLoading: HomeController.to.isLoadingCity.value,
                    displayText: (cat) => cat.name.toString(),
                    onChanged: (value) {
                      HomeController.to.selectedCity.value= value;
                    },
                    title: AppStaticStrings.city.tr,
                    items: HomeController.to.cityList,
                    selectedValue: HomeController.to.selectedCity.value,
                  ),
                  Text(
                    AppStaticStrings.priceRange.tr,
                    style: poppinsSemiBold.copyWith(
                      color: AppColors.kBlackColor,
                      fontSize: getFontSizeSemiSmall(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _priceBox(
                        "\$ ${HomeController.to.rangeValues.value.start.toInt()}",
                      ),
                      _priceBox(
                        "\$ ${HomeController.to.rangeValues.value.end.toInt()}",
                      ),
                    ],
                  ),
                  Obx(() {
                    return RangeSlider(
                      values: HomeController.to.rangeValues.value,
                      min: 0,
                      max: HomeController.to.maximumPrice.value,

                      activeColor: AppColors.kPrimaryColor, // Green track
                      inactiveColor: const Color(
                        0xFFDDE6E7,
                      ), // Light gray track
                      divisions: 100,
                      onChanged: (RangeValues values) {
                        HomeController.to.rangeValues.value = values;
                      },
                    );
                  }),
                  CustomDropdown(
                    title: AppStaticStrings.condition.tr,
                    items: condition,
                    onChanged: (value) {
                      HomeController.to.selectedCondition.value= value;
                    },
                    selectedValue: HomeController.to.selectedCondition.value,
                  ),
                  CustomDropdown(
                    title: AppStaticStrings.sortBy.tr,
                    items: sortBy,
                    onChanged: (value) {
                      HomeController.to.selectedSortBy.value= value;
                    },
                    selectedValue: HomeController.to.selectedSortBy.value,
                  ),
                  CustomButton(
                    onTap: () async{


                     await HomeController.to.getProductListRequest();
                     Navigator.pop(context);

                    },
                    title: AppStaticStrings.applyFilter.tr,
                  ),
                  CustomButton(
                    fillColor: Colors.transparent,
                    textColor: AppColors.kPrimaryColor,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: AppStaticStrings.close.tr,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _priceBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2ECC71)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: const Color(0xFF2ECC71),
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/components/custom_refresh_indicator.dart';
import 'package:market_place/core/components/filter_drawer_widget.dart';
import 'package:market_place/presentations/home/controller/home_controller.dart';
import 'package:market_place/presentations/home/widgets/product_card_item_widget.dart';

import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/padding_constant.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = "/search";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(
          () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          HomeController.to.getProductListRequest(loadMore: true);
        }
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        HomeController.to.refreshSearchHome();
      },
      child: Scaffold(
        endDrawer: FilterDrawerWidget(),
        body:  CustomRefreshIndicatorWidget(
            onRefresh:() async => await HomeController.to.refreshSearchHome(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: padding12.copyWith(
                  top: MediaQuery.of(context).viewPadding.top,
                  bottom: 6,
                ),
                child: Row(
                  spacing: 8.w,
                  children: [
                    ButtonTapWidget(
                      shape: CircleBorder(),

                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(backIcon),
                    ),
                    Expanded(
                      child: CustomTextField(
                        textEditingController: HomeController.to.searchController.value,
                        onChanged: (p0) {
                          HomeController.to.getProductListRequest();
                        },
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return ButtonTapWidget(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: SvgPicture.asset(filterIcon),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(

                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: padding12.copyWith(top: 6),
                    child:  Column(
                        spacing: 8.h,
                        children: [
                         /* !HomeController.to.showProducts.value
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 6.h,
                                children: [
                                  ViewAllRow(
                                    title: AppStaticStrings.searchHistory.tr,
                                    onPressed: () {},
                                    buttonText: AppStaticStrings.clearAll.tr,
                                  ),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.w,
                                    // alignment: WrapAlignment.spaceBetween,
                                    children: List.generate(7, (index) {
                                      return ButtonTapWidget(
                                        onTap: () {
                                          HomeController.to.showProducts.value =
                                              true;
                                        },
                                        child: GreenAccentContainerWidget(
                                          radius: 4.r,
                                          child: Padding(
                                            padding: padding4,
                                            child: CustomText(
                                              text: "Women's",
                                              style: poppinsRegular,
                                              fontSize: 10.sp,
                                              color: AppColors.kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              )
                              : SizedBox.shrink(),
                          HomeController.to.showProducts.value
                              ? */Obx(() {
                                return ProductGridWidget(
                                  productList: HomeController.to.productList,
                                  isLoading:
                                      HomeController.to.isLoadingProduct.value,
                                );
                              })
                             /* : SizedBox.shrink()*/,
                        ],
                      )
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

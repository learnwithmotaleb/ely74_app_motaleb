import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_refresh_indicator.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/utils/enum.dart';
import 'package:market_place/presentations/home/widgets/product_card_item_widget.dart';
import 'package:market_place/presentations/my-listings/controller/listings_controller.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/constants/app_static_strings.dart';
import '../../home/model/product_model.dart';
import '../../home/widgets/view_all_row_widget.dart';

class ListingProductPage extends StatefulWidget {
  static const String routeName = "/listing-product";
  const ListingProductPage({super.key});

  @override
  State<ListingProductPage> createState() => _ListingProductPageState();
}

class _ListingProductPageState extends State<ListingProductPage> {
  String? title;
  RxList<ProductModel>? products;
  RxBool? loading;
  Status? productStatus;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final arg = Get.arguments as Map<String, dynamic>;
    title = arg['title'] ?? 'Default Title';
    loading = arg['load'] ?? false;
    productStatus = arg['status'] ?? Status.pending;
    products = arg['products'] ?? <ProductModel>[].obs;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (title == AppStaticStrings.favoriteItems.tr) {
          AccountInformationController.to.getFavProductListRequest(
            loadMore: true,
          );
        } else {
          ListingsController.to.getProductListRequest(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: title.toString()),
      body: CustomRefreshIndicatorWidget(
        onRefresh: () async {
          if (title == AppStaticStrings.favoriteItems.tr) {
            AccountInformationController.to.getFavProductListRequest();
          } else {
            ListingsController.to.productStats.value = productStatus!;
            ListingsController.to.getProductListRequest();
          }
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
         slivers: [
           SliverToBoxAdapter(
             child:
             Padding(
               padding: padding12,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Obx(() {
                     return ProductGridWidget(
                       fromSeller:
                       title != AppStaticStrings.favoriteItems.tr
                           ? true
                           : false,
                       productList: products ?? [],
                       isLoading: loading!.value,
                     );
                   }),

                 ],
               ),
             ),
           )
         ],
        ),
      ),
    );
  }
}

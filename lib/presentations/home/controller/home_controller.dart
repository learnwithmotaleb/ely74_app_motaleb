import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_place/core/utils/common_controller.dart';
import 'package:market_place/presentations/home/model/category_subcategory_model.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../model/product_model.dart';
import '../views/search_page.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool showProducts = false.obs;
  final selectedCategory = Rx<CategoryModel?>(null);
  var selectedSubCategory = Rx<SubCategoryModel?>(null);
  var selectedWilaya = Rx<CategoryModel?>(null);
  var selectedCity = Rx<CityModel?>(null);
  var selectedCondition = Rx<String?>(null);
  var selectedSortBy = Rx<String?>(null);
  Rx<RangeValues> rangeValues = RangeValues(0, 1000).obs;
  RxDouble maximumPrice = 1000.00.obs;
  RxList<CategoryModel> catList = <CategoryModel>[].obs;
  RxList<CategoryModel> catListWithPagination = <CategoryModel>[].obs;
  RxList<CategoryModel> divisionList = <CategoryModel>[].obs;
  RxList<CityModel> cityList = <CityModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> productListForHome = <ProductModel>[].obs;
  RxList<ProductModel> productWithHigherPriceList = <ProductModel>[].obs;

  RxList<SubCategoryModel> subCatList = <SubCategoryModel>[].obs;

  ///=======================search controller============================///

  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxBool isLoadingProduct = false.obs;
  RxBool isLoadingHomeProduct = false.obs;
  RxBool isLoadingCategory = false.obs;
  RxBool isLoadingDivision = false.obs;
  RxBool isLoadingCity = false.obs;
  RxBool isLoadingSubCategory = false.obs;
  RxBool isLoadingFilterCategory = false.obs;
  @override
  void onInit() {
    getCategoryListRequest();
    getAllCategoryListRequestWithoutPagination();
    getProductListForHomeRequest();
    getDivisionListRequest();
    getProductListRequest();
    getMaximumRange();
    super.onInit();
  }

  Future<void> refreshSearchHome() async {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedWilaya.value = null;
    selectedCity.value = null;
    selectedCondition.value = null;
    selectedSortBy.value = null;
    getMaximumRange();
    getProductListRequest();
    CommonController.to.getSubscriptionStatus();
  }

  Future<void> refreshHome() async {
    getProductListForHomeRequest();
    getDivisionListRequest();
    getCategoryListRequest();
    getAllCategoryListRequestWithoutPagination();
  }

  getMaximumRange() async {
    final response = await ApiService().request(
      endpoint: productHigherPriceEndPoint,
      method: 'GET',
    );
    if (response['success'] == true) {
      productWithHigherPriceList.value =
          (response['data'] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();
      rangeValues.value = RangeValues(
        0,
        double.parse(productWithHigherPriceList.first.price ?? "1000"),
      );
      maximumPrice.value =double.parse(productWithHigherPriceList.first.price ?? "1000");
    } else {
      rangeValues.value = RangeValues(0, 1000);
    }
  }

  ///====================category pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalCategoryPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  ///====================product pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt itemsProductPerPage = 10.obs;
  final RxInt totalProductPages = 5.obs;
  final RxBool isProductLoadingMore = false.obs;

  ///------------------------------ get category list method -------------------------///

  Future<void> getCategoryListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentPage.value >= totalCategoryPages.value) {
        return;
      }

      if (loadMore) {
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoadingCategory.value = true;
        currentPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: catGetAllEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
          'order': 'desc',
        },
      );

      isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentPage.value = response['pagination']['currentPage'] ?? 1;
          totalCategoryPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line

          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories =
            (response['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
        final imageUrls =
            newCategories
                .map((cat) => "${ApiService().baseUrl}/${cat.img}")
                .where((url) => url.isNotEmpty)
                .toList();

        preloadImagesFromUrls(imageUrls);
        if (loadMore) {
          catListWithPagination.addAll(newCategories); // Append for load more
        } else {
          catListWithPagination.value = newCategories; // Replace for refresh
        }
        if (newCategories.isNotEmpty && catListWithPagination.isNotEmpty) {
          isLoadingCategory.value = false;
        } else if (newCategories.isEmpty) {
          isLoadingCategory.value = false;
        }
        logger.d(response);
      } else {
        isLoadingCategory.value = false;
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCategory.value = false;
    }
  }

  Future<void> getAllCategoryListRequestWithoutPagination() async {
    try {
      isLoadingCategory.value = true;

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: catGetAllEndPoint,
        method: 'GET',
        queryParams: {'sort': 'updatedAt', 'order': 'desc'},
      );

      isLoadingCategory.value = false;

      if (response['success'] == true) {
        final newCategories =
            (response['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();

        /// Replace list
        catList.value = newCategories;
        final imageUrls =
            newCategories
                .map((cat) => "${ApiService().baseUrl}/${cat.img}")
                .where((url) => url.isNotEmpty)
                .toList();
        preloadImagesFromUrls(imageUrls);
        logger.d(response);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCategory.value = false;
    }
  }

  ///------------------------------ get sub category list method -------------------------///

  Future<void> getSubCategoryListRequest({required String catId}) async {
    try {
      isLoadingSubCategory.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: subCatGetEndPoint,
        queryParams: {'category_id': catId},
        method: 'GET',
      );
      isLoadingSubCategory.value = false;
      if (response['success'] == true) {
        subCatList.value =
            (response['data'] as List)
                .map((e) => SubCategoryModel.fromJson(e))
                .toList();
        logger.d(response);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingSubCategory.value = false;
    }
  }

  ///------------------------------ get division list method -------------------------///

  Future<void> getDivisionListRequest() async {
    try {
      isLoadingDivision.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: divisionGetEndPoint,

        method: 'GET',
      );
      isLoadingDivision.value = false;
      if (response['success'] == true) {
        logger.d(response);
        divisionList.value =
            (response['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingDivision.value = false;
    }
  }

  ///------------------------------ get city list method -------------------------///

  Future<void> getCityListRequest({required String division}) async {
    try {
      isLoadingCity.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: cityGetEndPoint,
        queryParams: {'division': division},
        method: 'GET',
      );
      isLoadingCity.value = false;
      if (response['success'] == true) {
        logger.d(response);
        cityList.value =
            (response['data'] as List)
                .map((e) => CityModel.fromJson(e))
                .toList();
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCity.value = false;
    }
  }

  ///------------------------------ get product list home method -------------------------///

  Future<void> getProductListForHomeRequest() async {
    try {
      isLoadingHomeProduct.value = true;
      // ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: productGetAllEndPoint,
        useAuth: false,
        method: 'GET',
        queryParams: {'order': 'desc', 'sort': 'createdAt'},
      );
      isLoadingHomeProduct.value = false;
      if (response['success'] == true) {
        logger.d(response);
        productListForHome.value =
            (response['data'] as List)
                .map((e) => ProductModel.fromJson(e))
                .toList();
        final imageUrls =
            productListForHome
                .map((cat) => "${ApiService().baseUrl}/${cat.img}")
                .where((url) => url.isNotEmpty)
                .toList();

        preloadImagesFromUrls(imageUrls);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingHomeProduct.value = false;
    }
  }

  ///------------------------------ get product list method -------------------------///

  Future<void> getProductListRequest({bool loadMore = false}) async {
    try {
      // Don't load more if we've reached the last page
      if (loadMore && currentProductPage.value >= totalProductPages.value) {
        return;
      }

      if (loadMore) {
        isProductLoadingMore.value = true;
        currentProductPage.value++;
        // Don't increment page here - we'll do it after successful response
      } else {
        isLoadingProduct.value = true;
        currentProductPage.value = 1;
      }
      await getMaximumRange();
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: productGetAllEndPoint,
        method: 'GET',
        useAuth: false,
        queryParams: {
          'page': currentProductPage.value.toString(),
          'limit': itemsProductPerPage.value.toString(),
          'search': searchController.value.text,
          'category':
              selectedCategory.value != null
                  ? selectedCategory.value!.sId.toString()
                  : "",
          'sub_category':
              selectedSubCategory.value != null
                  ? selectedSubCategory.value!.sId.toString()
                  : "",
          'city':
              selectedCity.value != null
                  ? selectedCity.value!.sId.toString()
                  : "",
          'division':
              selectedWilaya.value != null
                  ? selectedWilaya.value!.sId.toString()
                  : "",
          'price_min': rangeValues.value.start.toString(),
          'price_max': rangeValues.value.end.toString(),
          'sort':
              selectedSortBy.value != null
                  ? selectedSortBy.value == "Price: Low to High" ||
                          selectedSortBy.value == "Price: High to Low"
                      ? "price"
                      : "createdAt"
                  : "createdAt",
          'order':
              selectedSortBy.value == "Price: Low to High" ? "asc" : "desc",
          'condition':
              selectedCondition.value != null
                  ? selectedCondition.value!.toUpperCase().toString()
                  : "",
        },
      );

      isLoadingProduct.value = false;
      isProductLoadingMore.value = false;

      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentProductPage.value = response['pagination']['currentPage'] ?? 1;
          totalProductPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line
          itemsProductPerPage.value =
              response['pagination']['itemsPerPage'] ?? 10;
        }

        final newProducts =
            (response['data'] as List)
                .map((e) => ProductModel.fromJson(e))
                .toList();
        final imageUrls =
            newProducts
                .map((cat) => "${ApiService().baseUrl}/${cat.img}")
                .where((url) => url.isNotEmpty)
                .toList();

        preloadImagesFromUrls(imageUrls);
        if (loadMore) {
          // Only increment page after successful load

          productList.addAll(newProducts);
        } else {
          productList.value = newProducts;
        }
        logger.d(response);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProduct.value = false;
      isProductLoadingMore.value = false;
    }
  }

  Future<void> filterOnCategory(CategoryModel categoryModel) async {
    isLoadingFilterCategory.value = true;
    try {
      // Update category synchronously
      selectedCategory.value = categoryModel;

      // Wait for product list to load
      await getProductListRequest();

      // Navigate after loading completes
      await Get.toNamed(SearchPage.routeName);
    } finally {
      isLoadingFilterCategory.value = false;
    }
  }
}

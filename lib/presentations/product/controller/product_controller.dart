import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../home/model/product_model.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  RxBool isLoadingProductDetails = false.obs;
  Rx<ProductDetailsModel> productModel = ProductDetailsModel().obs;
  RxList<ProductModel> relatedProductList = <ProductModel>[].obs;
  RxInt selectedImageIndex = 0.obs;
  RxBool isLoadingProduct = false.obs;
  RxBool isLoadingReport = false.obs;
  var selectedReportType = Rx<String?>(null);

  ///====================product pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt itemsProductPerPage = 10.obs;
  final RxInt totalProductPages = 5.obs;
  final RxBool isProductLoadingMore = false.obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;

  ///------------------------------ get Product Details method -------------------------///

  Future<void> getProductDetailsRequest({required String productID}) async {
    try {
      isLoadingProductDetails.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: '$productDetailsEndPoint$productID',
        method: 'GET',
        useAuth: NavigationController.to.isLoggedIn,
      );
      if (response['success'] == true) {
        logger.d(response);
        final product = ProductDetailsModel.fromJson(response['data']);
        productModel.value = product;

        // ✅ Preload product images
        if (product.img != null && product.img!.isNotEmpty) {
          // If your image URLs need base URL, add it here
          final fullImageUrls =
              product.img!.map((img) {
                return img.startsWith("http")
                    ? img
                    : "${ApiService().baseUrl}/$img";
              }).toList();

           preloadImagesFromUrls(fullImageUrls);
        }
        relatedProductList.value =
            (response['related_product'] as List)
                .map((e) => ProductModel.fromJson(e))
                .toList();
        final imageUrls = relatedProductList
            .map((cat) => "${ApiService().baseUrl}/${cat.img}")
            .where((url) => url.isNotEmpty)
            .toList();

        preloadImagesFromUrls(imageUrls);


      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }

      }
    } catch (e) {
      logger.e(e.toString());

    }finally{
      isLoadingProductDetails.value = false;

    }
  }

  ///---------------------------fav method----------------------------///

  Future<bool> favProductRequest({String? parentId}) async {
    ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

    final response = await ApiService().request(
      method: 'POST',
      useAuth: true,
      endpoint: "$productFavEndPoint$parentId",
    );

    logger.d(response);
    logger.d(parentId);
    if (response['success'] == true) {
      showCustomSnackbar(title: "Success", message: response['message']);
      // getProductDetailsRequest(productID: parentId??"");
      AccountInformationController.to.getFavProductListRequest();
      return true;
    } else {
      showCustomSnackbar(
        title: 'Failed',
        message: response['message'],
        type: SnackBarType.failed,
      );
      return false;
    }
  }


  ///---------------------------report product method----------------------------///

  Future<void> reportProductRequest({
    required String parentId,
    required String reason,
  })
  async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      isLoadingReport.value = true;

      final response = await ApiService().request(
        method: 'POST',
        useAuth: true,
        endpoint: productReportEndPoint,
        body: {
          "report_for": "PRODUCT",
          "reason": reason,
          "product": parentId,
          "type": selectedReportType.value
        },
      );

      logger.d(response);

      if (response['success'] == true) {
        showCustomSnackbar(
          title: "Success",
          message: response['message'],
        );
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e, s) {
      logger.e("Report Product Error$e $s");
      // showCustomSnackbar(
      //   title: 'Error',
      //   message: 'Something went wrong, please try again.',
      //   type: SnackBarType.failed,
      // );
    } finally {
      selectedReportType.value= null;
      isLoadingReport.value = false;
    }
  }

  ///---------------------------report user method----------------------------///

  Future<void> reportSellerRequest({
    required String userId,
    required String reason,
  })
  async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      isLoadingReport.value = true;

      final response = await ApiService().request(
        method: 'POST',
        useAuth: true,
        endpoint: productReportEndPoint,
        body: {
          "reported_user":userId,
          "report_for": "USER",
          "reason": reason,
          "type": selectedReportType.value
        },
      );

      logger.d(response);

      if (response['success'] == true) {
        showCustomSnackbar(
          title: "Success",
          message: response['message'],
        );
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e, s) {
      logger.e("Report Product Error$e $s");
      // showCustomSnackbar(
      //   title: 'Error',
      //   message: 'Something went wrong, please try again.',
      //   type: SnackBarType.failed,
      // );
    } finally {
      selectedReportType.value=null;
      isLoadingReport.value = false;
    }
  }

  ///------------------------------ get user product list method -------------------------///

  Future<void> getProductListRequest({
    bool loadMore = false,
    required String userId,
  }) async {
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

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: productGetAllEndPoint,
        method: 'GET',
        // useAuth: false,
        queryParams: {
          'page': currentProductPage.value.toString(),
          'limit': itemsProductPerPage.value.toString(),

          'order': 'desc',
          'status': "ACTIVE",
          'user': userId,
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
        final imageUrls = newProducts
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
        if(kDebugMode){
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
}

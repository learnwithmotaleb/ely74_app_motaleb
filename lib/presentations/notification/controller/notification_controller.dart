import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:market_place/presentations/profile/model/profile_model.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../home/model/product_model.dart';
import '../../notification/model/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  @override
  void onInit() {
    getNotificationRequest();
    super.onInit();
  }

  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxList<Map<String, dynamic>> localNotificationList = <Map<String, dynamic>>[].obs;
  RxBool isLoadingNotificationList = false.obs;

  @override
  void onReady() {
    loadLocalNotifications();
    super.onReady();
  }

  void loadLocalNotifications() {
    try {
      final box = Boxes.getNotificationBox();
      final logs = box.values.toList();
      
      // Convert to List<Map> and sort by date
      localNotificationList.value = logs.map((e) => Map<String, dynamic>.from(e)).toList();
      localNotificationList.sort((a, b) {
        final dateA = a['createdAt'] ?? '';
        final dateB = b['createdAt'] ?? '';
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      logger.e('Error loading local notifications: $e');
    }
  }

  ///-------------------- get Notification method ---------------------///

  Future<void> getNotificationRequest() async {
    try {
      isLoadingNotificationList.value = true;

      final response = await ApiService().request(
        endpoint: getNotificationEndPoint,
        method: 'GET',
      );
      isLoadingNotificationList.value = false;
      if (response['success'] == true) {
        logger.d(response);
        notificationList.value =
            (response["data"] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();
        
        // Sort by createdAt descending
        notificationList.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return b.createdAt!.compareTo(a.createdAt!);
        });
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
      isLoadingNotificationList.value = false;
    }
  }
}

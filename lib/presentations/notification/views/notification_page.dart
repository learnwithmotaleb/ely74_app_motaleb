import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_refresh_indicator.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/notification/controller/notification_controller.dart';
import 'package:market_place/presentations/notification/loading/notification_card_loading.dart';

import '../../../core/components/empty_widget.dart';
import '../../../core/constants/padding_constant.dart';
import '../widget/notification_card_item_widget.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = "/notification";

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: AppStaticStrings.notifications.tr),
      body: CustomRefreshIndicatorWidget(
        onRefresh: () async {
          await NotificationController.to.getNotificationRequest();
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: padding12,
                child: Obx(() {
                  final controller = NotificationController.to;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Logs',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kPrimaryTextDarkColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      controller.localNotificationList.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.localNotificationList.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final item =
                                  controller.localNotificationList[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.kPrimaryColor,
                                  child: Icon(
                                    Icons.notifications_active,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                title: Text(
                                  item['title'] ?? 'General Notification',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['message'] ?? ''),
                                    Text(
                                      dateFormateChange(
                                        date: item['createdAt'],
                                      ),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 60,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Text(
              'No notifications received yet',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

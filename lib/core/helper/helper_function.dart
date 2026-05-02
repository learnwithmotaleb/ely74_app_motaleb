import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/presentations/auth/controller/auth_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_button.dart';
import '../components/custom_button_tap.dart';
import '../constants/app_static_strings.dart';
import '../utils/hive_boxes.dart';
import '../utils/variable.dart';

void showPopupMenu(BuildContext context, Offset offset) async {
  // if (result != null) {
  //   setState(() {
  //     selectedItem = result;
  //   });
  // }
}
Future<void> preloadImagesFromUrls(List<String> imageUrls) async {
  for (var imageUrl in imageUrls) {
    if (imageUrl.isNotEmpty) {
      try {
        final imageProvider = CachedNetworkImageProvider(imageUrl);
        final completer = Completer<void>();
        bool isCompleted = false;

        imageProvider.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((_, __) {
            if (!isCompleted) {
              completer.complete();
              isCompleted = true;
            }
          }, onError: (error, stackTrace) {
            if (!isCompleted) {
              debugPrint("Error caching URL: $imageUrl / $error");
              completer.complete();
              isCompleted = true;
            }
          }),
        );

        await completer.future;
      } catch (e) {
        debugPrint("Exception while caching URL: $imageUrl / $e");
      }
    }
  }
}

Future<bool> isUserSubscribed() async {
  try {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    // Replace with your actual entitlement ID
    EntitlementInfo? entitlement = customerInfo.entitlements.all['seller_access'];
    Boxes.getUserData().put(subscribed, entitlement?.isActive ?? false);

    return entitlement?.isActive ?? false;
  } catch (e) {
    print("Error checking subscription: $e");
    return false;
  }
}

// Future<void> showPaywall() async {
//   try {
//     await RevenueCatUI.presentPaywall(displayCloseButton: true,);
//   } catch (e) {
//     print("Error presenting paywall: $e");
//   }
// }
Locale getLocaleFromHive() {
  final localeString = Boxes.getSettingsData().get(
    languageKey,
    defaultValue: "en",
  );
  if (localeString == "ar") return const Locale('ar');
  if (localeString == "fr") return const Locale('fr');
  return const Locale('en', 'US');
}
Future<void> saveCredentials(
  String email,
  String password,
  bool rememberMe,
)
async {
  if (rememberMe) {
    await Boxes.getAuthData().put('email', email);
    await Boxes.getAuthData().put('password', password);
  } else {
    await Boxes.getAuthData().delete('email');
    await Boxes.getAuthData().delete('password');
  }

  await Boxes.getAuthData().put('rememberMe', rememberMe);
}

Future<Map<String, dynamic>> getCredentials() async {
  final authBox = Boxes.getAuthData();
  final rememberMe = authBox.get('rememberMe', defaultValue: false);

  if (rememberMe) {
    return {
      'email': authBox.get('email'),
      'password': authBox.get('password'),
      'rememberMe': rememberMe,
    };
  }

  return {};
}

Future<void> showCredentialsDialog() async {
  final credentials = await getCredentials();

  if (credentials.isNotEmpty && credentials['rememberMe'] == true) {
    Get.dialog(
      AlertDialog(

        content: SizedBox(
          width: Get.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                textAlign: TextAlign.center,
                text: 'Email: ${credentials['email']}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              CustomText(
                textAlign: TextAlign.center,
                text:'Password: ${'•' * (credentials['password']?.length ?? 0)}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              space8H,
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: CustomButton(
                      textColor: AppColors.kPrimaryColor,
                      fillColor: Colors.transparent,
                      onTap: () => Get.back(),
                      title: AppStaticStrings.cancel.tr,
                    ),
                  ),
                  Expanded(
                    child:  CustomButton(
                        onTap: () {
                          AuthController.to.emailLoginController.text=credentials['email'];
                          AuthController.to.passLoginController.text=credentials['password'];

                          Get.back();
                        },
                        title: AppStaticStrings.confirm.tr,
                      )
                  ),
                ],
              ),

            ],
          ),
        ),

      ),
      barrierDismissible: true,
    );
  }
}
// Usage:

List<PopupMenuEntry<dynamic>> items = [
  PopupMenuItem(value: "Red", child: Text("Red")),
  PopupMenuItem(value: "Yellow", child: Text("Yellow")),
  PopupMenuItem(value: "Green", child: Text("Green")),
  PopupMenuItem(value: "Blue", child: Text("Blue")),
];

Future<dynamic> defaultAlertDialog(
  BuildContext context, {
  required Widget child,
  String? title,
  Color? backgroundColor,
})
{
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            title != null ? Spacer() : SizedBox.shrink(),
            title != null
                ? CustomText(
                  text: title,
                  style: poppinsMedium.copyWith(fontSize: getFontSizeLarge()),
                )
                : SizedBox.shrink(),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                CupertinoIcons.multiply,
                color: AppColors.kPrimaryDarkColor,
              ),
            ),
          ],
        ),
        content: Padding(padding: padding12H, child: child),
      );
    },
  );
}

void removeImage({
  required RxList<String> uploadImages,
  required String imagePath,
}) {
  if (uploadImages.contains(imagePath)) {
    uploadImages.remove(imagePath);
  } else {
    debugPrint("Image not found in the list.");
  }
}

void callOnPhone({required String phoneNumber}) async {
  final url = Uri.parse('tel:$phoneNumber');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<dynamic> successDialogCustom({
  required String title,
  required Function() onTap,
}) {
  return Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      contentPadding: padding12H.copyWith(bottom: 16.h),
      content: Column(
        spacing: 8.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset("assets/lottie/success.json"),
          CustomText(
            text: AppStaticStrings.success.tr,
            style: poppinsSemiBold,
            fontSize: getFontSizeExtraLarge(),
          ),
          CustomText(
            textAlign: TextAlign.center,
            text: title,
            color: AppColors.kExtraLightTextColor,
            fontSize: getFontSizeSemiSmall(),
          ),
          Container(
            width: Get.width / 3,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryDarkColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: ButtonTapWidget(
              onTap: () {
                Get.back();
                onTap();
              },
              child: Padding(
                padding: paddingH16V6,
                child: CustomText(
                  text: "Ok",
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kWhiteColor,
                  style: poppinsMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

Future<dynamic> warningCustomDialog({
  required String title,
   String? typeText,
   String? fillButtonText,
   String? outlineButtonText,
  required Function() onTap,
   Function()? onCancel,
  required RxBool loading,
  Widget? widget
}) {
  return Get.dialog(
    
    AlertDialog(
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      contentPadding: padding12H.copyWith(bottom: 16.h),
      content: SizedBox(
        width: Get.width *.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(warningIcon),
              CustomText(
                text:typeText?? AppStaticStrings.warning.tr,
                style: poppinsSemiBold,
                fontSize: getFontSizeExtraLarge(),
              ),
              CustomText(
                textAlign: TextAlign.center,
                text: title,
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              widget??SizedBox.shrink(),
              space8H,
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: CustomButton(
                      textColor: AppColors.kPrimaryColor,
                      fillColor: Colors.transparent,
                      onTap:onCancel?? () => Get.back(),
                      title:outlineButtonText?? AppStaticStrings.cancel.tr,
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return CustomButton(
                        isLoading: loading.value,
                        onTap: onTap,
                        title:fillButtonText?? AppStaticStrings.confirm.tr,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}


Future<bool> requestStoragePermission(BuildContext context) async { // <--- Added BuildContext context
  PermissionStatus status;

  // Use the passed 'context' here
  if (Theme.of(context).platform == TargetPlatform.android) { // <--- Used 'context'
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }
  } else if (Theme.of(context).platform == TargetPlatform.iOS) { // <--- Used 'context'
    status = await Permission.photos.request();
  } else {
    debugPrint("Permission handling for this platform is not explicitly defined.");
    return true;
  }

  if (status.isGranted) {
    debugPrint("Permission granted.");
    return true;
  } else if (status.isDenied) {
    debugPrint("Permission denied.");
    return false;
  } else if (status.isPermanentlyDenied) {
    debugPrint("Permission permanently denied. Opening settings.");
    openAppSettings();
    return false;
  } else if (status.isRestricted) {
    debugPrint("Permission restricted (e.g., parental controls).");
    return false;
  }
  return false;
}



Future<void> pickImages({
  required BuildContext context,
  bool allowMultiple = false,
  RxList<String>? uploadImages,
  RxString? singleImagePath,
}) async {
  final ImagePicker picker = ImagePicker();

  try {
    // Request storage permission
    // final permissionStatus = await Permission.photos.request();
    //
    // if (!permissionStatus.isGranted) {
    //   debugPrint("Storage permission not granted, cannot pick images.");
    //   return;
    // }

    if (allowMultiple) {
      final List<XFile>? images = await picker.pickMultiImage(imageQuality: 40);

      if (images != null && uploadImages != null) {
        if (uploadImages.length + images.length <= 5) {
          uploadImages.addAll(images.map((file) => file.path));
        } else {
          // showCustomSnackbar(
          //   title: "Limit Reached",
          //   message: "You can only add up to 5 images.",
          //   type: SnackBarType.alert,
          // );
        }
      }
    } else {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

      if (image != null && singleImagePath != null) {
        singleImagePath.value = image.path;
      }
    }
  } catch (e) {
    debugPrint("Image picker error: $e");
  }
}


Future<String?> selectAndFormatTime({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  try {
    final ThemeData customTimePickerTheme = Theme.of(context).copyWith(
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppColors.kPrimaryColor),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor:
            AppColors.kWhiteColor, // Background color of the dialog
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        dayPeriodColor: AppColors.kPrimaryExtraLightColor,
        dialHandColor: AppColors.kPrimaryColor,
        hourMinuteTextColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? Colors
                      .white // Text color when selected
                  : AppColors.kPrimaryTextDarkColor,
        ),
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? AppColors
                      .kPrimaryColor // Background color when selected
                  : AppColors.kPrimaryExtraLightColor,
        ),
        dialBackgroundColor:
            AppColors.kPrimaryExtraLightColor, // Dial's background color
        dialTextColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? Colors
                      .white // Dial text color when selected
                  : AppColors.kPrimaryTextDarkColor,
        ),
        entryModeIconColor:
            AppColors.kPrimaryColor, // Color of the entry mode icon
      ),
    );
    // Show time picker dialog
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(data: customTimePickerTheme, child: child!);
      },
    );

    if (pickedTime != null) {
      // Format the selected time
      final now = DateTime.now();
      final formattedTime = DateFormat.jm()
          .format(
            DateTime(
              now.year,
              now.month,
              now.day,
              pickedTime.hour,
              pickedTime.minute,
            ),
          )
          .replaceAll('\u202F', ' ');
      return formattedTime; // Return the formatted time
    } else {
      return null; // No time selected
    }
  } catch (e) {
    debugPrint('Error picking time: $e');
    return null;
  }
}Future<bool> canAccessSellerFeatures(String createdAtStr, CustomerInfo customerInfo) async {
  final DateTime createdAt = DateTime.parse(createdAtStr);
  final bool isSubscribed = customerInfo.entitlements.all['seller_access']?.isActive ?? false;
  final bool isInGracePeriod = DateTime.now().toUtc().isBefore(createdAt.add(Duration(days: 90)));

  return isSubscribed || isInGracePeriod;
}


String dateFormateChange({ String? date}) {
  if(date==null)return"n/a";
  DateTime utcTime = DateTime.parse(date).toLocal(); // Convert to local time
  String formatted = DateFormat('dd-MM-yyyy hh:mm a').format(utcTime);

  return formatted; // Output: 15-05-2025 11:42 AM
}

enum SnackBarType { success, failed, alert }

void showCustomSnackbar({
  required String title,
  required String message,
  bool noInternet = false,
  Function()? retryTap,
  SnackBarType type = SnackBarType.success,
  SnackPosition position = SnackPosition.BOTTOM, // Default position
})
{
  Color backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);
  Color textColor = Colors.black;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);

      break;
    case SnackBarType.failed:
      backgroundColor = Color(0xff8a0600);
      textColor = AppColors.kWhiteColor;

      break;
    // TODO: Handle this case.
    case SnackBarType.alert:
      backgroundColor = Color(0xffc86900);
      textColor = AppColors.kWhiteColor;
      break;
    // TODO: Handle this case.
  }
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(12),
    colorText: textColor,
    dismissDirection: DismissDirection.horizontal,
    snackPosition: position,
    duration: const Duration(seconds: 3),
    mainButton:
        noInternet == true
            ? TextButton(
              onPressed: retryTap ?? () {},
              child: CustomText(text: 'Retry', color: AppColors.kWhiteColor),
            )
            : null,
  );
}

Future<String> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    barrierDismissible: false,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.kPrimaryColor, // header background color
            onPrimary: AppColors.kPrimaryColor, // header text color
            onSurface: AppColors.kPrimaryColor, // body text color
          ),
          datePickerTheme: DatePickerThemeData(
            dayOverlayColor: const WidgetStatePropertyAll<Color>(
              AppColors.kPrimaryTextDarkColor,
            ),

            headerHelpStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
              fontSize: 16.sp,
            ),
            yearOverlayColor: const WidgetStatePropertyAll<Color>(
              AppColors.kPrimaryTextDarkColor,
            ),
            headerForegroundColor: AppColors.kPrimaryTextDarkColor,
            rangePickerHeaderForegroundColor: AppColors.kPrimaryTextDarkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
              states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kPrimaryTextDarkColor; // Change this color
              }
              return null; // Default background
            }),
            rangeSelectionBackgroundColor: AppColors.kPrimaryTextDarkColor,
            todayBackgroundColor: const WidgetStatePropertyAll<Color>(
              AppColors.kPrimaryTextDarkColor,
            ),
            yearForegroundColor: const WidgetStatePropertyAll<Color>(
              AppColors.kPrimaryTextDarkColor,
            ),
            dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
              states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kWhiteColor; // Change this color
              }
              return AppColors.kPrimaryTextDarkColor; // Default background
            }),
            todayForegroundColor: const WidgetStatePropertyAll<Color>(
              AppColors.kWhiteColor,
            ),
            confirmButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor,
              ),
            ),
            rangePickerHeaderHeadlineStyle: const TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
            ),
            rangePickerSurfaceTintColor: AppColors.kPrimaryTextDarkColor,
            cancelButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor,
              ),
            ),
            backgroundColor: AppColors.kWhiteColor,
            dividerColor: Colors.transparent,
            // todayBackgroundColor: const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            yearStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
              fontSize: 16.sp,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              fillColor: AppColors.kPrimaryTextDarkColor,
            ),
            weekdayStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor, // Color for week names
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            // rangeSelectionBackgroundColor: AppColors.kPrimaryTextDarkColor,
            headerHeadlineStyle: TextStyle(
              color:
                  AppColors
                      .kPrimaryTextDarkColor, // Color for month/year in header
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdownMenuTheme: DropdownMenuThemeData(
            textStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor, // Dropdown text color
              fontSize: 16.sp,
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    // Format the date
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    // Update the observable
    return formattedDate;
  }
  return ''; // Return null if no date is selected
}

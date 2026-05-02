// lib/services/rc_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RCService {
  RCService._();
  static final RCService I = RCService._();

  CustomerInfo? _lastInfo;

  /// init SDK – অ্যাপ স্টার্টে একবার কল করুন
  Future<void> init({
    required String iosApiKey,
    String? androidApiKey,
    String? appUserId,
    bool enableDebugLogs = false,
  }) async {
    final config = PurchasesConfiguration(
      Platform.isIOS ? iosApiKey : (androidApiKey ?? iosApiKey),

    );

    if (enableDebugLogs) {
      await Purchases.setLogLevel(LogLevel.debug);
    }
    await Purchases.configure(config);

    // entitlement আপডেট হলে লোকাল কপি রাখুন
    Purchases.addCustomerInfoUpdateListener((ci) {
      _lastInfo = ci;
      if (kDebugMode) debugPrint('RC customer info updated: ${ci.originalAppUserId}');
    });

    // প্রাইমিং
    try {
      _lastInfo = await Purchases.getCustomerInfo();
    } catch (_) {}
  }

  CustomerInfo? get currentCustomerInfo => _lastInfo;

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      if (kDebugMode) debugPrint('getOfferings error: $e');
      return null;
    }
  }

  Future<bool> purchase(Package pkg) async {
    try {
      await Purchases.purchasePackage(pkg);
      _lastInfo = await Purchases.getCustomerInfo();
      return true;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) debugPrint('purchase error: $code - $e');
      // cancel হলে false; অন্য এররে UI মেসেজ দিন
      return false;
    }
  }

  Future<bool> restore() async {
    try {
      await Purchases.restorePurchases();
      _lastInfo = await Purchases.getCustomerInfo();
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('restore error: $e');
      return false;
    }
  }

  Future<void> openManageSubscriptions() async {
    try {
      final info = _lastInfo ?? await Purchases.getCustomerInfo();
      String? urlStr = info.managementURL;
      Uri uri = urlStr != null && urlStr.isNotEmpty
          ? Uri.parse(urlStr)
          : Platform.isIOS
          ? Uri.parse('https://apps.apple.com/account/subscriptions')
          : Uri.parse('https://play.google.com/store/account/subscriptions');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('openManage error: $e');
    }
  }


}

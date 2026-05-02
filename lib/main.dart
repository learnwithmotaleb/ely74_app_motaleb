import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:market_place/core/bindings/bindings.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/routes/app_routes.dart';
import 'package:market_place/core/theme/app_theme.dart';
import 'package:market_place/core/utils/hive_boxes.dart';
import 'package:market_place/presentations/splash/views/splash_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'core/services/app_strings.dart';
import 'core/services/firebase_notification_service.dart';
import 'core/utils/variable.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Push Notifications
  await FirebaseNotificationService().initialize();
  await FirebaseNotificationService().subscribeToDefaultTopics();

  const iosApiKey = 'appl_xbXZsEllxZGZumwzNAVzqAEWNuq';
  const androidApiKey = 'goog_IoGFBfBmMJzBVoLJgkZiZmANXeB';

  await Purchases.configure(PurchasesConfiguration(
    Platform.isIOS ? iosApiKey : androidApiKey,
  ));
  await ScreenUtil.ensureScreenSize();
  await Hive.initFlutter();
  await Hive.openBox(userBoxName);
  await Hive.openBox(settingBox);
  await Hive.openBox(authBox);
  await Hive.openBox("appBox");
  await Hive.openBox("notificationBox");
  final translations = AppTranslations();
  await translations.init();
  Get.put<AppTranslations>(translations);


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
   const MyApp()
  );

  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 888),
      minTextAdapt: true,
      // useInheritedMediaQuery: true,
      builder:
          (context, child) => GetMaterialApp(
            title: 'Bazarya',
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            initialRoute: SplashPage.routeName,
            translations:
                Get.find<AppTranslations>(), // Get the initialized translations
            locale:getLocaleFromHive(),
            fallbackLocale: const Locale("en", "US"),
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('ar'),       // Arabic
              Locale('fr'),       // French
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],localeResolutionCallback: (locale, supportedLocales) {
            logger.d("Locale changed to: ${locale?.languageCode}");
            logger.d("Locale saved to: ${Boxes.getSettingsData().get(
              languageKey,
              defaultValue:"en",
            )}");
            return locale;
          },

            getPages: AppRoutes.route(),
            initialBinding: CommonBinding(),
            debugShowCheckedModeBanner: false,
          ),
    );
  }



}

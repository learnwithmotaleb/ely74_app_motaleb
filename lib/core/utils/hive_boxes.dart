import 'package:hive_flutter/hive_flutter.dart';
import 'package:market_place/core/utils/variable.dart';

class Boxes{
  static Box getUserData()=>Hive.box(userBoxName);
  static Box getAppBox()=>Hive.box("appBox");
  static Box getSettingsData()=>Hive.box(settingBox);
  static Box getAuthData()=>Hive.box(authBox);
  static Box getNotificationBox()=>Hive.box("notificationBox");
}
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  Map<String, Map<String, String>> _translations = {
    'en': {},
    'fr': {},
    'ar': {},
  };

  @override
  Map<String, Map<String, String>> get keys => _translations;

  // Initialize translations at app startup
  Future<void> init() async {
    // Load all language files
    _translations['en'] = await loadLanguage('en');
    _translations['fr'] = await loadLanguage('fr');
    _translations['ar'] = await loadLanguage('ar');

    // Update GetX with loaded translations
    Get.clearTranslations();
    Get.addTranslations(_translations);
  }

  // Load language file
  Future<Map<String, String>> loadLanguage(String locale) async {
    try {
      String jsonString = await rootBundle.loadString('assets/language/$locale.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      Map<String, String> translations = {};

      jsonMap.forEach((key, value) {
        translations[key] = value.toString();
      });

      return translations;
    } catch (e) {
      print('Error loading $locale translations: $e');
      return {};
    }
  }
}


// Now we need to modify the app initialization

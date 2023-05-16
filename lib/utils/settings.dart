import 'allpackages.dart';
import 'dart:io';
import 'dart:async';

// settingan
class AppSettings {
  static String language = 'Indonesia';
  static String arabicFont = 'LPMQ Isep Misbah';
  static double regularTextSize = 17;
  static double arabicTextSize = 24;
  static bool enableTTS = false;

  static Future loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    AppSettings.language = prefs.getString('language') ?? 'Indonesia';
    AppSettings.arabicFont = prefs.getString('arabicFont') ?? 'LPMQ Isep Misbah';
    AppSettings.regularTextSize = prefs.getDouble('regularTextSize') ?? 17;
    AppSettings.arabicTextSize = prefs.getDouble('arabicTextSize') ?? 24;
    AppSettings.enableTTS = prefs.getBool('enableTTS') ?? false;
    print('loaded setting');
  }

  static Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AppSettings.language', language);
    await prefs.setString('AppSettings.arabicFont', arabicFont);
    await prefs.setDouble('AppSettings.regularTextSize', regularTextSize);
    await prefs.setDouble('AppSettings.arabicTextSize', arabicTextSize);
    await prefs.setBool('AppSettings.enableTTS', enableTTS);
  }
}

// subcription
bool isPremium = false;

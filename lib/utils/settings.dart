import 'allpackages.dart';

// settingan
class AppSettings {
  static String language = 'Indonesia';
  static double regularTextSize = 17;
  static double arabicTextSize = 24;
  static bool enableTTS = false;

  static Future loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    AppSettings.language = prefs.getString('language') ?? 'Indonesia';
    AppSettings.regularTextSize = prefs.getDouble('regularTextSize') ?? 17;
    AppSettings.arabicTextSize = prefs.getDouble('arabicTextSize') ?? 24;
    AppSettings.enableTTS = prefs.getBool('enableTTS') ?? false;
    print('loaded setting');
  }

  static Future loadSetOnly(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    switch (setting) {
      case 'language':
        return prefs.getString('language') ?? 'Indonesia';
        break;
      case 'regularTextSize':
        return prefs.getDouble('regularTextSize') ?? 17;
        break;
      case 'arabicTextSize':
        return prefs.getDouble('arabicTextSize') ?? 24;
        break;
      case 'enableTTS':
        return prefs.getBool('enableTTS') ?? false;
        break;
      default:
        break;
    }
    print('loaded setting');
  }

  static Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AppSettings.language', language);
    await prefs.setDouble('AppSettings.regularTextSize', regularTextSize);
    await prefs.setDouble('AppSettings.arabicTextSize', arabicTextSize);
    await prefs.setBool('AppSettings.enableTTS', enableTTS);
  }
}

// subcription
bool isPremium = false;

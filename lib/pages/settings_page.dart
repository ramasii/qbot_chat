import 'package:flutter/material.dart';
import '../utils/allpackages.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 86, 100),
        title: Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          subtitleSetting("Umum", bottom: 5),
          TileSetting("Bahasa", Icons.language, AppSettings.language, _showLanguageDialog),
          TileSetting("Ukuran Teks Biasa", Icons.text_fields_rounded, AppSettings.regularTextSize.toString(), _showRegularTextSizeDialog),
          ListTile(
            leading: Icon(Icons.volume_up_rounded),
            title: Text('Auto Start TTS'),
            trailing: Switch(
              value: AppSettings.enableTTS,
              onChanged: (value) async {
                setState(() {
                  AppSettings.enableTTS = value;
                });
                await AppSettings.saveSettings();
              },
            ),
          ),
          subtitleSetting("Teks Arab", top: 5, bottom: 5),
          TileSetting("Font Arab", Icons.format_align_left_rounded, AppSettings.arabicFont, _showArabicFontDialog),
          TileSetting("Ukuran Teks Arab", Icons.text_fields_rounded, AppSettings.arabicTextSize.toString(), _showArabicTextSizeDialog),
        ],
      ),
    );
  }

  ListTile TileSetting(String judul, IconData ikon, String trailing, Function() diTap) {
    return ListTile(
          leading: Icon(ikon),
          title: Text(judul),
          trailing: textTrailing(trailing),
          onTap: () {
            diTap();
          },
        );
  }

  Container subtitleSetting(String judul, {double left = 0,double right = 0,double top = 0,double bottom = 0}) {
    return Container(
          margin: EdgeInsets.fromLTRB(left, right, top, bottom),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15)
            ),
          child: Text(judul, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[600]),),
        );
  }

  Text textTrailing(String teks) => Text(teks, style: TextStyle(color: Colors.grey[600]));

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Bahasa'),
          content: DropdownButton<String>(
            value: AppSettings.language,
            onChanged: (String? value) {
              setState(() {
                AppSettings.language = value!;
              });
            },
            items: <String>['Indonesia', 'Malaysia']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: tombol('OK'),
              onPressed: () async {
                setState(() {
                  AppSettings.language = AppSettings.language;
                });
                await AppSettings.saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showArabicFontDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Font Arab'),
          content: DropdownButton<String>(
            value: AppSettings.arabicFont,
            onChanged: (String? value) {
              setState(() {
                AppSettings.arabicFont = value!;
              });
            },
            items: <String>['LPMQ Isep Misbah', 'Al Qalam Quran Majeed', 'Hafs Arabic & Quran', 'PDMS Saleem Quran']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: tombol('OK'),
              onPressed: () async {
                setState(() {
                  AppSettings.arabicFont = AppSettings.arabicFont;
                });
                await AppSettings.saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRegularTextSizeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double initialTextSize =
        prefs.getDouble('AppSettings.regularTextSize') ?? 17;
    int selectedTextSize = initialTextSize.toInt();

    final List<int> textSizes = [10, 13, 17, 20, 23, 27, 30, 33, 37, 40];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Ukuran Teks Biasa'),
          content: DropdownButton<int>(
            value: selectedTextSize,
            onChanged: (int? value) {
              setState(() {
                selectedTextSize = value!;
              });
            },
            items: textSizes.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: tombol('OK'),
              onPressed: () async {
                setState(() {
                  AppSettings.regularTextSize = selectedTextSize.toDouble();
                });
                await AppSettings.saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showArabicTextSizeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double initialTextSize =
        prefs.getDouble('AppSettings.arabicTextSize') ?? 24;
    int selectedTextSize = initialTextSize.toInt();

    final List<int> textSizes = [20, 24, 27, 30, 33, 37, 40, 43, 47, 50];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Ukuran Teks Biasa'),
          content: DropdownButton<int>(
            value: selectedTextSize,
            onChanged: (int? value) {
              setState(() {
                selectedTextSize = value!;
              });
            },
            items: textSizes.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: tombol('OK'),
              onPressed: () async {
                setState(() {
                  AppSettings.arabicTextSize = selectedTextSize.toDouble();
                });
                await AppSettings.saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container tombol(String pesan,
      {Color warnaTombol = Colors.green, Color warnaTeks = Colors.white}) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: warnaTombol, borderRadius: BorderRadius.circular(5)),
        child: Text(
          pesan,
          style: TextStyle(color: warnaTeks),
        ));
  }
}

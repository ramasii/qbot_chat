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
          ListTile(
            title: Text('Bahasa'),
            subtitle: Text(AppSettings.language),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          ListTile(
            title: Text('Ukuran Teks Biasa'),
            subtitle: Text(AppSettings.regularTextSize.toString()),
            onTap: () {
              _showRegularTextSizeDialog();
            },
          ),
          ListTile(
            title: Text('Ukuran Teks Arab'),
            subtitle: Text(AppSettings.arabicTextSize.toString()),
            onTap: () {
              _showArabicTextSizeDialog();
            },
          ),
          ListTile(
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
        ],
      ),
    );
  }

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
              child: Text('OK'),
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
              child: Text('OK'),
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

  /* void _showArabicTextSizeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double initialTextSize =
        prefs.getDouble('AppSettings.arabicTextSize') ?? 24.0;
    double selectedTextSize = initialTextSize;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Ukuran Teks Arab'),
          content: Slider(
            value: selectedTextSize,
            min: 20,
            max: 50,
            divisions: 15,
            onChanged: (double value) {
              setState(() {
                selectedTextSize = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: tombol('OK'),
              onPressed: () async {
                setState(() {
                  AppSettings.arabicTextSize = selectedTextSize;
                });
                await AppSettings.saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */

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

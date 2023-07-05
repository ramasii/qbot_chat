import 'package:IslamBot/qbotterminal.dart';
import 'package:flutter/material.dart';
import '../utils/allpackages.dart';
import 'pages.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String selectedLanguage = AppSettings.language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              arguments: ChatPageArguments(
                peerId: '111',
                peerAvatar: 'images/app_icon.png',
                peerNickname: 'IslamBot',
              ),
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            'Pengaturan',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  arguments: ChatPageArguments(
                    peerId: '111',
                    peerAvatar: 'images/app_icon.png',
                    peerNickname: 'IslamBot',
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            subtitleSetting("Umum", bottom: 5),
            TileSetting("Bahasa", Icons.language, selectedLanguage,
                _showLanguageDialog),
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
            subtitleSetting("Font", top: 5, bottom: 5),
            TileSetting(
                "Ukuran Font Latin",
                Icons.text_fields_rounded,
                AppSettings.regularTextSize.toInt().toString(),
                _showRegularTextSizeDialog),
            TileSetting(
                "Ukuran Font Arab",
                Icons.text_fields_rounded,
                AppSettings.arabicTextSize.toInt().toString(),
                _showArabicTextSizeDialog),
            TileSetting("Font Arab", Icons.format_align_left_rounded,
                AppSettings.arabicFont, _showArabicFontDialog),
            subtitleSetting('Preview'),
            previewFrame(),
          ],
        ),
      ),
    );
  }

  Widget previewFrame() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 131, 131, 131),
                  blurRadius: 2,
                  spreadRadius: 1)
            ]),
      padding: EdgeInsets.all(10),

        child: BoldAsteris(
            text:
                '**Al-Fatihah** (Pembukaan) surat ke 1 ayat **1** juz 1 halaman 1\n \nبِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ\n \nDengan nama Allah Yang Maha Pengasih, Maha Penyayang.'),
      ),
    );
  }

  ListTile TileSetting(
      String judul, IconData ikon, String trailing, Function() diTap) {
    return ListTile(
      leading: Icon(ikon),
      title: Text(judul),
      trailing: textTrailing(trailing),
      onTap: () {
        diTap();
      },
    );
  }

  Container subtitleSetting(String judul,
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, right, top, bottom),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      child: Text(
        judul,
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[600]),
      ),
    );
  }

  Text textTrailing(String teks) =>
      Text(teks, style: TextStyle(color: Colors.grey[600]));

  void _showLanguageDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Pilih Bahasa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text('Indonesia'),
                    value: 'Indonesia',
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                      print('set ke $selectedLanguage, $value');
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Malaysia'),
                    value: 'Malaysia',
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                      print('set ke $selectedLanguage, $value');
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    setState(() {
                      AppSettings.language = selectedLanguage;
                    });
                    await AppSettings.saveSettings();
                    Navigator.of(context).pop();
                    refreshSettingPage();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showArabicFontDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Pilih Font Arab'),
            content: DropdownButton<String>(
              value: AppSettings.arabicFont,
              onChanged: (String? value) {
                setState(() {
                  AppSettings.arabicFont = value!;
                });
                print('pilih font arab: ${value}');
              },
              items: <String>[
                'LPMQ Isep Misbah',
                'Al Qalam Quran Majeed',
                'Hafs Arabic & Quran',
                'PDMS Saleem Quran'
              ].map<DropdownMenuItem<String>>((String value) {
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
                  refreshSettingPage();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showRegularTextSizeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double initialTextSize =
        prefs.getDouble('AppSettings.regularTextSize') ?? 17;
    int selectedTextSize = initialTextSize.toInt();

    final List<int> textSizes = List.generate(21, (index) => index + 10);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Pilih Ukuran Font Latin'),
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
                  refreshSettingPage();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showArabicTextSizeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double initialTextSize =
        prefs.getDouble('AppSettings.arabicTextSize') ?? 24;
    int selectedTextSize = initialTextSize.toInt();

    final List<int> textSizes = List.generate(26, (index) => index + 15);
    ;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text('Pilih Ukuran Font Arab'),
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
                  refreshSettingPage();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void refreshSettingPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
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

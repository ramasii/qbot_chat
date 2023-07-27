import 'package:IslamBot/utils/allpackages.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'dart:developer';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  String versionName = '';
  int versionCode = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionName();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            // AppLocalizations.of(context)!.language,
            'About Us',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'images/app_icon.png',
                        width: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      AppLocalizations.of(context)!.aboutUsContent,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${AppLocalizations.of(context)!.verCode}: $versionCode',
                        textAlign: TextAlign.left),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${AppLocalizations.of(context)!.verName}: $versionName',
                        textAlign: TextAlign.left),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      AppLocalizations.of(context)!.connectWithUs,
                      style: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: (() async {
                      final version = await PackageInfo.fromPlatform();
                      final emailUrl =
                          'mailto:suratkita@gmail.com?subject=IslamBot version ${version.buildNumber} (${version.version})';
                      if (await canLaunchUrl(Uri.parse(emailUrl))) {
                        await launchUrl(Uri.parse(emailUrl));
                      } else {
                        throw 'Gagal membuka Email.';
                      }
                    }),
                    leading: Icon(
                      Icons.email_rounded,
                      color: Colors.red,
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                    minLeadingWidth: 10,
                    title: Text('Hubungi Kami'),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: (() async {
                      log('web');
                      final webUrl = 'https://assalaam.ac.id/IslamBot';
                      if (await canLaunchUrl(Uri.parse(webUrl))) {
                        await launchUrl(Uri.parse(webUrl));
                      } else {
                        throw 'Gagal membuka Website.';
                      }
                    }),
                    leading: Icon(
                      Icons.public_rounded,
                      color: Colors.blue,
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                    minLeadingWidth: 10,
                    title: Text(AppLocalizations.of(context)!.islambotWeb),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: (() async {
                      log('intgr');
                      const instaUrl =
                          'https://www.instagram.com/islambotofficial';
                      if (await canLaunchUrl(Uri.parse(instaUrl))) {
                        await launchUrl(Uri.parse(instaUrl));
                      } else {
                        throw 'Gagal membuka Instagram.';
                      }
                    }),
                    leading: Icon(
                      FontAwesome5.instagram,
                      color: Color.fromARGB(255, 225, 52, 255),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                    minLeadingWidth: 10,
                    title: Text(AppLocalizations.of(context)!.instagramFoll),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: (() async {
                      log('fb');
                      const fbUrl = 'www.facebook.com/islambotofficial';
                      if (await canLaunchUrl(Uri.parse(fbUrl))) {
                        await launchUrl(Uri.parse(fbUrl));
                      } else {
                        throw 'Gagal membuka Facebook.';
                      }
                    }),
                    leading: Icon(
                      FontAwesome5.facebook,
                      color: Colors.blue,
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                    minLeadingWidth: 10,
                    title: Text(AppLocalizations.of(context)!.facebookFoll),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: (() async {
                      log('gogl pl');
                      const gplayUrl =
                          'https://play.google.com/store/apps/details?id=id.ac.assalaam.islambot';
                      if (await canLaunchUrl(Uri.parse(gplayUrl))) {
                        await launchUrl(Uri.parse(gplayUrl));
                      } else {
                        throw 'Gagal membuka email.';
                      }
                    }),
                    leading: Icon(
                      FontAwesome5.google_play,
                      color: Colors.green,
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                    minLeadingWidth: 10,
                    title: Text(AppLocalizations.of(context)!.gPlayRate),
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getVersionName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
      versionCode = int.parse(packageInfo.buildNumber);
    });
  }
}

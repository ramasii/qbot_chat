import 'package:IslamBot/providers/locale_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './constants/app_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'pages/pages.dart';
import './utils/allpackages.dart';
import './l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await AppSettings.loadSettings();
  // meminta izin akses penyimpanan
  SystemChannels.platform
      .invokeMethod('SystemNavigator.requestStoragePermissions');
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<SettingProvider>(
          create: (_) => SettingProvider(
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final Lprovider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
            title: AppConstants.appTitle,
            theme: ThemeData(
              fontFamily: "IslamBot",
              primaryColor: ColorConstants.themeColor,
              primarySwatch:
                  MaterialColor(0xfff5a623, ColorConstants.swatchColor),
            ),
            locale: Lprovider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            home: SplashPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

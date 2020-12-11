import 'dart:io';
import 'package:MyCompany/provider/screen/companyScreenChange.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';
import 'package:MyCompany/screens/splash.dart';
import 'package:MyCompany/i18n/app_localizations.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/provider/screen/loginScreenChange.dart';
import 'package:MyCompany/provider/firebase/firebaseAuth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                           //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(                  //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation);  //initialize SizerUtil
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<LoginScreenChangeProvider>(
                  create: (_) => LoginScreenChangeProvider(),
                ),
                ChangeNotifierProvider<CompanyScreenChangeProvider>(
                  create: (_) => CompanyScreenChangeProvider(),
                ),
                ChangeNotifierProvider<FirebaseAuthProvider>(
                  create: (_) => FirebaseAuthProvider(),
                ),
                ChangeNotifierProvider<LoginUserInfoProvider>(
                  create: (_) => LoginUserInfoProvider(),
                ),
                ChangeNotifierProvider<AttendanceCheck>(
                  create: (_) => AttendanceCheck(),
                ),
              ],
              child: MaterialApp(
                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('ko', 'KR'), // English
                  const Locale('en', 'US'), // German
                  // ... other locales the app supports
                ],
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: SplashPage(),
              ),
            );
          },
        );
      },
    );
  }
}
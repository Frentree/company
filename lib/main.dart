import 'dart:io';
import 'package:companyplaylist/provider/screen/companyScreenChange.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/provider/attendance/attendanceCheck.dart';
import 'package:companyplaylist/screens/login/companyCreate.dart';
import 'package:companyplaylist/screens/login/companySetMain.dart';
import 'package:companyplaylist/screens/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
  }
}
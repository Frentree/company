import 'package:companyplaylist/provider/screen/companyScreenChange.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/provider/attendance/attendanceMethod.dart';
import 'package:companyplaylist/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD

=======
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 8c171e65f8e2d5f78d8473052766fd3a2b2f1380

void main() {
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
        ChangeNotifierProvider<AttendanceMethod>(
          create: (_) => AttendanceMethod(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],
      ),
    );
  }
}
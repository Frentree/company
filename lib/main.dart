import 'package:companyplaylist/provider/screen/companyScreenChange.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/auth.dart';
import 'package:companyplaylist/screens/login/companySetMain.dart';
import 'package:companyplaylist/screens/login/signUpMain.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

//
//class MyApp extends StatelessWidget{test
//  @override
//  Widget build(BuildContext context) {
//    return MultiProvider(
//      providers: [
//        ChangeNotifierProvider(create: (_) => locator<CRUDModel>())
//      ],
//      child: MaterialApp(
//        debugShowCheckedModeBanner: false,
//        initialRoute: '/',
//        title: 'TEST',
//        onGenerateRoute: Router.generateRoute,
//      ),
//    );
//  }
//}


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
        )

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthPage(),
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
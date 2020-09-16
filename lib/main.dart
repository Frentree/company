import 'package:companyplaylist/DataModel/CRUD_model.dart';
import 'package:companyplaylist/screen/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/Src/user_provider_code.dart';
import 'package:companyplaylist/locator.dart';
import 'package:companyplaylist/DataModel/router.dart';

void main() {
  setupLocator();
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
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        home: AuthPage(),

        //달력 한국어 반영
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KO'),
        ],
      ),
    );
  }
}
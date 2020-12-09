//Flutter
import 'dart:async';

import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/auth.dart';

import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{
  startTime() async{
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AuthPage()));
  }

  @override
  void initState(){
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    _loginUserInfoProvider.loadLoginUserToPhone();
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Text(
          APP_NAME,
          style: customStyle(
            fontSize: 36,
            fontWeightName: "Bold",
            fontColor: whiteColor
          ),
        ),
      ),
    );
  }
}

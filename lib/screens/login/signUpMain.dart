//Flutter

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
//Screen
import 'package:MyCompany/screens/login/login.dart';
import 'package:MyCompany/screens/login/signUp.dart';

class SignUpMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: mainColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: appNameSizeH.h,
                    alignment: Alignment.center,
                    child: Text(
                      APP_NAME,
                      style: appNameStyle,
                    ),
                  ),
                  Container(
                    height: widgetDistanceH.h,
                  ),
                  Container(
                    height: appVersionSizeH.h,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: appVersionPaddingW.w),
                      child: Text(
                        "Release " + APP_VERSION,
                        style: appVersionStyle,
                      ),
                    ),
                  ),
                  Container(
                    height: widgetDistanceH.h,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pagePaddingW.w,
                    vertical: pagePaddingH.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(pageRadiusW.w),
                      topRight: Radius.circular(pageRadiusW.w),
                    ),
                    color: whiteColor,
                  ),
                  child: ClipRect(
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      initialRoute: "/Login",
                      routes: {
                        "/Login": (context) => LoginPage(),
                        "/SignUp": (context) => SignUpPage(),
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

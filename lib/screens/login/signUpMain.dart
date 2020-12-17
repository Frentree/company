//Flutter
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/screenSize/size.dart';

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
                    height: 13.0.h,
                    alignment: Alignment.center,
                    child: Text(
                      APP_NAME,
                      style: appNameStyle,
                    ),
                  ),
                  emptySpace,
                  Container(
                    height: 6.0.h,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w),
                      child: Text(
                        "Release " + APP_VERSION,
                        style: appVersionStyle,
                      ),
                    ),
                  ),
                  emptySpace,
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                    vertical: 3.0.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                      topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
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

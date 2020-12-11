//Flutter

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';

//Repos
import 'package:MyCompany/repos/login/loginRepository.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //TextEditingController
  TextEditingController _mailTextCon;
  TextEditingController _passwordTextCon;

  LoginRepository _loginRepository = LoginRepository();

  @override
  void initState() {
    super.initState();
    _mailTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
  }

  @override
  void dispose() {
    _mailTextCon.dispose();
    _passwordTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: pageNameSizeH.h,
                alignment: Alignment.centerLeft,
                child: Text(
                  "로그인",
                  style: customStyle(
                    fontWeightName: "Medium",
                    fontColor: blueColor,
                    fontSize: pageNameFontSize.sp,
                  ),
                ),
              ),
              Container(
                height: widgetDistanceH.h,
              ),
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mailTextCon,
                      style: customStyle(
                        fontWeightName: "Regular",
                        fontColor: mainColor,
                        fontSize: textFormFontSize.sp,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: textFormFontPaddingH.h,
                          horizontal: textFormFontPaddingW.w,
                        ),
                        hintText: "이메일",
                        hintStyle: customStyle(
                          fontWeightName: "Regular",
                          fontColor: mainColor,
                          fontSize: textFormFontSize.sp,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldUnderLine,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: widgetDistanceH.h,
                    ),
                    TextFormField(
                      controller: _passwordTextCon,
                      obscureText: true,
                      style: customStyle(
                        fontWeightName: "Regular",
                        fontColor: mainColor,
                        fontSize: textFormFontSize.sp,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: textFormFontPaddingH.h,
                          horizontal: textFormFontPaddingW.w,
                        ),
                        hintText: "비밀번호",
                        hintStyle: customStyle(
                          fontWeightName: "Regular",
                          fontColor: mainColor,
                          fontSize: textFormFontSize.sp,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldUnderLine,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: widgetButtonDistanceH.h,
              ),
              Center(
                child: Container(
                  height: buttonSizeH.h,
                  width: buttonSizeW.w,
                  child: RaisedButton(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadiusW.w),
                    ),
                    elevation: 0.0,
                    child: Text(
                      "로그인",
                      style: customStyle(
                        fontWeightName: "Medium",
                        fontColor: whiteColor,
                        fontSize: buttonFontSize.sp,
                      ),
                    ),
                    onPressed: () {
                      _loginRepository.signInWithFirebaseAuth(
                        context: context,
                        mail: _mailTextCon.text,
                        password: _passwordTextCon.text,
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: widgetDistanceH.h,
              ),
              Center(
                child: Container(
                  height: buttonSizeH.h,
                  width: buttonSizeW.w,
                  child: RaisedButton(
                    color: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadiusW.w),
                      side: BorderSide(
                        color: blueColor,
                      ),
                    ),
                    elevation: 0.0,
                    child: Text(
                      "회원가입",
                      style: customStyle(
                        fontWeightName: "Medium",
                        fontColor: blueColor,
                        fontSize: buttonFontSize.sp,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/SignUp");
                    },
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

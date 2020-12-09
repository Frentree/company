//Flutter
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/screenSize/login.dart';

//Repos
import 'package:companyplaylist/repos/login/loginRepository.dart';

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
                height: heightRatio(
                  context: context,
                  heightRatio: pageNameSizeH,
                ),
                child: Text(
                  "로그인",
                  style: customStyle(
                    fontWeightName: "Medium",
                    fontColor: blueColor,
                    fontSize: pageNameFont,
                  ),
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: distance1H,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: loginInfoSizeH,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mailTextCon,
                      decoration: InputDecoration(
                        hintText: "이메일",
                        hintStyle: customStyle(
                          fontWeightName: "Regular",
                          fontColor: mainColor,
                            fontSize: hintTextFont,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldUnderLine,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTextCon,
                      decoration: InputDecoration(
                        hintText: "비밀번호",
                        hintStyle: customStyle(
                          fontSize: hintTextFont,
                          fontWeightName: "Regular",
                          fontColor: mainColor,
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
                height: heightRatio(
                  context: context,
                  heightRatio: distance2H,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: buttonH,
                ),
                width: widthRatio(context: context, widthRatio: buttonW),
                padding: EdgeInsets.symmetric(
                    horizontal: widthRatio(context: context, widthRatio: buttonPaddingLR)),
                child: RaisedButton(
                  color: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: whiteColor,
                    ),
                  ),
                  elevation: 0.0,
                  child: Text(
                    "로그인",
                    style: customStyle(
                      fontWeightName: "Medium",
                      fontColor: whiteColor,
                      fontSize: buttonFont,
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
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: distance3H,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: buttonH,
                ),
                width: widthRatio(
                  context: context,
                  widthRatio: buttonW,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(
                    context: context,
                    widthRatio: buttonPaddingLR,
                  ),
                ),
                child: RaisedButton(
                  color: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                      fontSize: buttonFont,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/SignUp");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Flutter
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

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
                  heightRatio: 0.06,
                ),
                child: font(
                  text: "로그인",
                  textStyle: customStyle(
                    fontWeightName: "Medium",
                    fontColor: blueColor,
                  ),
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.03,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.24,
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
                  heightRatio: 0.025,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.06,
                ),
                width: widthRatio(context: context, widthRatio: 1),
                padding: EdgeInsets.symmetric(
                    horizontal: widthRatio(context: context, widthRatio: 0.2)),
                child: RaisedButton(
                  color: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: whiteColor,
                    ),
                  ),
                  elevation: 0.0,
                  child: font(
                    text: "로그인",
                    textStyle: customStyle(
                      fontWeightName: "Medium",
                      fontColor: whiteColor,
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
                  heightRatio: 0.025,
                ),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.06,
                ),
                width: widthRatio(
                  context: context,
                  widthRatio: 1,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(
                    context: context,
                    widthRatio: 0.2,
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
                  child: font(
                    text: "회원가입",
                    textStyle: customStyle(
                      fontWeightName: "Medium",
                      fontColor: blueColor,
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

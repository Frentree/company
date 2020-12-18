//Flutter
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/style.dart';

//Const
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';

//Repos
import 'package:MyCompany/repos/login/loginRepository.dart';

final word = Words();
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
                height: 5.0.h,
                alignment: Alignment.centerLeft,
                child: Text(
                  word.login(),
                  style: pageNameStyle,
                ),
              ),
              emptySpace,
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mailTextCon,
                      style: defaultRegularStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: textFormPadding,
                        hintText: word.email(),
                        hintStyle: hintStyle,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldUnderLine,
                          ),
                        ),
                      ),
                    ),
                    emptySpace,
                    TextFormField(
                      controller: _passwordTextCon,
                      obscureText: true,
                      style: defaultRegularStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: textFormPadding,
                        hintText: word.password(),
                        hintStyle: hintStyle,
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
              emptySpace,
              emptySpace,
              Center(
                child: Container(
                  height: buttonSizeH.h,
                  width: SizerUtil.deviceType == DeviceType.Tablet ? buttonSizeTW.w : buttonSizeMW.w,
                  child: RaisedButton(
                    color: blueColor,
                    shape: raisedButtonShape,
                    elevation: 0.0,
                    child: Text(
                      word.signIn(),
                      style: buttonWhiteStyle,
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
                  width: SizerUtil.deviceType == DeviceType.Tablet ? buttonSizeTW.w : buttonSizeMW.w,
                  child: RaisedButton(
                    color: whiteColor,
                    shape: raisedButtonBlueShape,
                    elevation: 0.0,
                    child: Text(
                      word.signUp(),
                      style: buttonBlueStyle,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
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

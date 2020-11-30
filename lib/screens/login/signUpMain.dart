//Flutter
import 'package:companyplaylist/consts/universalString.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Screen
import 'package:companyplaylist/screens/login/login.dart';
import 'package:companyplaylist/screens/login/signUp.dart';

class SignUpMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding : false,
      backgroundColor : mainColor,
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
                    height: heightRatio(
                      context: context,
                      heightRatio: 0.06,
                    ),
                  ),
                  Container(
                    height: heightRatio(
                      context: context,
                      heightRatio: 0.07,
                    ),
                    width: widthRatio(context: context, widthRatio: 0.6),
                    child: font(
                      text: APP_NAME,
                      textStyle: customStyle(
                        fontWeightName: "Medium",
                        fontColor: whiteColor,
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
                      heightRatio: 0.03,
                    ),
                    width: widthRatio(context: context, widthRatio: 1),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: widthRatio(context: context, widthRatio: 0.6),
                        right: widthRatio(context: context, widthRatio: 0.1),
                      ),
                      child: font(
                        text: "Release " + APP_VERSION,
                        textStyle: customStyle(
                          fontWeightName: "Regular",
                          fontColor: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: heightRatio(
                      context: context,
                      heightRatio: 0.06,
                    ),
                  ),
                ],
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.75,
                ),
                width: widthRatio(
                  context: context,
                  widthRatio: 1,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(context: context, widthRatio: 0.1),
                  vertical: heightRatio(context: context, heightRatio: 0.025),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: whiteColor,
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: "/Login",
                  routes: {
                    "/Login" : (context) => LoginPage(),
                    "/SignUp" : (context) => SignUpPage(),
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

//Flutter
import 'package:companyplaylist/consts/screenSize/signUpMain.dart';
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
                      heightRatio: distance1H,
                    ),
                  ),
                  Container(
                    height: heightRatio(
                      context: context,
                      heightRatio: appNameSizeH,
                    ),
                    child: Text(
                      APP_NAME,
                      style: customStyle(
                        fontWeightName: "Medium",
                        fontColor: whiteColor,
                        fontSize: appNameFont,
                      ),
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
                      heightRatio: appVersionSizeH,
                    ),
                    width: widthRatio(context: context, widthRatio: appVersionSizeW),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: widthRatio(context: context, widthRatio: appVersionPaddingL),
                        right: widthRatio(context: context, widthRatio: appVersionPaddingR),
                      ),
                      child: Text(
                        "Relase " + APP_VERSION,
                        style: customStyle(
                          fontWeightName: "Regular",
                          fontColor: whiteColor,
                          fontSize: appVersionFont,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: heightRatio(
                      context: context,
                      heightRatio: distance3H,
                    ),
                  ),
                ],
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: childSizeH,
                ),
                width: widthRatio(
                  context: context,
                  widthRatio: childSizeW,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(context: context, widthRatio: childPaddingLR),
                  vertical: heightRatio(context: context, heightRatio: childPaddingUD),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: whiteColor,
                ),
                child: ClipRect(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    initialRoute: "/Login",
                    routes: {
                      "/Login" : (context) => LoginPage(),
                      "/SignUp" : (context) => SignUpPage(),
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

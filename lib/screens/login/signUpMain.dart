//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Screen
import 'package:companyplaylist/screens/login/login.dart';
import 'package:companyplaylist/screens/login/signUp.dart';


class SignUpMainPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    Map<String,Widget> _page = {
      "login" : LoginPage(),
      "signUp" : SignUpPage(),
    };

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print(scaffoldKey);
        },

        child: Column(
          children: <Widget>[
            //상단 로고
            Container(
              width: customWidth(context, 1),
              height: customHeight(context, 0.25),
              decoration: BoxDecoration(
                  color: mainColor
              ),

              //앱 이름 및 버전 표시
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: customHeight(context, 0.1),
                  ),
                  Text(
                    "슬기로운 회사생활",
                    style: customStyle(20, 'Bold', whiteColor),
                  ),
                  SizedBox(
                    height: customHeight(context, 0.05),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: customWidth(context, 0.55),
                      ),
                      Text(
                        "Release 0.1.0714",
                        style: customStyle(18, 'Regular', whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //하단
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: customHeight(context, 0.03), left: customWidth(context, 0.05), right: customWidth(context, 0.05)),
                width: customWidth(context, 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    color: whiteColor
                ),
                child: SingleChildScrollView(child: _page[loginScreenChangeProvider.getPageName()]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
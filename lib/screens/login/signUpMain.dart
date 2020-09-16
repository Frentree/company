import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/screens/login/login.dart';
import 'package:companyplaylist/screens/login/signUp.dart';
import 'package:companyplaylist/screens/login/signUpCode.dart';
import 'package:companyplaylist/screens/login/companyCreate.dart';
import 'package:companyplaylist/screens/login/emailAuth.dart';

class SignUpMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    List<Widget> _page = [LoginPage(), SignUpPage(), SignUpCodePage(), CreateCompanyPage(), EamilAuthPage()];

    return Scaffold(
      backgroundColor: mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
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
                child: SingleChildScrollView(child: _page[loginScreenChangeProvider.getPageIndex()]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
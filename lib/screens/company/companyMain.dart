import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';

import 'package:companyplaylist/screens/login/login.dart';
import 'package:companyplaylist/screens/login/signUp.dart';
import 'package:companyplaylist/screens/login/signUpCode.dart';

class CompanyMainPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    List<Widget> _page = [LoginPage(), SignUpPage(), SignUpCodePage()];

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },

        child: Stack(
          children: <Widget>[
            //상단 로고
            Container(
              width: customWidth(context, 1),
              height: customHeight(context, 1),
              decoration: BoxDecoration(
                  color: mainColor
              ),

              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: customHeight(context, 0.1),
                  ),
                  Text(
                    "로그인 한 사용자 이름",
                    style: customStyle(20, 'Bold', whiteColor),
                  ),
                ],
              ),
            ),

            //하단
            Positioned(
              top: customHeight(context, 0.2),
              child: Container(
                padding: EdgeInsets.only(top: customHeight(context, 0.05), left: customWidth(context, 0.05), right: customWidth(context, 0.05)),
                width: customWidth(context, 1),
                height: customHeight(context, 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: whiteColor
                ),
                child: _page[loginScreenChangeProvider.getPageIndex()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:companyplaylist/Theme/theme.dart';
import 'package:companyplaylist/Theme/fontsize.dart';
import 'package:companyplaylist/Screen/LoginPage.dart';
import 'package:companyplaylist/Screen/SignUpCodePage.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/Src/LoginScreenChangeProvider.dart';
import 'package:companyplaylist/Screen/SignUpPage.dart';

class BackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    List<Widget> _page = [LoginPage(), SignUpCodePage(), SignUpPage()];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          //상단 로고
          Container(
            width: customWidth(context, 1),
            height: customHeight(context, 1),
            decoration: BoxDecoration(
                color: top_color
            ),

            child: Column(
              children: <Widget>[
                SizedBox(
                  height: customHeight(context, 0.1),
                ),
                Text(
                  "슬기로운 회사생활",
                  style: customStyle(20, 'Bold', white_color),
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
                      style: customStyle(18, 'Regular', white_color),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //하단
          Positioned(
            top: customHeight(context, 0.25),
            child: Container(
              padding: EdgeInsets.only(top: customHeight(context, 0.05), left: customWidth(context, 0.05), right: customWidth(context, 0.05)),
              width: customWidth(context, 1),
              height: customHeight(context, 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: white_color
              ),
              child: _page[loginScreenChangeProvider.getPageIndex()],
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:companyplaylist/Theme/theme.dart';
import 'package:companyplaylist/Theme/fontsize.dart';
import 'package:companyplaylist/Screen/LoginPage.dart';
import 'package:companyplaylist/Screen/SignUpCodePage.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/Src/LoginScreenChangeProvider.dart';
import 'package:companyplaylist/Screen/SignUpPage.dart';
import 'package:companyplaylist/Theme/ButtonWidget.dart';

class SignUpCodePage extends StatefulWidget {
  @override
  SignUpCodePageState createState() => SignUpCodePageState();
}

class SignUpCodePageState extends State<SignUpCodePage> {
  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    return Column(
      children: <Widget>[
        //상단 글자
        Text(
          "환영합니다.",
          style: customStyle(18, "Medium", blue_color),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.05),
        ),

        //코드 입력란
        Container(
          child: TextFormField(),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.4),
        ),

        //요청하기 버튼
        raisedBtn(context, 0.5, 0.07, blue_color, "요청하기", customStyle(18, "Medium", white_color), () => loginScreenChangeProvider.setPageIndex(2))
      ],
    );
  }
}
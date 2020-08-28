import 'package:flutter/material.dart';
import 'package:companyplaylist/Theme/theme.dart';
import 'package:companyplaylist/Theme/fontsize.dart';
import 'package:companyplaylist/Screen/LoginPage.dart';
import 'package:companyplaylist/Screen/SignUpCodePage.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/Src/LoginScreenChangeProvider.dart';
import 'package:companyplaylist/Screen/SignUpPage.dart';
import 'package:companyplaylist/Theme/ButtonWidget.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  //자동로그인 여부 확인 변수
  bool isAutoLogin = false;

  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //상단 글자
        Text(
          "회원가입",
          style: customStyle(18, "Medium", blue_color),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.01),
        ),

        //ID/PW 입력 란
        Container(
          child: Column(
            children: <Widget>[
              TextFormField(

              ),
              TextFormField(

              ),
              TextFormField(

              ),
              TextFormField(

              ),
              TextFormField(

              ),
            ],
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.05),
        ),

        //로그인 버튼
        Row(
          children: <Widget>[
            Spacer(),
            raisedBtn(context, 0.5, 0.07, blue_color, "로그인", customStyle(18, "Medium", white_color), null),
            Spacer(),
          ],
        ),

        //자동로그인, 회원가입 버튼
        Row(
          children: <Widget>[
            Spacer(),

            Container(
              width: customWidth(context, 0.55),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: isAutoLogin,
                          activeColor: top_color,
                          onChanged: (bool value){
                            setState(() {
                              isAutoLogin = value;
                            });
                          },
                        ),
                        Text(
                          "자동 로그인",
                          style: customStyle(15, "Regular", top_color),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: customWidth(context, 0.09),
                  ),
                  textBtn("회원가입", customStyle(15, "Regular", top_color), () => loginScreenChangeProvider.setPageIndex(1)),
                ],
              ),
            ),

            Spacer(),
          ],
        )
      ],
    );
  }
}


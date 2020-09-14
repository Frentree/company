import 'package:companyplaylist/Screen/home_page.dart';
import 'package:companyplaylist/provider/firebaseLogin.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/widgets/button.dart';
import 'package:companyplaylist/widgets/textFromField.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _idTextCon;
  TextEditingController _passwordTextCon;

  @override
  void initState(){
    super.initState();
    _idTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
  }

  @override
  void dispose(){
    _idTextCon.dispose();
    _passwordTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);
    FirebaseAuthProvider firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //상단 글자
        Text(
          "로그인",
          style: customStyle(18, "Medium", blueColor),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.01),
        ),

        //ID/PW 입력 란
        Container(
          child: Column(
            children: <Widget>[
              textFormField(_idTextCon, "이메일"),
              textFormField(_passwordTextCon, "비밀번호")
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
            loginScreenRaisedBtn(context, blueColor, "로그인", whiteColor, () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))),
            Spacer(),
          ],
        ),

        SizedBox(
          height: customHeight(context, 0.01),
        ),

        Row(
          children: <Widget>[
            Spacer(),
            loginScreenRaisedBtn(context, whiteColor, "회원가입", blueColor, ()=>loginScreenChangeProvider.setPageIndex(1)),
            Spacer(),
          ],
        ),
      ],
    );
  }
}


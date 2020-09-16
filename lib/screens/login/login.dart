//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Widget
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Screen
import 'package:companyplaylist/screens/login/signUp.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //TextEditingController
  TextEditingController _mailTextCon;
  TextEditingController _passwordTextCon;

  @override
  void initState(){
    super.initState();
    _mailTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
  }

  @override
  void dispose(){
    _mailTextCon.dispose();
    _passwordTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //화면 이동을 위한 Provider
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    //Firebase 로그인을 위한 Provider
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
              textFormField(_mailTextCon, "이메일"),
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
            loginScreenRaisedBtn(
              context,
              blueColor,
              "로그인",
              whiteColor,
              () => firebaseAuthProvider.singInWithEmail(_mailTextCon.text, _passwordTextCon.text)
            ),
            Spacer(),
          ],
        ),

        SizedBox(
          height: customHeight(context, 0.01),
        ),

        Row(
          children: <Widget>[
            Spacer(),
            loginScreenRaisedBtn(
              context,
              whiteColor,
              "회원가입",
              blueColor,
              () => loginScreenChangeProvider.setPageName("signUp")
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}


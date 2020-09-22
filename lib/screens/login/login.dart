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
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Repos
import 'package:companyplaylist/repos/login/loginRepository.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //TextEditingController
  TextEditingController _mailTextCon;
  TextEditingController _passwordTextCon;

  LoginRepository _loginRepository = LoginRepository();

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
    LoginScreenChangeProvider _loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        //상단 글자
        Text(
          "로그인",
          style: customStyle(
            fontSize: 18,
            fontWeightName: "Medium",
            fontColor: blueColor,
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.01,
          ),
        ),

        //ID/PW 입력 란
        Container(
          child: Column(
            children: <Widget>[
              textFormField(
                textEditingController: _mailTextCon,
                hintText: "이메일",
              ),
              textFormField(
                textEditingController: _passwordTextCon,
                hintText: "비밀번호",
              ),
            ],
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.05,
          ),
        ),

        //로그인 버튼
        Row(
          children: <Widget>[
            Spacer(),
            loginScreenRaisedBtn(
              context: context,
              btnColor: blueColor,
              btnText: "로그인",
              btnTextColor: whiteColor,
              btnAction: () => _loginRepository.signInWithFirebaseAuth(
                context: context,
                mail: _mailTextCon.text,
                password: _passwordTextCon.text,
              )
            ),
            Spacer(),
          ],
        ),

        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.01,
          ),
        ),

        Row(
          children: <Widget>[
            Spacer(),
            loginScreenRaisedBtn(
              context: context,
              btnColor: whiteColor,
              btnText: "회원가입",
              btnTextColor: blueColor,
              btnAction: () => _loginScreenChangeProvider.setPageName(pageName: "signUp"),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}


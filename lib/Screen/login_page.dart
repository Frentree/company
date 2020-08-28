//로그인 페이지 입니다.

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Screen
import 'package:companyplaylist/Screen/singup_page.dart';
import 'package:companyplaylist/Screen/snslogin_page.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

//Code
import 'package:companyplaylist/Src/login_code.dart';
import 'package:companyplaylist/Src/user_provider_code.dart';

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  bool autoLoginValue = false;
  LoginCheck loginCheck = LoginCheck();

  FocusNode _mailFocus;
  FocusNode _pwFocus;

  TextEditingController _mailCon;
  TextEditingController _pwCon;

  @override
  void initState(){
    super.initState();
    _mailFocus = FocusNode();
    _pwFocus = FocusNode();
    _mailCon = TextEditingController();
    _pwCon = TextEditingController();
  }

  @override
  void dispose(){
    _mailFocus.dispose();
    _pwFocus.dispose();
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: top_color,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 69,
                ),
                Text(
                  "슬기로운 회사생활",
                  style: customStyle(20, 'Bold', white_color)
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 212,
                    ),
                    Text(
                      "Release 0.1.0619",
                      style: customStyle(18, 'Regular', white_color)
                    ),
                  ],
                )
              ],
            )
          ),
          Positioned(
            top: 180,
            child: Container(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              width: 412,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: white_color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "로그인 (admin/fren1212)",
                    style: customStyle(18, 'Medium', blue_color)
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _mailCon,
                    focusNode: _mailFocus,
                    onTap: (){
                      setState(() {
                        FocusScope.of(context).requestFocus(_mailFocus);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _pwCon,
                    focusNode: _pwFocus,
                    onTap: (){
                      setState(() {
                        FocusScope.of(context).requestFocus(_pwFocus);
                      });
                    },
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                      ),
                      Container(
                        width: 200,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: red_color
                        ),

                        child: RaisedButton(
                        color: blue_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(
                            "로그인",
                            style: customStyle(18, 'Medium', white_color)
                          ),

                          onPressed: () async {
                            bool loginSuccess = false;

                            loginSuccess = await loginCheck.loginCheck(_mailCon.text, _pwCon.text);

                            if(loginSuccess){
                              if(autoLoginValue == true){
                                up.setPreferencesLoginUserEmail(_mailCon.text);
                              }
                              else{
                                up.setUser(_mailCon.text);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                      ),
                      Checkbox(
                        value: autoLoginValue,
                        activeColor: top_color,
                        onChanged: (bool value) {
                          setState(() {
                            autoLoginValue = value;
                          });
                        },
                      ),
                      Text(
                        "자동 로그인",
                        style: customStyle(15, 'Thin', top_color)
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        child: Text(
                          "회원가입",
                          style: customStyle(15, 'Thin', top_color)
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpPage()));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                      ),
                      InkWell(
                        child: Text(
                          "SNS 계정 간편 로그인",
                          style: customStyle(15, 'Thin', top_color)
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SNSLoginPage()));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
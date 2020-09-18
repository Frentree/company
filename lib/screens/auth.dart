//자동 로그인 여부를 판단하는 페이지 입니다.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screen
import 'package:companyplaylist/Screen/home_page.dart';
import 'package:companyplaylist/screens/login/signUpMain.dart';

//Code
import 'package:companyplaylist/Src/user_provider_code.dart';

class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    UserProvider up = Provider.of<UserProvider>(context);

    if(up.getUserEmail() != null){
      return HomePage();
    }

    else{
      return SignUpMainPage();
    }
  }
}
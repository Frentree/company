//자동 로그인 여부를 판단하는 페이지 입니다.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screen
import 'package:companyplaylist/screen/home_page.dart';
import 'package:companyplaylist/screen/login_page.dart';

//Code
import 'package:companyplaylist/src/user_provider_code.dart';

class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    UserProvider up = Provider.of<UserProvider>(context);

    if(up.getUserEmail() != null){
      return HomePage();
    }

    else{
      return LoginPage();
    }
  }
}
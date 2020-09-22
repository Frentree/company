//자동 로그인 여부를 판단하는 페이지 입니다.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Screen
import 'package:companyplaylist/screens/login/companySetMain.dart';
import 'package:companyplaylist/screens/login/signUpMain.dart';
import 'package:companyplaylist/screens/home/homeMain.dart';


class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);

    if(_loginUserInfoProvider.getLoginUser() != null){
      if(_loginUserInfoProvider.getLoginUser().companyCode != ""){
        return HomeMainPage();
      }
       else{
        return CompanySetMainPage();
      }
    }

    else{
      return SignUpMainPage();
    }
  }
}
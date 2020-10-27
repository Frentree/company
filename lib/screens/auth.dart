//자동 로그인 여부를 판단하는 페이지 입니다.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';



//Screen
import 'package:companyplaylist/screens/login/companySetMain.dart';

import 'package:companyplaylist/screens/login/signUpMain.dart';

import 'package:companyplaylist/screens/home/homeMain.dart';
import 'package:companyplaylist/screens/splash.dart';
import 'package:companyplaylist/models/userModel.dart';

//Utils
import 'package:companyplaylist/utils/date/dateFormat.dart';

class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    User _user = _loginUserInfoProvider.getLoginUser();

    if(_user != null){
      if(_user.companyCode != ""){
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
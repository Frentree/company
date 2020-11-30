//자동 로그인 여부를 판단하는 페이지 입니다.
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Screen
import 'package:companyplaylist/screens/login/companySetMain.dart';

import 'package:companyplaylist/screens/login/signUpMain.dart';

import 'package:companyplaylist/screens/home/homeMain.dart';
import 'package:companyplaylist/models/userModel.dart';

import 'home/waitingApproval.dart';

class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    User _loginUser = _loginUserInfoProvider.getLoginUser();

    if(_loginUser != null){
      if(_loginUser.companyCode != ""){
        if(_loginUser.state != 0){
          return HomeMainPage();
        }
        else{
          return WaitingApprovalPage();
        }
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
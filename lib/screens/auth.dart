//자동 로그인 여부를 판단하는 페이지 입니다.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';

//Screen
import 'package:companyplaylist/screens/login/companySetMain.dart';
import 'package:companyplaylist/screens/login/signUpMain.dart';

//Code
import 'package:companyplaylist/Src/user_provider_code.dart';

class AuthPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context);

    if(_firebaseAuthProvider.getUser() != null){
      return CompanySetMain();
    }

    else{
      return SignUpMainPage();
    }
  }
}
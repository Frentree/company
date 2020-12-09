//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/firebase/firebaseAuth.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';

//Repos
import 'package:MyCompany/repos/showSnackBarMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';

//Model
import 'package:MyCompany/models/userModel.dart';

class SignInMethod{
  FirebaseRepository _repository = FirebaseRepository();

  Future<void> signInWithFirebaseAuth({BuildContext context, String mail, String password}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);

    User _loginUser;

    if(mail != "" && password != ""){
      bool _signInEmailResult = await _firebaseAuthProvider.singInWithEmail(mail: mail, password: password);
      if(_signInEmailResult == true){
        _loginUser = await _repository.getUser(userMail: mail);
        _loginUserInfoProvider.saveLoginUserToPhone(context: context, value: _loginUser);
      }

      else{
        showLastFirebaseMessage(
          context: context,
          lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage()
        );
      }
    }

    else{
      showFunctionErrorMessage(
        context: context,
        errorMessage: "로그인 정보를 입력하세요!"
      );
    }
  }
}


//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/CrudRepository.dart';
import 'package:companyplaylist/repos/showSnackBarMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

Future<void> signUp(BuildContext context, String smsCode, String mail, String password, User user) async {
  print("회원가입 메소드 실행");
  print("코드값 $smsCode");
  print("이메일 $mail");
  print("비밀번호 $password");
  print("사용자 $user");

  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();

  LoginScreenChangeProvider _loginScreenChangeProvider = LoginScreenChangeProvider();
  CrudRepository _userCrud = CrudRepository();
  print(_firebaseAuthProvider.verificationId);
  bool _codeConfirmResult = await _firebaseAuthProvider.isVerifySuccess(smsCode);
  print("코드 인증값 확인 $_codeConfirmResult");

  if(_codeConfirmResult == true){

    bool _signUpEmailResult = await _firebaseAuthProvider.signUpWithEmail(mail, password);
    if(_signUpEmailResult == true){
      _userCrud.addUserDataToFirebase(user);
      _loginScreenChangeProvider.setPageName("login");
    }
    else{
      showLastFirebaseMessage(context, _firebaseAuthProvider.manageErrorMessage());
    }
  }
  else{
    showLastFirebaseMessage(context, _firebaseAuthProvider.manageErrorMessage());
  }
}
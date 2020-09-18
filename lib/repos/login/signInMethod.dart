//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Repos
import 'package:companyplaylist/repos/showSnackBarMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/CrudRepository.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class SignInMethod{
  Future<void> signInWithFirebaseAuth(BuildContext context, String mail, String password) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    CrudRepository _crudRepository = CrudRepository();

    User _loginUser;

    if(mail != "" && password != ""){
      bool _signInEmailResult = await _firebaseAuthProvider.singInWithEmail(mail, password);
      if(_signInEmailResult == true){
        _loginUser = await _crudRepository.getUserDataToFirebaseById(mail);
        _loginUserInfoProvider.setLoginUser(_loginUser);
      }
      else{
        showLastFirebaseMessage(context, _firebaseAuthProvider.manageErrorMessage());
      }
    }
    else{
      showFunctionErrorMessage(context, "로그인 정보를 입력하세요!");
    }
  }
}


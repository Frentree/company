//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Repos
import 'package:companyplaylist/repos/showSnackBarMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class SignInMethod{
  Future<void> signInWithFirebaseAuth({BuildContext context, String mail, String password}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    CrudRepository _crudRepository = CrudRepository.userAttendance();

    User _loginUser;

    if(mail != "" && password != ""){
      bool _signInEmailResult = await _firebaseAuthProvider.singInWithEmail(mail: mail, password: password);
      if(_signInEmailResult == true){
        _loginUser = await _crudRepository.getUserDataToFirebaseById(documentId: mail);
        _loginUserInfoProvider.saveLoginUserToPhone(value: _loginUser);
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


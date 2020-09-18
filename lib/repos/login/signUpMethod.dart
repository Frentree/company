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

class SignUpMethod{
  Future<void> signUpWithFirebaseAuth(BuildContext context, String smsCode, String mail, String password, String name, User user) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    LoginScreenChangeProvider _loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context, listen: false);
    CrudRepository _userCrud = CrudRepository();
    print(_firebaseAuthProvider.verificationId);
    bool _codeConfirmResult = await _firebaseAuthProvider.isVerifySuccess(smsCode);

    if(_codeConfirmResult == true){

      bool _signUpEmailResult = await _firebaseAuthProvider.signUpWithEmail(mail, password, name);
      if(_signUpEmailResult == true){
        _userCrud.setUserDataToFirebase(user, mail);
        showFunctionSuccessMessage(context, "회원가입을 축하합니다!");
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
}

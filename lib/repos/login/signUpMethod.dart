//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/repos/showSnackBarMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class SignUpMethod{
  Future<void> signUpWithFirebaseAuth({BuildContext context, String smsCode, String mail, String password, String name, User user}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    LoginScreenChangeProvider _loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context, listen: false);
    CrudRepository _crudRepository = CrudRepository();

    bool _codeConfirmResult = await _firebaseAuthProvider.isVerifySuccess(smsCode: smsCode);

    if(_codeConfirmResult == true){
      bool _signUpEmailResult = await _firebaseAuthProvider.signUpWithEmail(mail: mail, password: password, name: name);
      if(_signUpEmailResult == true){
        _crudRepository.setUserDataToFirebase(
          dataModel: user,
          documentId: mail
        );

        showFunctionSuccessMessage(
          context: context,
          successMessage: "회원가입을 축하합니다!"
        );

        _loginScreenChangeProvider.setPageName(pageName: "login");
      }

      else{
        showLastFirebaseMessage(
          context: context,
          lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage()
        );
      }
    }

    else{
      showLastFirebaseMessage(
        context: context,
        lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage()
      );
    }
  }
}

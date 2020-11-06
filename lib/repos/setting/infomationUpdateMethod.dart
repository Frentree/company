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

class InfomationUpdateMethod{
  Future<void>

  InfomationUpdateWithFirebaseAuth({BuildContext context, String mail, String password, String name}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    LoginScreenChangeProvider _loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context, listen: false);
    CrudRepository _crudRepository = CrudRepository();
    bool _signUpEmailResult = await _firebaseAuthProvider.signUpWithEmail(mail: mail, password: password, name: name);

    if(_signUpEmailResult == true){
      showFunctionSuccessMessage(
          context: context,
          successMessage: "비밀번호가 변경되었습니다."
      );
      _loginScreenChangeProvider.setPageName(pageName: "login");
    }else{
      showLastFirebaseMessage(
          context: context,
          lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage()
      );
    }
  }
}

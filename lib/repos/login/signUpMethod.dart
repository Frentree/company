//Flutter
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';

//Repos
import 'package:companyplaylist/repos/showSnackBarMethod.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';

class SignUpMethod {
  Format _format = Format();

  Future<void> signUpWithFirebaseAuth(
      {BuildContext context,
      String smsCode,
      String password,
      User user}) async {
    FirebaseAuthProvider _firebaseAuthProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);

    FirebaseRepository _repository = FirebaseRepository();

    bool _codeConfirmResult = await _firebaseAuthProvider.isVerifySuccess(
      smsCode: smsCode,
    );

    if (_codeConfirmResult == true) {
      bool _signUpEmailResult = await _firebaseAuthProvider.signUpWithEmail(
        mail: user.mail,
        password: password,
        name: user.name,
      );
      if (_signUpEmailResult == true) {
        user.createDate = _format.dateTimeToTimeStamp(DateTime.now());
        user.lastModDate = _format.dateTimeToTimeStamp(DateTime.now());
        _repository.saveUser(
          userModel: user,
        );

        showFunctionSuccessMessage(
            context: context, successMessage: "회원가입을 축하합니다!");
      } else {
        showLastFirebaseMessage(
            context: context,
            lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage());
      }
    } else {
      showLastFirebaseMessage(
          context: context,
          lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage());
    }
  }
}

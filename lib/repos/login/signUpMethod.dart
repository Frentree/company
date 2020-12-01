//Flutter
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<void> signUpWithFirebaseAuth(
      {BuildContext context,
      String smsCode,
      String password,
      User user}) async {

    Format _format = Format();

    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    StorageReference storageReference =
    _firebaseStorage.ref().child("defaultImage/defaultImage.png");

    String ImageURL = await storageReference.getDownloadURL();

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
        user.profilePhoto = ImageURL;
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

//Flutter
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging _fcm = FirebaseMessaging();

  Future<void> signInWithFirebaseAuth({BuildContext context, String mail, String password}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);

    User _loginUser;

    if(mail != "" && password != ""){
      bool _signInEmailResult = await _firebaseAuthProvider.singInWithEmail(mail: mail, password: password);
      if(_signInEmailResult == true){
        _loginUser = await _repository.getUser(userMail: mail);;
        _loginUserInfoProvider.saveLoginUserToPhone(context: context, value: _loginUser);
        if(_loginUser.state == 1){
          String token = await _fcm.getToken();
          _repository.updateToken(
            companyCode: _loginUser.companyCode,
            mail: _loginUser.mail,
            token: token,
          );

          List<WorkModel> _workModel = await _repository.getWorkForAlarm(companyCode: _loginUser.companyCode, userMail: _loginUser.mail);

          _workModel.forEach((element) async {
            await notificationPlugin.scheduleNotification(
              alarmId: element.alarmId,
              alarmTime: element.startTime.toDate(),
              title: "일정이 있습니다.",
              contents:
              "일정 내용 : ${element.title}",
              payload: element.alarmId.toString(),
            );
          });

        }
      } else{
        showLastFirebaseMessage(
          context: context,
          lastFirebaseMessage: _firebaseAuthProvider.manageErrorMessage()
        );
      }
    } else{
      showFunctionErrorMessage(
        context: context,
        errorMessage: "로그인 정보를 입력하세요!"
      );
    }
  }
}


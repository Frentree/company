//Flutter
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/firebase/firebaseAuth.dart';
import 'package:MyCompany/provider/screen/loginScreenChange.dart';

//Repos
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/repos/showSnackBarMethod.dart';

//Model
import 'package:MyCompany/models/userModel.dart';

class myInfomationMethod{
  Future<bool> InfomationConfirmWithFirebaseAuth({BuildContext context, String mail, String password, String name}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    print("메일 => " + mail + ", 패스워드 => " + password + ", 이름 => " + name);

    bool _signUpEmailResult = await _firebaseAuthProvider.confirmPassword(mail: mail, password: password, name: name);

    return _signUpEmailResult;
  }

  Future<bool> InfomationUpdateWithFirebaseAuth({BuildContext context, String mail, String newPassword, String newPasswordConfirm, String name}) async {
    LoginRepository _loginRepository = LoginRepository();

    String pwdMsg = _loginRepository.validationRegExpCheckMessage(
        field: "비밀번호", value: newPassword
    );

    // 다이얼로그 타이틀과 내용
    String pwdMsgTitle = "";
    String pwdMsgCon = "";
    bool isPwd = false;
    bool signUpEmailResult;
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    LoginScreenChangeProvider _loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context, listen: false);

    print("메일 => " + mail + ", 패스워드 => " + newPassword + ", 패스워드 확인 => " + newPasswordConfirm + ", 이름 => " + name);


    if(newPassword == ""){  // 패스워드 입력 안함
      pwdMsgTitle = "비밀번호 변경 실패";
      pwdMsgCon = "패스워드를 입력해주세요.";
    } else if (pwdMsg != null){
      pwdMsgTitle = "비밀번호 변경 실패";
      pwdMsgCon = "영문 + 숫자 포함 최소 6자리 이상 입력 해주세요.";
    } else if (newPassword != newPasswordConfirm) { // 변경할 패스워드가 서로 다른경우
      pwdMsgTitle = "비밀번호 변경 실패";
      pwdMsgCon = "입력한 패스워드가 서로 다릅니다. \n다시 확인해 주세요.";
    } else {
      pwdMsgTitle = "비밀번호 변경";
      pwdMsgCon = "비밀번호를 변경하시겠습니까?";
      isPwd = true;
    }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              pwdMsgTitle,
              style: customStyle(
                  fontColor: redColor,
                  fontSize: 13,
                  fontWeightName: 'Bold'
              ),
            ),
            content: Text(
              pwdMsgCon,
              style: customStyle(
                  fontColor: mainColor,
                  fontSize: 13,
                  fontWeightName: 'Regular'),
            ),
            actions: isPwd == true? <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: customStyle(
                      fontColor: blueColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'),
                ),
                onPressed: () async {
                  signUpEmailResult = await _firebaseAuthProvider.updatePassword(
                      mail: mail,
                      password: newPassword,
                      name: name
                  );
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "아니오",
                  style: customStyle(
                      fontColor: blueColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

            ] :
            <Widget>[
            FlatButton(
              child: Text(
                "확인",
                style: customStyle(
                    fontColor: blueColor,
                    fontSize: 15,
                    fontWeightName: 'Bold'),
              ),
              onPressed: () {
                signUpEmailResult = false;
                Navigator.pop(context);
              },
            ),
          ],
          );
        },
      );

    return signUpEmailResult;
  }

  Future<bool> InfomationPhoneUpdateWithFirebaseAuth({BuildContext context, String mail, String newPassword, String newPasswordConfirm, String name}) async {

  }
}

//Flutter
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
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
  Future<bool> InfomationConfirmWithFirebaseAuth({BuildContext context, String companyCode, String mail, String password, String name}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    //print("메일 => " + mail + ", 패스워드 => " + password + ", 이름 => " + name);

    bool _signUpEmailResult = await _firebaseAuthProvider.confirmPassword(context: context, mail: mail, password: password, name: name);

    return _signUpEmailResult;
  }

  // 계정삭제 패스워드 확인
  Future<void> dropAccountWithFirebaseAuth({BuildContext context, String companyCode, String mail, String password, String name}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    await _firebaseAuthProvider.confirmDropAccountPassword(context: context, companyCode: companyCode, mail: mail, password: password, name: name);
  }

  // 계정삭제
  Future<void> dropAccountAuth(BuildContext context, String companyCode, String mail) async {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);

    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    bool result = await _firebaseAuthProvider.confirmDropAccount(context: context, companyCode: companyCode, mail: mail);

    print("result =================> " + result.toString());

    if(result){
      _loginUserInfoProvider.logoutUser();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool> InfomationUpdateWithFirebaseAuth({BuildContext context, String mail, String newPassword, String newPasswordConfirm, String name}) async {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
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

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              pwdMsgTitle,
              style: defaultMediumStyle,
            ),
            content: Text(
              pwdMsgCon,
              style: defaultRegularStyle,
            ),
            actions: isPwd == true? <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: buttonBlueStyle,
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
                  style: buttonBlueStyle,
                ),
                onPressed: () {
                  signUpEmailResult = false;
                  Navigator.pop(context);
                },
              ),

            ] :
            <Widget>[
            FlatButton(
              child: Text(
                "확인",
                style: buttonBlueStyle,
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

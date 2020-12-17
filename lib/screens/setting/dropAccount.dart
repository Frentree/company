//Flutter
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';

//Screen
import 'package:MyCompany/screens/login/login.dart';
import 'package:MyCompany/screens/login/signUp.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final word = Words();

class DropAcountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding : false,
      backgroundColor : mainColor,
      body: SafeArea(
        child: AlertDialog(
          title: Text(
            word.accountSecession(),
            style: customStyle(
                    fontColor: blueColor,
                    fontSize: 13,
                    fontWeightName: 'Bold'
                ),
          ),
          content: Text(
            word.dropAccountCompltedDialog(),
                style: customStyle(
                    fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                word.loginPageGo(),
                style: customStyle(
                        fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
              ),
              onPressed: () {
                FirebaseRepository().deleteAccount(
                    companyCode: _loginUserInfoProvider.getLoginUser().companyCode,
                    mail: _loginUserInfoProvider.getLoginUser().mail
                );
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ],
        ),
      ),
    );
  }
}

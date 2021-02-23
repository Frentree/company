//Flutter
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';


final word = Words();
class WaitingApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
    Provider.of<LoginUserInfoProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding : false,
      backgroundColor : mainColor,
      body: SafeArea(
        child: AlertDialog(
          title: Text(
            word.singUpWaiting(),
            style: defaultMediumStyle,
          ),
          content: Text(
            word.singUpWaitingCon(),
            style: defaultRegularStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                word.loginPageGo(),
                style: buttonBlueStyle,
              ),
              onPressed: () {
                _loginUserInfoProvider.logoutUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}

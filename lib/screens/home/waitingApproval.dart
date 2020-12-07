//Flutter
import 'package:companyplaylist/consts/universalString.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Screen
import 'package:companyplaylist/screens/login/login.dart';
import 'package:companyplaylist/screens/login/signUp.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
            "승인 대기",
            style: customStyle(
                    fontColor: blueColor,
                    fontSize: 13,
                    fontWeightName: 'Bold'
                ),
          ),
          content: Text(
            "회사 가입 승인 대기 상태입니다.\n승인 완료 후 이용 가능합니다.",
                style: customStyle(
                    fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "앱 종료",
                style: customStyle(
                        fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
              ),
              onPressed: () {
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ],
        ),
      ),
    );
  }
}

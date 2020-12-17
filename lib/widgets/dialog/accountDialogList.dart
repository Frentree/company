import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/setting/dropAccount.dart';
import 'package:MyCompany/widgets/dialog/gradeDialogList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final word = Words();
LoginRepository _loginRepository = LoginRepository();

// 계정삭제 - 패스워드 입력
Future<void> dropAccountDialog({BuildContext context, String companyCode, String mail, String name}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController _passwordEditController = TextEditingController();
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.accountSecession(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.contact_mail_outlined),
                  labelText: word.currentPassword() + " " + word.input(),
                ),
                controller: _passwordEditController,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: mainColor,
                        child: Text(
                          word.confirm(),
                          style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
                        ),
                        onPressed: () async {
                          await _loginRepository.dropAccountWithFirebaseAuth(
                            context: context,
                            companyCode: companyCode,
                            mail: mail,
                            password: _passwordEditController.text.trim(),
                            name: name
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: mainColor,
                      child: Text(
                        word.cencel(),
                        style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 계정 삭제
Future<void> dropRealAccountDialog({BuildContext context, String companyCode, String mail}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.accountSecession(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(word.dropAccountCon()),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: mainColor,
                            child: Text(
                              word.delete(),
                              style: customStyle(
                                  fontColor: whiteColor,
                                  fontSize: 15,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            onPressed: () {
                              _loginRepository.dropAccountAuth(
                                  context: context,
                                  companyCode: companyCode,
                                  mail: mail,
                              );
                              DropAcountPage();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: mainColor,
                            child: Text(
                              word.cencel(),
                              style: customStyle(
                                  fontColor: whiteColor,
                                  fontSize: 15,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 계정삭제 - 완료
Future<void> dropAccountCompltedDialog({BuildContext context}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.accountSecession(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(word.dropAccountCompltedDialog()),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: mainColor,
                        child: Text(
                          word.confirm(),
                          style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

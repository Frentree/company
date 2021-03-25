import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:sizer/sizer.dart';

Future<void> updateUserInfomation({BuildContext context, CompanyUser user, String companyCode}) {
  TextEditingController _enteredDateController = MaskedTextController(mask: '0000.00.00');
  TextEditingController _employeeNumController = TextEditingController();
  _enteredDateController.text = user.enteredDate.toString();
  _employeeNumController.text = user.employeeNum.toString();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {

      return AlertDialog(
        title: Text(
          "유저 정보 수정",
          style: defaultMediumStyle,
        ),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                    child: Text(
                      "입사일",
                      style: cardMainStyle,
                    ),
                  ),
                  cardSpace,
                  cardSpace,
                  cardSpace,
                  Expanded(
                    child: TextFormField(
                      controller: _enteredDateController,
                      style: defaultRegularStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: textFormPadding,
                        labelText: user.enteredDate,
                        labelStyle: defaultRegularStyle,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                    child: Text(
                      "사번",
                      style: cardMainStyle,
                    ),
                  ),
                  cardSpace,
                  cardSpace,
                  cardSpace,
                  Expanded(
                    child: TextFormField(
                      controller: _employeeNumController,
                      style: defaultRegularStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: textFormPadding,
                        labelText: user.employeeNum,
                        labelStyle: defaultRegularStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              Words.word.update(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              user.reference.update({
                "enteredDate" : _enteredDateController.text.trim() != "" ? _enteredDateController.text : user.enteredDate,
                "employeeNum" : _employeeNumController.text.trim() != "" ? _employeeNumController.text : user.employeeNum,
              });
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              Words.word.cencel(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

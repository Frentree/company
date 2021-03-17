//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';


import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:intl/intl.dart';


import 'package:sizer/sizer.dart';

final word = Words();

Card settingExpenseDetailCard({BuildContext context, List<dynamic> workApprovalModel, CompanyUser companyUserInfo, User loginUser}) {
  int totalCost = 0;
  List<String> documentID = [];
  List<WorkApproval> waData = [];
  var returnString = NumberFormat("###,###", "en_US");

  workApprovalModel.forEach((element) {
    totalCost += element.data()["totalCost"];
    documentID.add(element.id);
    waData.add(WorkApproval.fromMap(element.data()));
  });


  Format _format = Format();
  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
      padding: cardPadding,
      child: Container(
        height: scheduleCardDefaultSizeH.h,
        child: Row(
          children: [
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 33.0.w,
              alignment: Alignment.center,
              child: Text(
                "${companyUserInfo.team} ${companyUserInfo.name} ${companyUserInfo.position}",
                style: containerChipStyle,
              ),
            ),
            cardSpace,
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 17.5.w,
              alignment: Alignment.center,
              child: Text(
                returnString.format(totalCost),
                style: containerChipStyle,
              ),
            ),
            cardSpace,
            Expanded(
              child: Container(
                height: 3.0.h,
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                alignment: Alignment.center,
                child: RaisedButton(
                  color: whiteColor,
                  shape: raisedButtonBlueShape,
                  elevation: 0.0,
                  child: Text(
                    "입금",
                    style: buttonBlueStyle,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context){
                        return StatefulBuilder(
                          builder: (context, setState){
                            return AlertDialog(
                              title: Text(
                                "입금 완료",
                                style: defaultMediumStyle,
                              ),
                              content: Container(
                                child: Text("입금 완료로 처리하시겠습니까?", style: defaultRegularStyle,),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "확인",
                                    style: buttonBlueStyle,
                                  ),
                                  onPressed: () async {
                                    await FirebaseRepository().getUserApprovalExpenseUpdate(companyCode: loginUser.companyCode, documentID: documentID);
                                    waData.forEach((element) async {
                                      await FirebaseRepository().postProcessApprovedExpense(loginUser, element, 4);
                                    });
                                    Navigator.pop(context, "OK");
                                  }
                                ),
                                FlatButton(
                                  child: Text(
                                    "취소",
                                    style: buttonBlueStyle,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

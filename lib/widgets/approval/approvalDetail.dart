import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/i18n/word.dart';

import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

annualLeaveBottomSheet({BuildContext context, String companyCode, WorkApproval model}) async {
  Format _format = Format();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    top: 2.0.h,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("결재 내역",
                      style: defaultRegularStyle,)),
                    emptySpace,
                    Row(
                      children: [
                        Text(
                          "결재명 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.title,
                          style: defaultRegularStyle,
                        ),
                        cardSpace,
                        Text(
                          "결재종류 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.approvalType,
                          style: defaultRegularStyle,
                        ),
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Text(
                          "결재 상태 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.status,
                          style: defaultRegularStyle,
                        ),
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        Text(
                          model.approvalType + " 사용일 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(model.requestDate.toDate()).toString(),
                          style: defaultRegularStyle,
                        ),
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Text(
                          "결재요청자 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.user,
                          style: defaultRegularStyle,
                        ),
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        Text(
                          "결재 요청일 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(model.createDate.toDate()).toString(),
                          style: defaultRegularStyle,
                        ),
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Text(
                          "결재자 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.approvalUser,
                          style: defaultRegularStyle,
                        ),
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        cardSpace,
                        Text(
                          "결재 완료일 : ",
                          style: cardBlueStyle,
                        ),
                        Visibility(
                          visible: model.status != "요청",
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(model.approvalDate.toDate()).toString(),
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Text(
                          "결재요청내용 : ",
                          style: cardBlueStyle,
                        ),
                        Text(
                          model.requestContent,
                          style: defaultRegularStyle,
                        ),
                      ],
                    ),
                    emptySpace,
                    Visibility(
                      visible: model.status == "요청",
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              color: blueColor,
                              child: Text(
                                "결재 요청 취소하기",
                                style: defaultMediumWhiteStyle,
                              ),
                              onPressed: (){

                              },
                            )
                          )
                        ],
                      ),
                    ),
                    emptySpace,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}

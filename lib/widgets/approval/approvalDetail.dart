import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

final word = Words();

annualLeaveRequestApprovalBottomSheet({BuildContext context, String companyCode, WorkApproval model}) async {
  Format _format = Format();
  bool result = false;

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
                    Row(
                      children: [
                        Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "상세 내용",
                              style: defaultMediumStyle,
                            ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.title,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재명",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.title,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.merge_type,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재종류",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.approvalType,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.stream,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재상태",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.status,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "대상일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(model.requestDate.toDate()).toString(),
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청자",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.user,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(model.createDate.toDate()).toString(),
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재자",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.approvalUser,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재완료일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Visibility(
                          visible: model.status != "요청",
                          child: Expanded(
                            child: Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(model.approvalDate.toDate()).toString(),
                              style: defaultRegularStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청내용",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.requestContent,
                            style: defaultRegularStyle,
                          ),
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
                              onPressed: () async {
                                result = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "결재 요청 취소",
                                          style: defaultMediumStyle,
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                "결재 요청을 취소하시겠습니까?",
                                                style: defaultRegularStyle,
                                              ),
                                              Text(
                                                word.buttonCon(),
                                                style: defaultRegularStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              Words.word.confirm(),
                                              style: buttonBlueStyle,
                                            ),
                                            onPressed: () {
                                              model.reference.delete();
                                              Navigator.of(context).pop(true);
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
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                if(result == true){
                                  Navigator.pop(context);
                                }
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

annualLeaveApprovalBottomSheet({BuildContext context, String companyCode, WorkApproval model}) async {
  Format _format = Format();
  bool result = false;
  DateTime startTime = DateTime.parse(model.requestDate.toDate().toString());
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
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          decoration: BoxDecoration(
                            color: chipColorBlue,
                            borderRadius: BorderRadius.circular(
                                SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "상세 내용",
                            style: defaultMediumStyle,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    emptySpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.title,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재명",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.title,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.merge_type,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재종류",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.approvalType,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.stream,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재상태",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.status,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "사용일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(model.requestDate.toDate()).toString(),
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청자",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.user,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(model.createDate.toDate()).toString(),
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재자",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.approvalUser,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재완료일",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Visibility(
                          visible: model.status != "요청",
                          child: Expanded(
                            child: Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(model.approvalDate.toDate()).toString(),
                              style: defaultRegularStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    cardSpace,
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "결재요청내용",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.requestContent,
                            style: defaultRegularStyle,
                          ),
                        ),
                      ],
                    ),
                    emptySpace,
                    Visibility(
                      visible: model.status == "요청",
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: blueColor,
                                  child: Text(
                                    "승인",
                                    style: defaultMediumWhiteStyle,
                                  ),
                                  onPressed: () async {
                                    result = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "결재 승인",
                                            style: defaultMediumStyle,
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                  "결재 승인하시겠습니까?",
                                                  style: defaultRegularStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                Words.word.confirm(),
                                                style: buttonBlueStyle,
                                              ),
                                              onPressed: () {
                                                model.reference.update({
                                                  "status" : "승인",
                                                  "approvalDate" : Timestamp.now()
                                                });
                                                DateTime requestDate = DateTime.parse(model.requestDate.toDate().toString());
                                                FirebaseRepository().saveWork(
                                                  companyCode: companyCode,
                                                  workModel: WorkModel(
                                                    alarmId: model.approvalType == "외근" ? DateTime.now().hashCode : 0,
                                                    contents: model.requestContent,
                                                    createUid: model.userMail,
                                                    createDate: Timestamp.now(),
                                                    startDate: _format.dateTimeToTimeStamp(DateTime(requestDate.year, requestDate.month, requestDate.day, 21, 00,)),
                                                    startTime: model.approvalType != "외근" ? _format.dateTimeToTimeStamp(DateTime(requestDate.year, requestDate.month, requestDate.day, 09, 00,)) : model.requestDate,
                                                    timeSlot: model.approvalType == "외근" ? _format.timeSlot(requestDate) : 1,
                                                    type: model.approvalType,
                                                    title: model.approvalType == "외근" ? model.title : model.approvalType,
                                                    level: 0,
                                                    location: model.location,
                                                    lastModDate: Timestamp.now(),
                                                    name: model.user,
                                                  )
                                                );
                                                Navigator.of(context).pop(true);
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
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if(result == true){
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              )
                          ),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: blueColor,
                                  child: Text(
                                    "반려",
                                    style: defaultMediumWhiteStyle,
                                  ),
                                  onPressed: () async {
                                    result = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "결재 반려",
                                            style: defaultMediumStyle,
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                  "결재 반려하시겠습니까?",
                                                  style: defaultRegularStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                Words.word.confirm(),
                                                style: buttonBlueStyle,
                                              ),
                                              onPressed: () {
                                                model.reference.update({
                                                  "status" : "반려",
                                                  "approvalDate" : Timestamp.now()
                                                });
                                                Navigator.of(context).pop(true);
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
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if(result == true){
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
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

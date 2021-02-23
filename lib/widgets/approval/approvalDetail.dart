import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
                            model.approvalType=="업무" ? (model.location == "" ? model.approvalType+"_내근" : model.approvalType+"_외근") : model.approvalType,
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
                                Icons.navigation_outlined,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "위치",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.location,
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
                                "결재내용",
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
  FirebaseRepository _repository = FirebaseRepository();
  Fcm fcm = Fcm();
  Format _format = Format();
  bool result = false;
  User _loginUser;
  DateTime startTime = DateTime.parse(model.requestDate.toDate().toString());
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();
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
                            model.approvalType=="업무" ? (model.location == "" ? model.approvalType+"_내근" : model.approvalType+"_외근") : model.approvalType,
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
                                Icons.navigation_outlined,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                "위치",
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: Text(
                            model.location,
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
                                "결재내용",
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
                                              onPressed: () async {
                                                var doc = await FirebaseFirestore.instance.collection("company").doc(_loginUser.companyCode).collection("user").doc(_loginUser.mail).get();
                                                CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

                                                model.reference.update({
                                                  "status" : "승인",
                                                  "approvalDate" : Timestamp.now()
                                                });
                                                DateTime requestDate = DateTime.parse(model.requestDate.toDate().toString());

                                                switch(model.approvalType){
                                                  //업무 요청
                                                  case '업무':
                                                    WorkModel _workModel = WorkModel(
                                                      alarmId: DateTime.now().hashCode,
                                                      contents: model.requestContent,
                                                      createUid: model.approvalMail,
                                                      createDate: Timestamp.now(),
                                                      startDate: _format.dateTimeToTimeStamp(DateTime(requestDate.year, requestDate.month, requestDate.day, 21, 00,)),
                                                      startTime: model.requestDate,
                                                      timeSlot: _format.timeSlot(requestDate),
                                                      type: "요청",
                                                      title: model.title,
                                                      level: 0,
                                                      location: model.location == "" ? "사무실" : model.location,
                                                      lastModDate: Timestamp.now(),
                                                      name: model.approvalUser,
                                                    );

                                                    await FirebaseRepository().saveWork(
                                                        companyCode: companyCode,
                                                        workModel: _workModel,
                                                    ).whenComplete(() async {
                                                      Alarm _alarmModel = Alarm(
                                                        alarmId: _workModel.alarmId,
                                                        createName: _loginUser.name,
                                                        createMail: _loginUser.mail,
                                                        collectionName: "requestWorkOk",
                                                        alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 업무요청을 수락했습니다.",
                                                        read: false,
                                                        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                      );

                                                      //알림 스케줄 등록
                                                      if(startTime.isAfter(DateTime.now())){
                                                        await notificationPlugin.scheduleNotification(
                                                          alarmId: _workModel.alarmId,
                                                          alarmTime: startTime,
                                                          title: "일정이 있습니다.",
                                                          contents: "일정 내용 : ${model.title}",
                                                          payload: _workModel.alarmId.toString(),
                                                        );
                                                      }

                                                      //업무 요청자에게 알림 보내기
                                                      List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                      await _repository.saveOneUserAlarm(
                                                        alarmModel: _alarmModel,
                                                        companyCode: _loginUser.companyCode,
                                                        mail: model.userMail,
                                                      ).whenComplete(() async {
                                                        if(token.length !=0){
                                                          fcm.sendFCMtoSelectedDevice(
                                                              alarmId: _alarmModel.alarmId.toString(),
                                                              tokenList: token,
                                                              name: _loginUser.name,
                                                              team: loginUserInfo.team,
                                                              position: loginUserInfo.position,
                                                              collection: "requestWorkOk"
                                                          );
                                                        }

                                                      });
                                                    });

                                                    break;
                                                  case '외근':
                                                    WorkModel _workModel = WorkModel(
                                                      alarmId: DateTime.now().hashCode,
                                                      contents: model.requestContent,
                                                      createUid: model.userMail,
                                                      createDate: Timestamp.now(),
                                                      startDate: _format.dateTimeToTimeStamp(DateTime(requestDate.year, requestDate.month, requestDate.day, 21, 00,)),
                                                      startTime: model.requestDate,
                                                      timeSlot: _format.timeSlot(requestDate),
                                                      type: model.approvalType,
                                                      title: model.title,
                                                      level: 0,
                                                      location: model.location,
                                                      lastModDate: Timestamp.now(),
                                                      name: model.user,
                                                    );

                                                    FirebaseRepository().saveWork(
                                                        companyCode: companyCode,
                                                        workModel: _workModel,
                                                    ).whenComplete(() async {
                                                      Alarm _alarmModel = Alarm(
                                                        alarmId: _workModel.alarmId,
                                                        createName: _loginUser.name,
                                                        createMail: _loginUser.mail,
                                                        collectionName: "approvalWorkOk",
                                                        alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 외근일정 결재를 수락했습니다.",
                                                        read: false,
                                                        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                      );

                                                      List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                      await _repository.saveOneUserAlarm(
                                                        alarmModel: _alarmModel,
                                                        companyCode: _loginUser.companyCode,
                                                        mail: model.userMail,
                                                      ).whenComplete(() async {
                                                        if(token.length != 0){
                                                          fcm.sendFCMtoSelectedDevice(
                                                              alarmId: _alarmModel.alarmId.toString(),
                                                              tokenList: token,
                                                              name: _loginUser.name,
                                                              team: loginUserInfo.team,
                                                              position: loginUserInfo.position,
                                                              collection: "approvalWorkOk@${startTime}@${model.title}"
                                                          );
                                                        }
                                                      });

                                                      var doc = await FirebaseFirestore.instance.collection("company").doc(_loginUser.companyCode).collection("user").doc(model.userMail).get();
                                                      CompanyUser workCreateUser = CompanyUser.fromMap(doc.data(), doc.id);

                                                      Alarm _alarmModel2 = Alarm(
                                                        alarmId: _workModel.alarmId,
                                                        createName: model.user,
                                                        createMail: model.userMail,
                                                        collectionName: "work",
                                                        alarmContents: workCreateUser.team + " " + workCreateUser.name + " " + workCreateUser.position + "님이 새로운 " + "일정" + "을 등록 했습니다.",
                                                        read: false,
                                                        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                      );


                                                      List<String> tokens = await _repository.getTokens(companyCode: _loginUser.companyCode, mail: model.userMail);


                                                      //알림 DB에 저장
                                                      await _repository.saveAlarm(
                                                        alarmModel: _alarmModel2,
                                                        companyCode: _loginUser.companyCode,
                                                        mail: model.userMail,
                                                      ).whenComplete(() async {

                                                        //동료들에게 알림 보내기
                                                        fcm.sendFCMtoSelectedDevice(
                                                            alarmId: _alarmModel2.alarmId.toString(),
                                                            tokenList: tokens,
                                                            name: workCreateUser.name,
                                                            team: workCreateUser.team,
                                                            position: workCreateUser.position,
                                                            collection: "work"
                                                        );
                                                      });

                                                    });
                                                    break;
                                                    //연반차
                                                  default:
                                                    WorkModel _workModel = WorkModel(
                                                      alarmId: DateTime.now().hashCode,
                                                      contents: model.requestContent,
                                                      createUid: model.userMail,
                                                      createDate: Timestamp.now(),
                                                      startDate: _format.dateTimeToTimeStamp(DateTime(requestDate.year, requestDate.month, requestDate.day, 21, 00,)),
                                                      startTime: model.requestDate,
                                                      timeSlot: _format.timeSlot(requestDate),
                                                      type: model.approvalType,
                                                      title: model.approvalType,
                                                      level: 0,
                                                      location: model.location,
                                                      lastModDate: Timestamp.now(),
                                                      name: model.user,
                                                    );

                                                    FirebaseRepository().saveWork(
                                                      companyCode: companyCode,
                                                      workModel: _workModel,
                                                    ).whenComplete(() async {
                                                      Alarm _alarmModel = Alarm(
                                                        alarmId: _workModel.alarmId,
                                                        createName: _loginUser.name,
                                                        createMail: _loginUser.mail,
                                                        collectionName: "annualLeaveOk",
                                                        alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이" + model.approvalType + "결재를 수락했습니다.",
                                                        read: false,
                                                        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                      );

                                                      List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                      await _repository.saveOneUserAlarm(
                                                        alarmModel: _alarmModel,
                                                        companyCode: _loginUser.companyCode,
                                                        mail: model.userMail,
                                                      ).whenComplete(() async {
                                                        if(token.length != 0){
                                                          fcm.sendFCMtoSelectedDevice(
                                                              alarmId: _alarmModel.alarmId.toString(),
                                                              tokenList: token,
                                                              name: _loginUser.name,
                                                              team: loginUserInfo.team,
                                                              position: loginUserInfo.position,
                                                              collection: "annualLeaveOk@${model.approvalType}"
                                                          );
                                                        }

                                                      });
                                                    });

                                                    break;

                                                }
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
                                              onPressed: () async {
                                                var doc = await FirebaseFirestore.instance.collection("company").doc(_loginUser.companyCode).collection("user").doc(_loginUser.mail).get();
                                                CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

                                                model.reference.update({
                                                  "status" : "반려",
                                                  "approvalDate" : Timestamp.now()
                                                });

                                                switch(model.approvalType){
                                                  case '업무':
                                                    Alarm _alarmModel = Alarm(
                                                      alarmId: DateTime.now().hashCode,
                                                      createName: _loginUser.name,
                                                      createMail: _loginUser.mail,
                                                      collectionName: "requestWorkNo",
                                                      alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 업무요청을 거절했습니다.",
                                                      read: false,
                                                      alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                    );

                                                    List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                    await _repository.saveOneUserAlarm(
                                                      alarmModel: _alarmModel,
                                                      companyCode: _loginUser.companyCode,
                                                      mail: model.userMail,
                                                    ).whenComplete(() async {
                                                      if(token.length != 0){
                                                        fcm.sendFCMtoSelectedDevice(
                                                            alarmId: _alarmModel.alarmId.toString(),
                                                            tokenList: token,
                                                            name: _loginUser.name,
                                                            team: loginUserInfo.team,
                                                            position: loginUserInfo.position,
                                                            collection: "requestWorkNo"
                                                        );
                                                      }
                                                    });

                                                    break;
                                                  case '외근':
                                                    Alarm _alarmModel = Alarm(
                                                      alarmId: DateTime.now().hashCode,
                                                      createName: _loginUser.name,
                                                      createMail: _loginUser.mail,
                                                      collectionName: "approvalWorkNo",
                                                      alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 외근일정 결재를 거절했습니다.",
                                                      read: false,
                                                      alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                    );

                                                    List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                    await _repository.saveOneUserAlarm(
                                                      alarmModel: _alarmModel,
                                                      companyCode: _loginUser.companyCode,
                                                      mail: model.userMail,
                                                    ).whenComplete(() async {
                                                      if(token.length != 0){
                                                        fcm.sendFCMtoSelectedDevice(
                                                            alarmId: _alarmModel.alarmId.toString(),
                                                            tokenList: token,
                                                            name: _loginUser.name,
                                                            team: loginUserInfo.team,
                                                            position: loginUserInfo.position,
                                                            collection: "annualLeaveNo"
                                                        );
                                                      }
                                                    });
                                                    break;
                                                  default:
                                                    Alarm _alarmModel = Alarm(
                                                      alarmId: DateTime.now().hashCode,
                                                      createName: _loginUser.name,
                                                      createMail: _loginUser.mail,
                                                      collectionName: "annualLeaveNo",
                                                      alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이" + model.approvalType + "결재를 거절했습니다.",
                                                      read: false,
                                                      alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                                    );

                                                    List<String> token = await _repository.getApprovalUserTokens(companyCode: companyCode, mail: model.userMail);

                                                    await _repository.saveOneUserAlarm(
                                                      alarmModel: _alarmModel,
                                                      companyCode: _loginUser.companyCode,
                                                      mail: model.userMail,
                                                    ).whenComplete(() async {
                                                      if(token.length != 0){
                                                        fcm.sendFCMtoSelectedDevice(
                                                            alarmId: _alarmModel.alarmId.toString(),
                                                            tokenList: token,
                                                            name: _loginUser.name,
                                                            team: loginUserInfo.team,
                                                            position: loginUserInfo.position,
                                                            collection: "annualLeaveNo@${model.approvalType}"
                                                        );
                                                      }
                                                    });

                                                    break;
                                                }

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

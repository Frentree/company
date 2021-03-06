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
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/annual/annualLeaveMain.dart';
import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';
import 'package:MyCompany/widgets/popupMenu/invalidData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

workContent({BuildContext context, int type, WorkModel workModel, WorkData workData}) async {
  Fcm fcm = Fcm();
  WorkModel _workModel = workModel;
  bool result = false;
  bool isChk = false;

  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  String _approvalUserItem = "선택";
  UserData approvalUser;

  User _loginUser;

  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

  DateTime startTime = selectedDay == today
      ? DateTime.now().minute < 30
          ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00)
          : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30)
      : selectedDate.minute < 30
          ? DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 00)
          : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 30);

  FirebaseRepository _repository = FirebaseRepository();

  if (_workModel != null) {
    _titleController.text = _workModel.title;
    _locationController.text = _workModel.location;
    _contentController.text = _workModel.contents;
    startTime = _format.timeStampToDateTime(_workModel.startTime);
  }

  if (workData != null) {
    _titleController.text = workData.title;
    _locationController.text = workData.location;
    _contentController.text = workData.contents;
    //startTime = _format.timeStampToDateTime(workData.startTime);
  }

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
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
                            borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            type == 1 ? word.workInSchedule() : word.workOutSchedule(),
                            style: defaultMediumStyle,
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            style: defaultRegularStyle,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: textFormPadding,
                              border: InputBorder.none,
                              hintText: word.pleaseTitle(),
                              hintStyle: hintStyle,
                            ),
                          ),
                        ),
                        cardSpace,
                        CircleAvatar(
                          radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                          backgroundColor:
                              (_titleController.text == "" || (type == 2 && _locationController.text == "")) ? disableUploadBtn : blueColor,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_upward,
                                color: whiteColor,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              onPressed: (_titleController.text == "" || (type == 2 && _locationController.text == ""))
                                  ? () {}
                                  : () async {
                                      var doc = await FirebaseFirestore.instance
                                          .collection("company")
                                          .doc(_loginUser.companyCode)
                                          .collection("user")
                                          .doc(_loginUser.mail)
                                          .get();
                                      CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

                                      if (workModel != null) {
                                        // 수정일 경우
                                        _workModel = WorkModel(
                                          id: workModel.id,
                                          createUid: workModel.createUid,
                                          name: workModel.name,
                                          type: workModel.type,
                                          title: _titleController.text,
                                          contents: _contentController.text,
                                          location: _locationController.text,
                                          createDate: workModel.createDate,
                                          lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                          startDate: _format.dateTimeToTimeStamp(DateTime(
                                            startTime.year,
                                            startTime.month,
                                            startTime.day,
                                            21,
                                            00,
                                          )),
                                          startTime: _format.dateTimeToTimeStamp(startTime),
                                          timeSlot: _format.timeSlot(startTime),
                                          level: 0,
                                          alarmId: workModel.alarmId,
                                        );

                                        await _repository.updateWork(
                                          workModel: _workModel,
                                          companyCode: _loginUser.companyCode,
                                        );

                                        await notificationPlugin.deleteNotification(alarmId: _workModel.alarmId);

                                        if (startTime.isAfter(DateTime.now())) {
                                          await notificationPlugin.scheduleNotification(
                                            alarmId: _workModel.alarmId,
                                            alarmTime: startTime,
                                            title: "일정이 있습니다.",
                                            contents: "일정 내용 : ${_titleController.text}",
                                            payload: _workModel.alarmId.toString(),
                                          );
                                        }
                                      } else {
                                        // 입력단계
                                        switch (type) {
                                          case 1: //내근
                                            _workModel = WorkModel(
                                              createUid: _loginUser.mail,
                                              name: _loginUser.name,
                                              type: "내근",
                                              title: _titleController.text,
                                              contents: _contentController.text,
                                              location: _locationController.text,
                                              createDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                              lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                              startDate: _format.dateTimeToTimeStamp(DateTime(
                                                startTime.year,
                                                startTime.month,
                                                startTime.day,
                                                21,
                                                00,
                                              )),
                                              startTime: _format.dateTimeToTimeStamp(startTime),
                                              timeSlot: _format.timeSlot(startTime),
                                              level: 0,
                                              alarmId: DateTime.now().hashCode,
                                            );

                                            await _repository
                                                .saveWork(
                                              workModel: _workModel,
                                              companyCode: _loginUser.companyCode,
                                            )
                                                .whenComplete(() async {
                                              //알림 데이터 생성
                                              Alarm _alarmModel = Alarm(
                                                alarmId: _workModel.alarmId,
                                                createName: _loginUser.name,
                                                createMail: _loginUser.mail,
                                                collectionName: "work",
                                                alarmContents: loginUserInfo.team +
                                                    " " +
                                                    _loginUser.name +
                                                    " " +
                                                    loginUserInfo.position +
                                                    "님이 새로운 " +
                                                    "일정" +
                                                    "을 등록 했습니다.",
                                                read: false,
                                                alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                              );

                                              //알림 스케줄 등록
                                              if (startTime.isAfter(DateTime.now())) {
                                                await notificationPlugin.scheduleNotification(
                                                  alarmId: _workModel.alarmId,
                                                  alarmTime: startTime,
                                                  title: "일정이 있습니다.",
                                                  contents: "일정 내용 : ${_titleController.text}",
                                                  payload: _workModel.alarmId.toString(),
                                                );
                                              }

                                              //동료들 토큰 가져오기
                                              List<String> tokens =
                                                  await _repository.getTokens(companyCode: _loginUser.companyCode, mail: _loginUser.mail);



                                              //알림 DB에 저장
                                              await _repository
                                                  .saveAlarm(
                                                alarmModel: _alarmModel,
                                                companyCode: _loginUser.companyCode,
                                                mail: _loginUser.mail,
                                              )
                                                  .whenComplete(() async {
                                                //동료들에게 알림 보내기
                                                if(tokens.length != 0) {
                                                  fcm.sendFCMtoSelectedDevice(
                                                      alarmId: _alarmModel.alarmId.toString(),
                                                      tokenList: tokens,
                                                      name: _loginUser.name,
                                                      team: loginUserInfo.team,
                                                      position: loginUserInfo.position,
                                                      collection: "work");
                                                }
                                              });
                                            });
                                            break;
                                          case 2: //외근
                                            if (approvalUser == null) {
                                              FailedData(context, "결재자 미선택", "결재자를 선택 후에 신청해주세요");
                                              break;
                                            }
                                            await FirebaseRepository()
                                                .createAnnualLeave(
                                              companyCode: _loginUser.companyCode,
                                              workApproval: WorkApproval(
                                                title: _titleController.text,
                                                status: "요청",
                                                user: _loginUser.name,
                                                userMail: _loginUser.mail,
                                                createDate: Timestamp.now(),
                                                requestDate: _format.dateTimeToTimeStamp(startTime),
                                                approvalContent: "",
                                                approvalType: "외근",
                                                requestContent: _contentController.text,
                                                approvalUser: approvalUser.name,
                                                approvalMail: approvalUser.mail,
                                                location: _locationController.text,
                                              ),
                                            )
                                                .whenComplete(() async {
                                              //결재요청 알림 생성
                                              Alarm _alarmModel = Alarm(
                                                alarmId: DateTime.now().hashCode,
                                                createName: _loginUser.name,
                                                createMail: _loginUser.mail,
                                                collectionName: "approvalWork",
                                                alarmContents: loginUserInfo.team +
                                                    " " +
                                                    _loginUser.name +
                                                    " " +
                                                    loginUserInfo.position +
                                                    "님이 외근일정 결재를 요청하였습니다.",
                                                read: false,
                                                alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                              );

                                              List<String> token = await _repository.getApprovalUserTokens(
                                                  companyCode: _loginUser.companyCode, mail: approvalUser.mail);

                                              //결재자 알림 DB에 저장
                                              await _repository
                                                  .saveOneUserAlarm(
                                                alarmModel: _alarmModel,
                                                companyCode: _loginUser.companyCode,
                                                mail: approvalUser.mail,
                                              )
                                                  .whenComplete(() async {
                                                if (token.length != 0) {
                                                  fcm.sendFCMtoSelectedDevice(
                                                      alarmId: _alarmModel.alarmId.toString(),
                                                      tokenList: token,
                                                      name: _loginUser.name,
                                                      team: loginUserInfo.team,
                                                      position: loginUserInfo.position,
                                                      collection: "approvalWork");
                                                }
                                              });
                                            });
                                            break;
                                        }
                                      }
                                      result = true;
                                      Navigator.of(context).pop(result);
                                      return result;
                                    }),
                        ),
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
                                Icons.calendar_today,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              cardSpace,
                              Text(
                                word.dateTime(),
                                style: defaultRegularStyle,
                              ),
                            ],
                          ),
                        ),
                        cardSpace,
                        Expanded(
                          child: InkWell(
                            child: Text(
                              _format.dateToString(startTime),
                              style: defaultRegularStyle,
                            ),
                            onTap: () async {
                              DateTime _dateTime = await workDatePage(context: context, startTime: startTime);
                              setState(() {
                                startTime = _dateTime;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    emptySpace,
                    Visibility(
                      visible: (type == 2),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 6.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                    ),
                                    cardSpace,
                                    Text(
                                      word.outLocation(),
                                      style: defaultRegularStyle,
                                    ),
                                  ],
                                ),
                              ),
                              cardSpace,
                              Expanded(
                                child: TextField(
                                  controller: _locationController,
                                  style: defaultRegularStyle,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: textFormPadding,
                                    border: InputBorder.none,
                                    hintText: word.outCon(),
                                    hintStyle: hintStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseRepository().getGradeUser(companyCode: _loginUser.companyCode, level: 6),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text("");
                                        }
                                        List<DocumentSnapshot> doc = snapshot.data.docs;

                                        return PopupMenuButton(
                                            child: RaisedButton(
                                              disabledColor: whiteColor,
                                              child: Text(
                                                _approvalUserItem,
                                                style: defaultRegularStyle,
                                              ),
                                            ),
                                            onSelected: (value) {
                                              approvalUser = value;
                                              _approvalUserItem = userNameChange(value);
                                              setState(() {});
                                            },
                                            itemBuilder: (context) =>
                                                doc.map((data) => _buildApprovalItem(_loginUser.companyCode, data, context)).toList());
                                      })),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (type == 2),
                      child: emptySpace,
                    ),
                    GestureDetector(
                      onTap: () {
                        isChk = !isChk;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                height: 6.0.h,
                                child: IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  icon: isChk == true ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              Text(
                                word.addItem(),
                                style: defaultRegularStyle,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isChk,
                      child: emptySpace,
                    ),
                    Visibility(
                      visible: isChk,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  word.content(),
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          emptySpace,
                          TextFormField(
                            maxLines: 5,
                            maxLengthEnforced: true,
                            controller: _contentController,
                            style: defaultRegularStyle,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: textFormPadding,
                              hintText: word.contentCon(),
                              hintStyle: hintStyle,
                            ),
                          ),
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

/// 결재자 종류 선택 메뉴
PopupMenuItem _buildApprovalItem(String companyCode, DocumentSnapshot data, BuildContext context) {
  final user = UserData.fromSnapshow(data);
  String approvalUser = userNameChange(user);

  /*if(user.team != "" && user.team != null) {
    approvalUser = user.team + " " + approvalUser;
  }

  if(user.position != "" && user.position != null) {
    approvalUser = approvalUser + " " + user.position;
  }*/

  return PopupMenuItem(
    height: 7.0.h,
    value: user,
    child: Row(
      children: [
        cardSpace,
        Text(
          approvalUser,
          style: defaultRegularStyle,
        ),
      ],
    ),
  );
}

String userNameChange(UserData user) {
  String approvalUser = user.name;

  if (user.team != "" && user.team != null) {
    approvalUser = user.team + " " + approvalUser;
  }

  if (user.position != "" && user.position != null) {
    approvalUser = approvalUser + " " + user.position;
  }
  return approvalUser;
}

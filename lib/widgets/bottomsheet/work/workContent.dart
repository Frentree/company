import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/i18n/word.dart';

import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';

import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:sizer/sizer.dart';

import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';

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

  User _loginUser;

  DateTime startTime = DateTime.now().minute < 30 ? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,00) : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,30);

  FirebaseRepository _repository = FirebaseRepository();

  if (_workModel != null) {
    _titleController.text = _workModel.title;
    _locationController.text = _workModel.location;
    _contentController.text = _workModel.contents;
    startTime = _format.timeStampToDateTime(_workModel.startTime);
  }

  if(workData != null) {
    _titleController.text = workData.title;
    _locationController.text = workData.location;
    _contentController.text = workData.contents;
    //startTime = _format.timeStampToDateTime(workData.startTime);
  }

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
                          backgroundColor: _titleController.text == "" ? disableUploadBtn : blueColor,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_upward,
                                color: whiteColor,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              ),
                              onPressed: _titleController.text == "" ? () {} : () async {

                                var doc = await FirebaseFirestore.instance.collection("company").doc(_loginUser.companyCode).collection("user").doc(_loginUser.mail).get();
                                CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);


                                _workModel = workModel != null ? WorkModel(
                                  id: workModel.id,
                                  createUid: workModel.createUid,
                                  name: workModel.name,
                                  type: workModel.type,
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  location: _locationController.text,
                                  createDate: workModel.createDate,
                                  lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  startDate: _format.dateTimeToTimeStamp(DateTime( startTime.year, startTime.month, startTime.day, 21, 00,)),
                                  startTime: _format.dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  level: 0,
                                  alarmId: _workModel.alarmId,
                                ) : WorkModel(
                                  createUid: _loginUser.mail,
                                  name: _loginUser.name,
                                  type: type == 1 ? "내근" : "외근",
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  location: _locationController.text,
                                  createDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  startDate: _format.dateTimeToTimeStamp(DateTime(startTime.year, startTime.month, startTime.day, 21, 00,)),
                                  startTime: _format.dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  level: 0,
                                  alarmId: DateTime.now().hashCode,
                                );

                                if (workModel == null) {
                                  Alarm _alarmModel = Alarm(
                                    alarmId: DateTime.now().hashCode,
                                    createName: _loginUser.name,
                                    createMail: _loginUser.mail,
                                    createProfilePhoto: loginUserInfo.profilePhoto,
                                    collectionName: "work",
                                    alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 새로운 " + "일정" + "을 등록 했습니다.",
                                    read: false,
                                    alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  );

                                  await _repository.saveWork(
                                    workModel: _workModel,
                                    companyCode: _loginUser.companyCode,
                                  );

                                  await _repository.saveAlarm(
                                    alarmModel: _alarmModel,
                                    companyCode: _loginUser.companyCode,
                                    mail: _loginUser.mail,
                                  ).whenComplete(() async {

                                    List<String> tokens = await _repository.getTokens(companyCode: _loginUser.companyCode, mail: _loginUser.mail);
                                    fcm.sendFCMtoSelectedDevice(
                                      alarmId: _alarmModel.alarmId.toString(),
                                      tokenList: tokens,
                                      name: _loginUser.name,
                                      team: loginUserInfo.team,
                                      position: loginUserInfo.position,
                                      collection: "work"
                                    );
                                  });

                                  if(startTime.isAfter(DateTime.now())){
                                    await notificationPlugin.scheduleNotification(
                                      alarmId: _workModel.alarmId,
                                      alarmTime: startTime,
                                      title: "일정이 있습니다.",
                                      contents: "일정 내용 : ${_titleController.text}",
                                      payload: _workModel.alarmId.toString(),
                                    );
                                  }
                                }
                                else {
                                  await _repository.updateWork(
                                    workModel: _workModel,
                                    companyCode: _loginUser.companyCode,
                                  );
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
                              DateTime _dateTime = await workDatePage(
                                context: context,
                                startTime: startTime
                              );
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
                      child: Row(
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
                                  icon: isChk == true
                                      ? Icon(Icons.keyboard_arrow_up)
                                      : Icon(Icons.keyboard_arrow_down),
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
                    /*Container(
                      child: Row(
                        children: [
                          Container(
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            height: 6.0.h,
                            child: Checkbox(
                              value: isChk,
                              onChanged: (value) {
                                setState(() {
                                  isChk = value;
                                });
                              },
                            ),
                          ),
                          cardSpace,
                          Text(
                            word.addItem(),
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                    ),*/
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

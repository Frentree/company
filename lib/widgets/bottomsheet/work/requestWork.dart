import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/annual/annualLeaveMain.dart';
import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';
import 'package:MyCompany/widgets/popupMenu/invalidData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

requestWork({BuildContext context, int type, WorkModel workModel, WorkData workData}) async {
  Fcm fcm = Fcm();
  WorkModel _workModel = workModel;
  bool _detailClicked = false;
  bool result = false;
  bool isChk = false;

  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  int choseItem = 0;
  String choseWorkItem = "내근";
  String _approvalUserItem = "선택";
  UserData approvalUser;

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
              color: whiteColor,
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
                            "업무 요청",
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

                                if(choseWorkItem == "외근" && _locationController.text.trim() == ""){
                                  FailedData(context, "외근지 미입력", "외근지를 입력해주세요");
                                  return false;
                                }
                                if(approvalUser == null){
                                  FailedData(context, "대상자 미선택 ", "대상자를 선택해주세요");
                                  return false;
                                }

                                await FirebaseRepository().createAnnualLeave(
                                  companyCode: _loginUser.companyCode,
                                  workApproval: WorkApproval(
                                    title: _titleController.text,
                                    status: "요청",
                                    user: _loginUser.name,
                                    userMail: _loginUser.mail,
                                    createDate: Timestamp.now(),
                                    requestDate: _format.dateTimeToTimeStamp(startTime),
                                    approvalContent: "",
                                    approvalType: "업무",
                                    requestContent: _contentController.text,
                                    approvalUser: approvalUser.name,
                                    approvalMail: approvalUser.mail,
                                    location: choseWorkItem != "내근" ? _locationController.text : "",
                                  ),
                                ).whenComplete(() async {
                                  //결재요청 알림 생성
                                  Alarm _alarmModel = Alarm(
                                    alarmId: DateTime.now().hashCode,
                                    createName: _loginUser.name,
                                    createMail: _loginUser.mail,
                                    collectionName: "requestWork",
                                    alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 업무를 요청했습니다.",
                                    read: false,
                                    alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  );

                                  List<String> token = await _repository.getApprovalUserTokens(companyCode: _loginUser.companyCode, mail: approvalUser.mail);

                                  //결재자 알림 DB에 저장
                                  await _repository.saveOneUserAlarm(
                                    alarmModel: _alarmModel,
                                    companyCode: _loginUser.companyCode,
                                    mail: approvalUser.mail,
                                  ).whenComplete(() async {
                                    fcm.sendFCMtoSelectedDevice(
                                        alarmId: _alarmModel.alarmId.toString(),
                                        tokenList: token,
                                        name: _loginUser.name,
                                        team: loginUserInfo.team,
                                        position: loginUserInfo.position,
                                        collection: "requestWork"
                                    );
                                  });
                                });

                                result = true;
                                Navigator.of(context).pop(result);
                                return result;
                              }
                          ),
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
                    Column(
                      children: [
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
                                    "근무",
                                    style: defaultRegularStyle,
                                  ),
                                ],
                              ),
                            ),
                            cardSpace,
                            Expanded(
                                child: PopupMenuButton(
                                    child: RaisedButton(
                                      disabledColor: whiteColor,
                                      child: Text(
                                        choseWorkItem,
                                        style: defaultRegularStyle,
                                      ),
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        choseItem = value;
                                        choseWorkItem = _buildWorkItem(value);
                                      });
                                    },
                                  //choseItem
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        height: 7.0.h,
                                        value: 0,
                                        child: Row(
                                          children: [
                                            cardSpace,
                                            Text(
                                              "내근",
                                              style: defaultRegularStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        height: 7.0.h,
                                        value: 1,
                                        child: Row(
                                          children: [
                                            cardSpace,
                                            Text(
                                              "외근",
                                              style: defaultRegularStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                )
                            )
                          ],
                        ),
                        Visibility(
                          visible: choseItem == 1,
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
                                    "대상자",
                                    style: defaultRegularStyle,
                                  ),
                                ],
                              ),
                            ),
                            cardSpace,
                            Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseRepository().getRequestUser(
                                        companyCode: _loginUser.companyCode,
                                        mail: _loginUser.mail
                                    ),
                                    builder: (context, snapshot) {
                                      if(!snapshot.hasData){
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
                                          itemBuilder: (context) => doc.map((data) => _buildApprovalItem(_loginUser.companyCode, data, context)).toList()
                                      );
                                    }
                                )
                            ),
                          ],
                        ),

                      ],
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

/// 내/외근 종류 선택 메뉴
String _buildWorkItem(int choseItem) {
  String _choseItem = choseItem.toString();
  switch (_choseItem) {
    case '0':
      return "내근";
    case '1':
      return "외근";
  }
}

String userNameChange (UserData user){
  String approvalUser = user.name;

  if(user.team != "" && user.team != null) {
    approvalUser = user.team + " " + approvalUser;
  }

  if(user.position != "" && user.position != null) {
    approvalUser = approvalUser + " " + user.position;
  }
  return approvalUser;
}



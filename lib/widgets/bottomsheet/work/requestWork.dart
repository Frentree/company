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

  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

  DateTime startTime = selectedDay == today ? DateTime.now().minute < 30 ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30) : selectedDate.minute < 30 ? DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 00) : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 30);

  FirebaseRepository _repository = FirebaseRepository();

  Map<dynamic, dynamic> attendees = {};
  Map<dynamic, dynamic> temp = {};


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
                                if(attendees.isEmpty){
                                  FailedData(context, "대상자 미선택 ", "대상자를 선택해주세요");
                                  return false;
                                }

                                attendees.forEach((key, value) async {
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
                                      approvalUser: value,
                                      approvalMail: key,
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

                                    List<String> token = await _repository.getApprovalUserTokens(companyCode: _loginUser.companyCode, mail: key);

                                    //결재자 알림 DB에 저장
                                    await _repository.saveOneUserAlarm(
                                      alarmModel: _alarmModel,
                                      companyCode: _loginUser.companyCode,
                                      mail: key,
                                    ).whenComplete(() async {
                                      if(token.length != 0){
                                        fcm.sendFCMtoSelectedDevice(
                                            alarmId: _alarmModel.alarmId.toString(),
                                            tokenList: token,
                                            name: _loginUser.name,
                                            team: loginUserInfo.team,
                                            position: loginUserInfo.position,
                                            collection: "requestWork"
                                        );
                                      }

                                    });
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
                              child: GestureDetector(
                                child: attendees.isEmpty ? Icon(
                                  Icons.person_add_alt_1,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                ) : Container(
                                  height: 4.0.h,
                                  alignment: Alignment.center,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: attendees.length,
                                    itemBuilder: (context, index) {
                                      String key = attendees.keys.elementAt(index);
                                      return Row(
                                        children: [
                                          Container(
                                            decoration: containerChipDecoration,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              attendees[key],
                                              style: containerChipStyle,
                                            ),
                                          ),
                                          cardSpace,
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                onTap: () {
                                  if(attendees.isNotEmpty){
                                    temp.addAll(attendees);
                                  }
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        bool isChk2 = false;
                                        return AlertDialog(
                                          title: Text(
                                            "직원 선택",
                                            style: defaultMediumStyle,
                                          ),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              height: 50.0.h,
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
                                              child: StreamBuilder(
                                                stream: FirebaseRepository().getColleagueInfo(companyCode: _loginUser.companyCode),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) return LinearProgressIndicator();
                                                  List<CompanyUser> _companyUser = [];
                                                  snapshot.data.documents.forEach((element){
                                                    var elementData = element.data();
                                                    if(elementData["mail"] != _loginUser.mail){
                                                      _companyUser.add(CompanyUser.fromMap(elementData, element.documentID));
                                                    }
                                                  });

                                                  return ListView.builder(
                                                    itemCount: _companyUser.length,
                                                    itemBuilder: (context, index){
                                                      return StatefulBuilder(
                                                        key: ValueKey(_companyUser[index].mail),
                                                        builder: (context, setState){
                                                          return CheckboxListTile(
                                                            dense: true,
                                                            contentPadding: textFormPadding,
                                                            secondary: CircleAvatar(
                                                              radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.0.w : 4.0.w,
                                                              backgroundColor: whiteColor,
                                                              backgroundImage:
                                                              NetworkImage(_companyUser[index].profilePhoto),
                                                            ),
                                                            title: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  _companyUser[index].name + " " + _companyUser[index].position,
                                                                  style: defaultRegularStyle,
                                                                ),
                                                                Text(
                                                                  _companyUser[index].team,
                                                                  style: hintStyle,
                                                                ),
                                                              ],
                                                            ),
                                                            value: temp.containsKey(_companyUser[index].mail),
                                                            onChanged: (bool value){
                                                              setState(() {
                                                                if (value == true) {
                                                                  temp.addAll({_companyUser[index].mail: _companyUser[index].team + _companyUser[index].name + _companyUser[index].position});
                                                                } else {
                                                                  temp.removeWhere((key, value) => key == _companyUser[index].mail);
                                                                }
                                                              });
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                word.yes(),
                                                style: buttonBlueStyle,
                                              ),
                                              onPressed: () {
                                                List<String> keyList = [];
                                                setState((){
                                                  attendees.addAll(temp);
                                                  attendees.forEach((key, value) {
                                                    print("key ====> ${key}");
                                                    print("temp.containsKey(key) ======> ${temp.containsKey(key)}");
                                                    if(temp.containsKey(key) == false){
                                                      keyList.add(key);
                                                    }
                                                  });
                                                  keyList.forEach((element) {
                                                    attendees.remove(element);
                                                  });
                                                });
                                                temp = {};
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                word.no(),
                                                style: buttonBlueStyle,
                                              ),
                                              onPressed: () {
                                                temp = {};
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      }
                                  );
                                },
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



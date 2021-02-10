
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/alarm/signBoxExpensePickDate.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/popupMenu/invalidData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

AnnualLeaveMain(BuildContext context) async {
  FirebaseRepository _reposistory = FirebaseRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool isChk = false;

  LoginUserInfoProvider _loginUserInfoProvider;

  _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context, listen: false);
  User user = _loginUserInfoProvider.getLoginUser();
  UserData approvalUser;

  TextEditingController _contentController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  bool result = false;
  WorkApproval _approval;

  int _chosenItem = 0;
  int _chosenTimeItem = 0;
  String _approvalUserItem = "선택";

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  Format _format = Format();

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  /// 연차 신청 바텀시트
  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            /// iOS용 데이트 피커 위젯
            buildCupertinoDatePicker(BuildContext context) {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        height:
                            MediaQuery.of(context).copyWith().size.height / 2.5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Chip(
                                        backgroundColor: chipColorBlue,
                                        label: Text(
                                          "연차 신청",
                                          style: customStyle(
                                            fontSize: 14,
                                            fontColor: mainColor,
                                            fontWeightName: 'Regular',
                                          ),
                                        ),
                                      ),
                                    ),
                                    /*Padding(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Text("잔여 연차")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: blueColor,
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_upward),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )),
                                    ),*/
                                  ]),
                              Container(
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height /
                                    3.2,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (picked) {
                                    if (picked != null &&
                                        picked != selectedDate)
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                  },
                                  initialDateTime: selectedDate,
                                  minimumYear: 2000,
                                  maximumYear: 2025,
                                ),
                              )
                            ]));
                  });
            }

            /// 안드로이드용 데이트 피커 위젯
            buildMaterialDatePicker(BuildContext context) async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDatePickerMode: DatePickerMode.day,
                selectableDayPredicate: _decideWhichDayToEnable,
                helpText: '날짜를 선택해 주세요',
                cancelText: '취소',
                confirmText: '확인',
                errorFormatText: 'Enter valid date',
                errorInvalidText: 'Enter date in valid range',
                fieldLabelText: 'Booking date',
                fieldHintText: 'Month/Date/Year',
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              );
              if (picked != null && picked != selectedDate)
                setState(() {
                  selectedDate = picked;
                });
            }

            /// 플랫폼 종류 인식 후 데이트 피커 제공 메서드
            _selectDate(BuildContext context) {
              final ThemeData theme = Theme.of(context);
              assert(theme.platform != null);
              switch (theme.platform) {
                case TargetPlatform.android:
                case TargetPlatform.fuchsia:
                case TargetPlatform.linux:
                case TargetPlatform.windows:
                  return
                      buildMaterialDatePicker(context);
                case TargetPlatform.iOS:
                case TargetPlatform.macOS:
                  return
                      buildCupertinoDatePicker(context);
              }
            }

            // 경비 품의 바텀시트 드로잉
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 28.0.w,
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
                              "연차 신청",
                              style: defaultMediumStyle,
                            ),
                          ),
                          cardSpace,
                          Expanded(
                            child: SizedBox(),
                          ),
                          /*Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "잔여 연차",
                                  style: defaultMediumStyle,
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Text(
                                        "15",
                                        style: cardBlueStyle,
                                      ),
                                      Text(
                                        " 일 >>",
                                        style: cardBlueStyle,
                                      ),
                                    ],
                                  ),
                                  onTap: (){

                                  },
                                )
                              ],
                            )
                          ),
                          cardSpace,*/
                          CircleAvatar(
                            radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            backgroundColor: _expenseController.text == "" ? disableUploadBtn : blueColor,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: whiteColor,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                ),
                              onPressed: () async {
                                var doc = await FirebaseFirestore.instance.collection("company").doc(user.companyCode).collection("user").doc(user.mail).get();
                                CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

                                 if(approvalUser == null){
                                   FailedData(context, "결재자 미선택", "결재자를 선택 후에 신청해주세요");
                                   return;
                                 }
                                 if(_chosenItem == 1 && _chosenTimeItem == 1 ){  //반차, 오후
                                   selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd 13:00:00').format(selectedDate).toString());
                                 } else {
                                   selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd 09:00:00').format(selectedDate).toString());
                                 }
                                _approval = WorkApproval(
                                  title: DateFormat('yyyyMMdd').format(selectedDate).toString() + "_" +  _buildAnnualItem(_chosenItem) + "_" + user.name,
                                  status: "요청",
                                  user: user.name,
                                  userMail: user.mail,
                                  createDate: Timestamp.now(),
                                  requestDate: _format.dateTimeToTimeStamp(selectedDate),
                                  approvalContent: "",
                                  approvalType: _buildAnnualItem(_chosenItem),
                                  requestContent: _contentController.text,
                                  approvalUser: approvalUser.name,
                                  approvalMail: approvalUser.mail,
                                  location: "",
                                );

                                FirebaseRepository().createAnnualLeave(
                                  companyCode: user.companyCode,
                                  workApproval: _approval
                                ).whenComplete(() async {
                                  Alarm _alarmModel = Alarm(
                                    alarmId: 0,
                                    createName: user.name,
                                    createMail: user.mail,
                                    collectionName: "annualLeave",
                                    alarmContents: loginUserInfo.team + " " + user.name + " " + loginUserInfo.position + "님이 " + _approval.approvalType + "를 요청했습니다.",
                                    read: false,
                                    alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                  );

                                  List<String> token = await FirebaseRepository().getApprovalUserTokens(companyCode: user.companyCode, mail: approvalUser.mail);

                                  //결재자 알림 DB에 저장
                                  await FirebaseRepository().saveOneUserAlarm(
                                    alarmModel: _alarmModel,
                                    companyCode: user.companyCode,
                                    mail: approvalUser.mail,
                                  ).whenComplete(() async {
                                    Fcm().sendFCMtoSelectedDevice(
                                        alarmId: _alarmModel.alarmId.toString(),
                                        tokenList: token,
                                        name: user.name,
                                        team: loginUserInfo.team,
                                        position: loginUserInfo.position,
                                        collection: "annualLeave@${_approval.approvalType}"
                                    );
                                  });
                                });

                                Navigator.of(context).pop(true);
                              },
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
                                  Words.word.dateTime(),
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          cardSpace,
                          Expanded(
                            child: InkWell(
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                                style: defaultRegularStyle,
                              ),
                              onTap: () async {
                                //_selectDate(context);
                                selectedDate = await pickDate(
                                    context,
                                    selectedDate
                                );
                                setState((){});
                              },
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
                                  "종류",
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
                                  _buildAnnualItem(_chosenItem),
                                  style: defaultRegularStyle,
                                ),
                              ),
                              onSelected: (value) {
                                _chosenItem = value;
                                setState(() {});
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  height: 7.0.h,
                                  value: 0,
                                  child: Row(
                                    children: [
                                      cardSpace,
                                      Text(
                                        "연차",
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
                                        "반차",
                                        style: defaultRegularStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                      cardSpace,
                      Visibility(
                        visible: _chosenItem == 1,
                        child: Row(
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
                                    "반차 시간",
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
                                        _buildTimeItem(_chosenTimeItem),
                                        style: defaultRegularStyle,
                                      ),
                                    ),
                                    onSelected: (value) {
                                      _chosenTimeItem = value;
                                      setState(() {});
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        height: 7.0.h,
                                        value: 0,
                                        child: Row(
                                          children: [
                                            cardSpace,
                                            Text(
                                              "오전",
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
                                              "오후",
                                              style: defaultRegularStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                )
                            ),
                          ],
                        ),
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
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseRepository().getGradeUser(
                                  companyCode: user.companyCode,
                                  level: 6
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
                                        print(user.name.toString());
                                        _approvalUserItem = userNameChange(approvalUser);
                                        setState(() {});
                                      },
                                      itemBuilder: (context) => doc.map((data) => _buildApprovalItem(user.companyCode, data, context)).toList()
                                  );
                                }
                              )
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
                    ]),
              ),
            );
          },
        );
      }
      );
  return result;
}

/// 연차 종류 선택 메뉴
String _buildAnnualItem(int chosenItem) {
  String _chosenItem = chosenItem.toString();
  switch (_chosenItem) {
    case '0':
      return "연차";
    case '1':
      return "반차";
  }
}

/// 연차 종류 선택 메뉴
String _buildTimeItem(int chosenItem) {
  String _chosenItem = chosenItem.toString();
  switch (_chosenItem) {
    case '0':
      return "오전";
    case '1':
      return "오후";
  }
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

class UserData {
  final String name;
  final String mail;
  final String position;
  final String team;
  final DocumentReference reference;

  UserData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
       assert(map['mail'] != null),
       assert(map['position'] != null),
       assert(map['team'] != null),
        name = map['name'],
        mail = map['mail'],
        position = map['position'],
        team = map['team'];

  UserData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
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




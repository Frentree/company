import 'dart:io';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/form/customInputFormatter.dart';
import 'package:MyCompany/widgets/popupMenu/invalidData.dart';
import 'package:sizer/sizer.dart';

AnnualLeaveMain(BuildContext context) async {
  FirebaseRepository _reposistory = FirebaseRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  LoginUserInfoProvider _loginUserInfoProvider;

  _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context, listen: false);
  User user = _loginUserInfoProvider.getLoginUser();
  UserData approvalUser;

  TextEditingController _expenseController = TextEditingController();

  bool result = false;
  WorkApproval _approval;

  int _chosenItem = 0;
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
                                    Padding(
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
                                    ),
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
                          cardSpace,
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
                                 if(approvalUser == null){
                                   FailedData(context, "결재자 미선택", "결재자를 선택 후에 신청해주세요");
                                   return;
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
                                  requestContent: "",
                                  approvalUser: approvalUser.name,
                                  approvalMail: approvalUser.mail
                                );

                                FirebaseRepository().createAnnualLeave(
                                  companyCode: user.companyCode,
                                  workApproval: _approval
                                );

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
                              onTap: () {
                                _selectDate(context);
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
                                print(_chosenItem);
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



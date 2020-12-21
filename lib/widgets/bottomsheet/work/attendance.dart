import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';


import 'package:sizer/sizer.dart';

final word = Words();

attendance({BuildContext context, double statusBarHeight}) async {
  bool result = false;
  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  User _loginUser;
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String nowTime = _format.twoDigitsFormat(DateTime.now().hour) + ":" + _format.twoDigitsFormat(DateTime.now().minute);

  FirebaseRepository _repository = FirebaseRepository();

  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(pageRadiusW.w),
        topLeft: Radius.circular(pageRadiusW.w),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();
      print(statusBarHeight);
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height - 10.0.h - statusBarHeight,
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                  ),
                  color: whiteColor,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 6.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                color: mainColor,
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                nowTime + " " + Words.word.currentWorkStatus(),
                                style: defaultMediumStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    emptySpace,
                    Padding(
                      padding: cardPadding,
                      child: Container(
                        height: 3.0.h,
                        child: Row(
                          children: [
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                Words.word.name(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                Words.word.team(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                Words.word.workState(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                Words.word.etc(),
                                style: cardBlueStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    emptySpace,
                    StreamBuilder(
                      stream: _repository.getColleagueInfo(companyCode: _loginUser.companyCode),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.data == null){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<dynamic, dynamic> colleague = {};
                        List<CompanyUser> _companyUserInfo = [];

                        snapshot.data.documents.forEach((element){
                          var elementData = element.data();
                          if(elementData["mail"] != _loginUser.mail){
                            _companyUserInfo.add(CompanyUser.fromMap(elementData, element.documentID));
                            colleague.addAll({elementData["mail"]: elementData["name"]});
                          }
                        });
                        return StreamBuilder(
                          stream: _repository.getColleagueNowAttendance(companyCode: _loginUser.companyCode, loginUserMail: _loginUser.mail, today: _format.dateTimeToTimeStamp(today),),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            Map<String, dynamic> attendanceData = {};

                            colleague.keys.forEach((element) {
                              attendanceData.addAll({element: ""});
                            });

                            snapshot.data.documents.forEach((element){
                              var elementData = element.data();
                              attendanceData.update(elementData["mail"], (value) => elementData);
                            });

                            print(attendanceData);
                            return Expanded(
                              child: ListView.builder(
                                itemCount: attendanceData.keys.length,
                                itemBuilder: (context, index){
                                  Attendance _attendance = attendanceData[attendanceData.keys.elementAt(index)] == "" ? null : Attendance.fromMap(attendanceData[attendanceData.keys.elementAt(index)], "");
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
                                              alignment: Alignment.center,
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                                colleague.values.elementAt(index),
                                                style: containerChipStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Container(
                                              alignment: Alignment.center,
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                                _companyUserInfo[index].team,
                                                style: containerChipStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Container(
                                              alignment: Alignment.center,
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                                ( _attendance == null || _attendance.status == 0) ? Words.word.beforeWork() : _attendance.status == 1 ? Words.word.workIn() : _attendance.status == 2 ? Words.word.workOut() : Words.word.leaveWork(),
                                                style: containerChipStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
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

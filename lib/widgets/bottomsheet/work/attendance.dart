import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/models/attendanceModel.dart';
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

attendance({BuildContext context}) async {
  bool result = false;
  bool isChk = false;

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
        topRight: Radius.circular(3.0.w),
        topLeft: Radius.circular(3.0.w),
      ),
    ),
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
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 2.0.h,
                  left: 5.0.w,
                  right: 5.0.w,
              ),
              child: Container(
                height: 50.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 6.0.w,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          height: 5.0.h,
                          child: Center(
                            child: Text(
                              nowTime + " 현재 동료 근무 현황",
                              style: customStyle(
                                fontSize: 13.0.sp,
                                fontWeightName: "Medium",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 6.0.w,
                        )
                      ],
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
                                "이름",
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                "부서",
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                "근무상태",
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                "기타",
                                style: cardBlueStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    emptySpace,
                    StreamBuilder(
                      stream: _repository.getColleague(loginUserMail: _loginUser.mail, companyCode: _loginUser.companyCode).asStream(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.data == null){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<dynamic, dynamic> colleague = {};
                        colleague.addAll(snapshot.data);

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
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                                colleague.values.elementAt(index),
                                                style: containerChipStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Container(
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                                "개발팀",
                                                style: containerChipStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Container(
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                                              child: Text(
                                               ( _attendance == null || _attendance.status == 0) ? "출근전" : _attendance.status == 1 ? "내근" : _attendance.status == 2 ? "외근" : "퇴근",
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

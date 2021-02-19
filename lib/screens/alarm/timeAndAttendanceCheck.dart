import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/approval/approvalDetail.dart';
import 'package:MyCompany/widgets/bottomsheet/annual/annualLeaveMain.dart';
import 'package:MyCompany/widgets/bottomsheet/pickMonth.dart';
import 'package:MyCompany/widgets/card/approvalCard.dart';
import 'package:MyCompany/widgets/card/timeAndAttendanceCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TimeAndAttendanceCheck extends StatefulWidget {
  @override
  TimeAndAttendanceCheckState createState() => TimeAndAttendanceCheckState();
}

class TimeAndAttendanceCheckState extends State<TimeAndAttendanceCheck> {
  User _loginUser;
  FirebaseRepository _repository = FirebaseRepository();
  DateTime selectedMonth = DateTime.now();
  String _selectUserName = "전체";
  String _selectUserMail = "";

  Format _format = Format();

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      body: FutureBuilder(
        future: _repository.userGrade(_loginUser.companyCode, _loginUser.mail),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<dynamic> grade = snapshot.data['level'];
          return Column(
            children: [
              Card(
                elevation: 0,
                shape: cardShape,
                child: Padding(
                  padding: cardPadding,
                  child: Container(
                    height: scheduleCardDefaultSizeH.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 19.0.w
                              : 15.0.w,
                          alignment: Alignment.center,
                          child: Text(
                            "일자",
                            style: cardBlueStyle,
                          ),
                        ),
                        cardSpace,
                        Visibility(
                          visible: (grade.contains(6) || grade.contains(9)),
                          child: Container(
                            width: SizerUtil.deviceType == DeviceType.Tablet
                                ? 22.5.w
                                : 19.5.w,
                            alignment: Alignment.center,
                            child: Text(
                              "이름",
                              style: cardBlueStyle,
                            ),
                          ),
                        ),
                        cardSpace,
                        Container(
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 16.0.w
                              : 11.5.w,
                          alignment: Alignment.center,
                          child: Text(
                            "출근",
                            style: cardBlueStyle,
                          ),
                        ),
                        cardSpace,
                        Container(
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 16.0.w
                              : 11.5.w,
                          alignment: Alignment.center,
                          child: Text(
                            "퇴근",
                            style: cardBlueStyle,
                          ),
                        ),
                        cardSpace,
                        Container(
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 16.0.w
                              : 12.5.w,
                          alignment: Alignment.center,
                          child: Text(
                            "근무시간",
                            style: cardBlueStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: (grade.contains(6) || grade.contains(9)) ? _selectUserMail == "" ? _repository.getAllAttendance(companyCode: _loginUser.companyCode, thisMonth: selectedMonth) : _repository.getMyAttendance(companyCode: _loginUser.companyCode, loginUserMail: _selectUserMail, thisMonth: selectedMonth) : _repository.getMyAttendance(companyCode: _loginUser.companyCode, loginUserMail: _loginUser.mail, thisMonth: selectedMonth),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var _taData = [];

                  snapshot.data.docs.forEach((element) {
                    _taData.add(element);
                  });

                  if(_taData.length == 0){
                    return Expanded(
                      child: ListView(
                        children: [
                          Card(
                            elevation: 0,
                            shape: cardShape,
                            child: Padding(
                              padding: cardPadding,
                              child: Container(
                                height: scheduleCardDefaultSizeH.h,
                                alignment: Alignment.center,
                                child: Text(
                                  "근태 정보가 없습니다.",
                                  style: cardTitleStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else{
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _taData.length,
                        itemBuilder: (context, index){
                          Attendance _attendance = Attendance.fromMap(_taData[index].data(), _taData[index].documentID);

                          if((grade.contains(6) || grade.contains(9))){
                            return FutureBuilder(
                              future: _repository.getMyCompanyInfo(companyCode: _loginUser.companyCode, myMail: _attendance.mail),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return CircularProgressIndicator();
                                return timeAndAttendanceCard(
                                  context: context,
                                  attendanceModel: _attendance,
                                  companyUserInfo: snapshot.data,
                                  isAllQuery: true,
                                );
                              }
                            );
                          }

                          else{
                            return timeAndAttendanceCard(
                              context: context,
                              attendanceModel: _attendance,
                              isAllQuery: false,
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              ),
              Visibility(
                visible: (grade.contains(6) || grade.contains(9)),
                child: Card(
                  elevation: 0,
                  shape: cardShape,
                  child: Row(
                    children: [
                      Padding(
                        padding: cardPadding,
                        child: Container(
                          height: scheduleCardDefaultSizeH.h,
                          child: Row(
                            children: [
                              InkWell(
                                child: Text(
                                  DateFormat('yyyy년 MM월').format(selectedMonth),
                                  style: defaultRegularStyle,
                                ),
                                onTap: () async {
                                  DateTime _temp = await pickMonth(context, selectedMonth);
                                  setState(() {
                                    selectedMonth = _temp;
                                  });
                                },
                              ),

                              StreamBuilder(
                                stream: _repository.getColleagueInfo(companyCode: _loginUser.companyCode),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Text("");
                                  }
                                  List<DocumentSnapshot> doc = snapshot.data.docs;
                                  doc.add(null);
                                  return PopupMenuButton(
                                    child: RaisedButton(
                                      disabledColor: whiteColor,
                                      child: Text(
                                        _selectUserName,
                                        style: defaultSmallStyle,
                                      ),
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        if(value == "all"){
                                          _selectUserName = "전체";
                                          _selectUserMail = "";
                                        }
                                        else{
                                          _selectUserName = "${value.team} ${value.name} ${value.position}";
                                          _selectUserMail = value.mail;
                                        }
                                      });
                                    },
                                    itemBuilder: (context) => doc.map((data) => _buildUserItem(data)).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}

/// 사용자 선택 메뉴
PopupMenuItem _buildUserItem(DocumentSnapshot data) {
  final user = data != null ? CompanyUser.fromMap(data.data(), "") : null;

  return PopupMenuItem(
    height: 7.0.h,
    value: user != null ? user : "all",
    child: Row(
      children: [
        cardSpace,
        Text(
          user != null ? "${user.team} ${user.name} ${user.position}" : "전체",
          style: defaultRegularStyle,
        ),
      ],
    ),
  );
}
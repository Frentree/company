//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/provider/attendance/attendanceCheck.dart';
import 'package:companyplaylist/screens/home/homeCoSchedule.dart';
import 'package:companyplaylist/screens/home/homeSchedule.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Repos
import 'package:companyplaylist/repos/showSnackBarMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/provider/attendance/attendanceCheck.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/attendanceModel.dart';

import 'package:companyplaylist/widgets/notImplementedPopup.dart';

class HomeScheduleMainPage extends StatefulWidget {
  @override
  HomeScheduleMainPageState createState() => HomeScheduleMainPageState();
}

class HomeScheduleMainPageState extends State<HomeScheduleMainPage> {
  int tabIndex = 0;

  Attendance _attendance = Attendance();

  List<Widget> _page = [HomeSchedulePage(),HomeScheduleCoPage()];

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    AttendanceCheck _attendanceProvider = Provider.of<AttendanceCheck>(context);
    _attendance = _attendanceProvider.getAttendanceData();

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  size: customHeight(
                      context: context,
                      heightSize: 0.04
                  ),
                  color: Colors.white,
                ),
                onPressed: (){
                  NotImplementedFunction(context);
                },
                /*onPressed: _attendance.status == 1 ? () async {
                  String result = await _attendanceProvider.manualOffWork(
                    context: context,
                  );

                  if(result == "OK"){
                    Fluttertoast.showToast(
                        msg: "퇴근이 정상적으로 처리되었습니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity:  ToastGravity.BOTTOM,
                        backgroundColor: blackColor
                    );
                  }
                } : () async {
                  String result = await _attendanceProvider.manualOnWork(
                      context: context
                  );

                  if(result == "OK"){
                    Fluttertoast.showToast(
                        msg: "출근이 정상적으로 처리되었습니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity:  ToastGravity.BOTTOM,
                        backgroundColor: blackColor
                    );
                  }
                }*/
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                _attendance.status == 0 ? "출근전" :  _attendance.status == 1 ? "근무" : "퇴근"
              ),
            )
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(
                context: context,
                widthSize: 0.2
            ),
            child: GestureDetector(
              child: Container(
                height: customHeight(
                    context: context,
                    heightSize: 0.05
                ),
                width: customWidth(
                    context: context,
                    widthSize: 0.1
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: whiteColor,
                    border: Border.all(color: whiteColor, width: 2)
                ),
                child: Text(
                  "사진",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              onTap: (){
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ),
        ],
      ),

      body: Container(
        width: customWidth(
            context: context,
            widthSize: 1
        ),
        padding: EdgeInsets.only(
            left: customWidth(
              context: context,
              widthSize: 0.02,
            ),
            right: customWidth(
              context: context,
              widthSize: 0.02,
            )
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            ),
            color: whiteColor
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              height: customHeight(
                  context: context,
                  heightSize: 0.06
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: tabColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  tabBtn(
                      context: context,
                      heightSize: 0.05,
                      widthSize: 0.46,
                      btnText: "나의 일정",
                      tabIndexVariable: tabIndex,
                      tabOrder: 0,
                      tabAction: (){
                        setState(() {
                          tabIndex = 0;
                        });
                      }
                  ),
                  tabBtn(
                      context: context,
                      heightSize: 0.05,
                      widthSize: 0.46,
                      btnText: "동료 일정",
                      tabIndexVariable: tabIndex,
                      tabOrder: 1,
                      tabAction: (){
                        setState(() {
                          tabIndex = 1;
                        });
                      }
                  ),
                ],
              ),
            ),

            Expanded(
              child: _page[tabIndex],
            )
          ],
        ),
      ),
    );
  }
}
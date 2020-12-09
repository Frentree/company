//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';
import 'package:MyCompany/screens/home/homeCoSchedule.dart';
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';

//Repos
import 'package:MyCompany/repos/showSnackBarMethod.dart';
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';

//Model
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/attendanceModel.dart';

class HomeScheduleMainPage extends StatefulWidget {
  @override
  HomeScheduleMainPageState createState() => HomeScheduleMainPageState();
}

class HomeScheduleMainPageState extends State<HomeScheduleMainPage> {
  int tabIndex = 0;

  List<Widget> _page = [HomeSchedulePage(), HomeScheduleCoPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
    );
  }
}
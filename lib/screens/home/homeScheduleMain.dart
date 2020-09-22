//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/attendanceModel.dart';

class HomeScheduleMainPage extends StatefulWidget {
  @override
  HomeScheduleMainPageState createState() => HomeScheduleMainPageState();
}

class HomeScheduleMainPageState extends State<HomeScheduleMainPage> {
  CalendarController _calendarController;
  
  int tabIndex = 0;

  User _loginUser = User();
  Attendance _attendance = Attendance();

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }

  void dispose(){
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    
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
              ),
              onPressed: (){
                null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "출퇴근 정보"
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
            TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              availableCalendarFormats: {
                CalendarFormat.week: "Week",
                CalendarFormat.month: "Month"
              },
              locale: 'ko_KR',
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: customStyle(
                  fontSize: 13,
                  fontWeightName: "Bold",
                  fontColor: whiteColor
                ),
              ),
              calendarStyle:  CalendarStyle(
                selectedColor: mainColor,
                selectedStyle: customStyle(
                  fontSize: 18,
                  fontWeightName: "Bold",
                  fontColor: whiteColor
                )
              ),
            ),
           /* Padding(
              padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.0)),
            ),*/
            Container(
              height: customHeight(
                context: context,
                heightSize: 0.08
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
                    btnText: "동료 일정",
                    tabIndexVariable: tabIndex,
                    tabOrder: 1,
                    tabAction: (){
                      setState(() {
                        tabIndex = 1;
                      });
                    }
                  ),
                  tabBtn(
                    context: context,
                    btnText: "내 결재함",
                    tabIndexVariable: tabIndex,
                    tabOrder: 2,
                    tabAction: (){
                      setState(() {
                        tabIndex = 2;
                      });
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
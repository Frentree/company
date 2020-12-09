
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/alarm/alarmNotice.dart';
import 'package:MyCompany/screens/alarm/signBox.dart';
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AlarmMainPage extends StatefulWidget {
  @override
  AlarmMainPageState createState() => AlarmMainPageState();
}

class AlarmMainPageState extends State<AlarmMainPage> {
  int tabIndex = 0;
  List<Widget> _page = [Container(),SignBox(),AlarmNoticePage()];

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
                      widthSize: 0.3,
                      btnText: "알림",
                      tabIndexVariable: tabIndex,
                      tabOrder: 0,
                      tabAction: (){
                        NotImplementedFunction(context);
                        setState(() {
                          tabIndex = 0;
                        });
                      }
                  ),
                  tabBtn(
                      context: context,
                      heightSize: 0.05,
                      widthSize: 0.3,
                      btnText: "내 결재함",
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
                      heightSize: 0.05,
                      widthSize: 0.3,
                      btnText: "공지사항",
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Expanded(
              child:_page[tabIndex],
            )
          ],
        ),
    );
  }
}
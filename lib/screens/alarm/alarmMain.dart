
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/alarm/alarmNotice.dart';
import 'package:companyplaylist/screens/home/homeSchedule.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AlarmMainPage extends StatefulWidget {
  @override
  AlarmMainPageState createState() => AlarmMainPageState();
}

class AlarmMainPageState extends State<AlarmMainPage> {
  int tabIndex = 0;
  User _loginUser;
  Attendance _attendance = Attendance();

  List<Widget> _page = [HomeSchedulePage(),AlarmNoticePage(),AlarmNoticePage()];

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
                  "알림 센터"
              ),
            ),

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
              padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.02)),
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
                      btnText: "파일함",
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
      ),
    );
  }
}

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/screens/alarm/alarmNotice.dart';
import 'package:MyCompany/screens/alarm/signBox.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final word = Words();
class AlarmMainPage extends StatefulWidget {
  @override
  AlarmMainPageState createState() => AlarmMainPageState();
}

class AlarmMainPageState extends State<AlarmMainPage> {
  int tabIndex = 2;
  List<Widget> _page = [Container(),SignBox(),AlarmNoticePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Container(
              height: 6.0.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0.w),
                  color: tabColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  tabBtn(
                      context: context,
                      heightSize: 5,
                      widthSize: 30,
                      btnText: word.alarm(),
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
                      heightSize: 5,
                      widthSize: 30,
                      btnText: word.myApproval(),
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
                      heightSize: 5,
                      widthSize: 30,
                      btnText: word.notice(),
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
            Expanded(
              child:_page[tabIndex],
            )
          ],
        ),
    );
  }
}
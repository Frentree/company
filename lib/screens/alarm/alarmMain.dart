import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/provider/screen/alarmScreenChange.dart';
import 'package:MyCompany/screens/alarm/alarmInquiry.dart';
import 'package:MyCompany/screens/alarm/alarmNotice.dart';
import 'package:MyCompany/screens/alarm/signBox.dart';
import 'package:MyCompany/screens/home/homeMain.dart';
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';

import 'alarmPage.dart';

final word = Words();
class AlarmMainPage extends StatefulWidget {
  @override
  AlarmMainPageState createState() => AlarmMainPageState();
}

class AlarmMainPageState extends State<AlarmMainPage> {
  int tabIndex = 0;
  List<Widget> _page = [AlarmPage(),SignBox(),AlarmInquiry(),AlarmNoticePage()];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    /*AlarmScreenChangeProvider provider = AlarmScreenChangeProvider();*/
    return Scaffold(
      body: Column(
          children: <Widget>[
            Container(
              height: 6.0.h,
              padding: EdgeInsets.symmetric(
                  horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? tabRadiusTW.w : tabRadiusMW.w),
                color: tabColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 5.0.h,
                      width: 22.5.w,
                      alignment: Alignment.center,
                      decoration: tabIndex == 0 ? BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                      ) : null,
                      child: Text(
                        word.alarm(),
                        style: defaultMediumStyle,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        tabIndex = 0;
                      });
                    },
                  ),


                  InkWell(
                    child: Container(
                      height: 5.0.h,
                      width: 22.5.w,
                      alignment: Alignment.center,
                      decoration: tabIndex == 1 ? BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                      ) : null,
                      child: Text(
                        word.myApproval(),
                        style: defaultMediumStyle,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        tabIndex = 1;
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      height: 5.0.h,
                      width: 22.5.w,
                      alignment: Alignment.center,
                      decoration: tabIndex == 2 ? BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                      ) : null,
                      child: Text(
                        "조회",
                        style: defaultMediumStyle,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        tabIndex = 2;
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      height: 5.0.h,
                      width: 22.5.w,
                      alignment: Alignment.center,
                      decoration: tabIndex == 3 ? BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                      ) : null,
                      child: Text(
                        word.notice(),
                        style: defaultMediumStyle,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        tabIndex = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
            emptySpace,
            Expanded(
              child:_page[tabIndex],
            )
          ],
        ),
    );
  }
}
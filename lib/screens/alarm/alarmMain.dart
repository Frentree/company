import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
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
                      width: 30.0.w,
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
                      NotImplementedScreen(context);
                      setState(() {
                        tabIndex = 0;
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      height: 5.0.h,
                      width: 30.0.w,
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
                      width: 30.0.w,
                      alignment: Alignment.center,
                      decoration: tabIndex == 2 ? BoxDecoration(
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
                        tabIndex = 2;
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
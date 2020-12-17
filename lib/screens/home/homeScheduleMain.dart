//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/screens/home/homeCoSchedule.dart';
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//Const
import 'package:MyCompany/consts/colorCode.dart';


//Model
import 'package:sizer/sizer.dart';

final word = Words();

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
                    width: 42.0.w,
                    alignment: Alignment.center,
                    decoration: tabIndex == 0 ? BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                    ) : null,
                    child: Text(
                      word.mySchedule(),
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
                    width: 42.0.w,
                    alignment: Alignment.center,
                    decoration: tabIndex == 1 ? BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w),
                    ) : null,
                    child: Text(
                      word.colleagueSchedule(),
                      style: defaultMediumStyle,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      tabIndex = 1;
                    });
                  },
                ),
              ],
            ),
          ),
          emptySpace,
          Expanded(
            child: _page[tabIndex],
          )
        ],
      ),
    );
  }
}
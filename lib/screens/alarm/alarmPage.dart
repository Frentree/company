import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/screens/alarm/allAlarm.dart';
import 'package:MyCompany/screens/alarm/noReadAlarm.dart';
import 'package:MyCompany/screens/alarm/signBoxPurchase.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class AlarmPage extends StatefulWidget {
  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> {

  int tabIndex = 0;
  List<Widget> _page = [NoReadAlarm(),AllAlarm()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
            ),
            height: 6.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: 5.0.h,
                    width: 42.0.w,
                    alignment: Alignment.center,
                    decoration: tabIndex == 0 ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: mainColor,
                              width: 1.0,
                            )
                        )
                    ) : null,
                    child: Text(
                      "읽지 않음",
                      style: defaultMediumStyle,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                ),
                cardSpace,
                InkWell(
                  child: Container(
                    height: 5.0.h,
                    width: 42.0.w,
                    alignment: Alignment.center,
                    decoration: tabIndex == 1 ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: mainColor,
                              width: 1.0,
                            )
                        )
                    ) : null,
                    child: Text(
                      "전체",
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
          Expanded(
            child:_page[tabIndex],
          )
        ],
      ),
    );
  }
}

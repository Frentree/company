import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/screens/alarm/signBoxExpense.dart';
import 'package:MyCompany/screens/alarm/signBoxPurchase.dart';
import 'package:MyCompany/screens/alarm/signBoxReception.dart';
import 'package:MyCompany/screens/home/homeMain.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';
class SignBox extends StatefulWidget {
  @override
  _SignBoxState createState() => _SignBoxState();
}

class _SignBoxState extends State<SignBox> {

  int tabIndex = 0;
  List<Widget> _page = [SignBoxExpense(),SignBoxPurchase(),SignBoxReception()];

  @override
  void initState() {
    super.initState();
    if(btnClick == true){
      setState(() {
        tabIndex = 2;
        btnClick = false;
      });
    }
  }

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
                    width: 28.0.w,
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
                      word.exSetBox(),
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

                /// 기능 미구현으로 인한 숨김 처리
                InkWell(
                  child: Container(
                    height: 5.0.h,
                    width: 28.0.w,
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
                      word.appForapproval(),
                      style: defaultMediumStyle,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      tabIndex = 1;
                    });
                  },
                ),
                cardSpace,

                /// 기능 미구현으로 인한 숨김 처리
                InkWell(
                  child: Container(
                    height: 5.0.h,
                    width: 28.0.w,
                    alignment: Alignment.center,
                    decoration: tabIndex == 2 ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: mainColor,
                              width: 1.0,
                            )
                        )
                    ) : null,
                    child: Text(
                      "결재 수신함",
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
          Expanded(
            child:_page[tabIndex],
          )
        ],
      ),
    );
  }
}

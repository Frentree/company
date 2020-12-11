import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/screens/alarm/signBoxExpense.dart';
import 'package:MyCompany/screens/alarm/signBoxPurchase.dart';
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
  List<Widget> _page = [SignBoxExpense(),SignBoxPurchase()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 6.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                tabBtnWithUnderline(
                    context: context,
                    heightSize: 5.0,
                    widthSize: 20.0,
                    btnText: "경비 정산함",
                    tabIndexVariable: tabIndex,
                    tabOrder: 0,
                    tabAction: (){
                      setState(() {
                        tabIndex = 0;
                      });
                    }
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0.w),
                ),
                tabBtnWithUnderline(
                    context: context,
                    heightSize: 5,
                    widthSize: 20.0,
                    btnText: "결재 신청함",
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
          Padding(
            padding: EdgeInsets.only(top: 3.0.h),
          ),
          Expanded(
            child:_page[tabIndex],
          )
        ],
      ),
    );
  }
}

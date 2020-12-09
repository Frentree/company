import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/screens/alarm/signBoxExpense.dart';
import 'package:MyCompany/screens/alarm/signBoxPurchase.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:flutter/material.dart';

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
            height: customHeight(
                context: context,
                heightSize: 0.04
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                tabBtnWithUnderline(
                    context: context,
                    heightSize: 0.05,
                    widthSize: 0.2,
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
                  padding: EdgeInsets.only(right: 45),
                ),
                tabBtnWithUnderline(
                    context: context,
                    heightSize: 0.05,
                    widthSize: 0.2,
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
            padding: EdgeInsets.only(top: 15),
          ),
          Expanded(
            child:_page[tabIndex],
          )
        ],
      ),
    );
  }
}

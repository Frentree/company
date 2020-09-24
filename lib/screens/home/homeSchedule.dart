//Flutter
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeSchedulePage extends StatefulWidget {
  @override
  HomeSchedulePageState createState() => HomeSchedulePageState();
}

class HomeSchedulePageState extends State<HomeSchedulePage> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color: boarderColor,
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.02)),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: textFieldUnderLine
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: customWidth(context: context, widthSize: 0.1),
                  height: customHeight(context: context, heightSize: 0.05),
                  child: Text(
                    "내근",
                    style: customStyle(
                      fontSize: 14,
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: customWidth(context: context, widthSize: 0.03),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "09:00"
                    ),
                    Text(
                        "~"
                    ),
                    Text(
                        "12:00"
                    ),
                  ],
                ),
                SizedBox(
                  width: customWidth(context: context, widthSize: 0.04),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        "KB PIC 작업"
                    ),
                    Text(
                        ""
                    ),
                    Text(
                        "KB PIC 프로젝트"
                    ),
                  ],
                ),
                SizedBox(
                  width: customWidth(context: context, widthSize: 0.23),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: customWidth(context: context, widthSize: 0.15),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.more_horiz,
                          size: customHeight(context: context, heightSize: 0.05),
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.yellow,
                      width: customWidth(context: context, widthSize: 0.15),
                      child: Chip(
                        padding: EdgeInsets.zero,
                        label: Text(
                          "진행중"
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

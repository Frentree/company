//Flutter
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/widgets/card/workScheduleCard.dart';

class HomeSchedulePage extends StatefulWidget {
  @override
  HomeSchedulePageState createState() => HomeSchedulePageState();
}

class HomeSchedulePageState extends State<HomeSchedulePage> {
  int i = 0;

  List<String> _valuList = ["수정하기", "삭제하기", "이력보기"];
  String _selectedValue = "수정하기";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        /*Card(
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
                  width: customWidth(context: context, widthSize: 0.2),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: customHeight(context: context, heightSize: 0.03),
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,

                        icon: Icon(
                          Icons.more_horiz,
                          size: customHeight(context: context, heightSize: 0.044),
                        ),

                        initialValue: _selectedValue,
                        tooltip: "this is tooltip",
                        itemBuilder: (BuildContext context){
                          return _valuList.map((value){
                            return PopupMenuItem(
                              value: value,
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Chip(
                      padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.02)),
                      label: Text(
                        "진행중"
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )*/
       // workScheduleCard(context)
      ],
    );
  }
}

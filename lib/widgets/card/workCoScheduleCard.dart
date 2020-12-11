//Flutter
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';

import 'package:MyCompany/models/workModel.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Column childColumn({BuildContext context, List<dynamic> workData}) {
  Format _format = Format();
  List<Container> columnChildRow = [];

  workData.forEach((element) {
    var elementData = element.data();
    columnChildRow.add(
      Container(
        height: 6.0.h,
        alignment: Alignment.center,
        child: Row(
          children: [
            Text(
              _format.timeToString(elementData["startTime"]),
              style: customStyle(
                fontSize: 11.0.sp,
                fontWeightName: "Regular",
                fontColor: blueColor,
              ),
            ),
            SizedBox(
              width: 2.0.w,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: textFieldUnderLine),
                  borderRadius: BorderRadius.circular(2.0.w)),
              width: 15.0.w,
              height: 3.5.h,
              alignment: Alignment.center,
              child: Text(
                elementData["type"],
                style: customStyle(
                    fontSize: 10.0.sp,
                    fontWeightName: "Regular",
                    fontColor: fontColor),
              ),
            ),
            SizedBox(
              width: 2.0.w,
            ),
            Container(
              width: elementData["type"] == "외근"
                  ? 25.0.w
                  : 40.0.w,
              child: Text(
                elementData["title"],
                style: customStyle(
                  fontSize: cardTitleFontSize.sp,
                  fontWeightName: "Medium",
                  fontColor: mainColor,
                ),
              ),
            ),
            Visibility(
              visible: elementData["type"] == "외근",
              child: Container(
                width: 15.0.w,
                child: Text(
                    elementData["location"] == ""
                        ? ""
                        : "[${elementData["location"]}]",
                    style: customStyle(
                      fontSize: 11.0.sp,
                      fontWeightName: "Medium",
                      fontColor: mainColor,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  });

  Column childColumn = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: columnChildRow,
  );

  return childColumn;
}

Card workCoScheduleCard(
    {BuildContext context, String name, List<dynamic> workData}) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cardRadiusW.w),
      side: BorderSide(
        width: 1,
        color: boarderColor,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: cardPaddingW.w,
        vertical: cardPaddingH.h,
      ),
      child: Row(
        children: [
          Container(
            width: 12.0.w,
            child: Text(
              name,
              style: customStyle(
                fontSize: 11.0.sp,
                fontWeightName: "Regular",
              ),
            ),
          ),
          SizedBox(
            width: 2.0.w,
          ),
          workData.length == 0
              ? Container(
                  height: 6.0.h,
                  alignment: Alignment.center,
                  child: Text(
                    word.noSchedule(),
                    style: customStyle(
                      fontSize: cardTitleFontSize.sp,
                      fontWeightName: "Medium",
                      fontColor: mainColor,
                    ),
                  ),
                )
              : childColumn(
                  context: context,
                  workData: workData,
                ),
        ],
      ),
    ),
  );
}

//Flutter
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

import 'package:companyplaylist/models/workModel.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Column childColumn({BuildContext context, List<dynamic> workData}) {
  Format _format = Format();
  List<Padding> columnChildRow = [];

  workData.forEach((element) {
    columnChildRow.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              _format.timeToString(element.data["startTime"]),
              style: customStyle(
                fontSize: timeFontSize,
                fontWeightName: "Regular",
                fontColor: blueColor,
              ),
            ),
            SizedBox(
              width: customWidth(context: context, widthSize: widthDistance),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: textFieldUnderLine),
                  borderRadius: BorderRadius.circular(8)),
              width: customWidth(context: context, widthSize: 0.1),
              height: customHeight(context: context, heightSize: 0.03),
              alignment: Alignment.center,
              child: Text(
                element.data["type"],
                style: customStyle(
                    fontSize: typeFontSize,
                    fontWeightName: "Regular",
                    fontColor: fontColor),
              ),
            ),
            SizedBox(
              width: customWidth(context: context, widthSize: widthDistance),
            ),
            Container(
              width: element.data["type"] == "외근"
                  ? customWidth(context: context, widthSize: 0.3)
                  : customWidth(context: context, widthSize: 0.45),
              child: Text(
                element.data["title"],
                style: customStyle(
                  fontSize: titleFontSize,
                  fontWeightName: "Medium",
                  fontColor: mainColor,
                ),
              ),
            ),
            Visibility(
              visible: element.data["type"] == "외근",
              child: Container(
                width: customWidth(context: context, widthSize: 0.15),
                child: Text(
                    element.data["location"] == ""
                        ? ""
                        : "[${element.data["location"]}]",
                    style: customStyle(
                        fontSize: titleFontSize,
                        fontWeightName: "Medium",
                        fontColor: mainColor,)),
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
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        width: 1,
        color: boarderColor,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: customWidth(context: context, widthSize: 0.02),
        vertical: customHeight(context: context, heightSize: 0.01),
      ),
      child: Row(
        children: [
          Container(
            width: customWidth(context: context, widthSize: 0.18),
            child: Text(
              name,
              style: customStyle(
                fontSize: titleFontSize,
                fontWeightName: "Regular",
              ),
            ),
          ),
          SizedBox(
            width: customWidth(context: context, widthSize: widthDistance),
          ),
          workData.length == 0
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "일정이 없습니다.",
                    style: customStyle(
                        fontSize: titleFontSize,
                        fontWeightName: "Medium",
                        fontColor: mainColor,),
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

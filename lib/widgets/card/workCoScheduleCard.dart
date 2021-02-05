//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:sizer/sizer.dart';

final word = Words();

Column childColumn({BuildContext context, List<dynamic> workData}) {
  Format _format = Format();
  List<Container> columnChildRow = [];

  workData.forEach((element) {
    var elementData = element.data();
    columnChildRow.add(
      Container(
        height: scheduleCardDefaultSizeH.h,
        child: Row(
          children: [
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet ? 9.0.w : 12.0.w,
              child: Text(
                _format.timeToString(elementData["startTime"]),
                style: cardBlueStyle,
              ),
            ),
            Container(
              height: 4.0.h,
              width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
              decoration: containerChipDecoration,
              padding: EdgeInsets.symmetric(
                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
              ),
              alignment: Alignment.center,
              child: Text(
                elementData["type"],
                style: containerChipStyle,
              ),
            ),
            cardSpace,
            Container(
              width: elementData["type"] == "외근" ? SizerUtil.deviceType == DeviceType.Tablet ? 34.0.w : 18.0.w : SizerUtil.deviceType == DeviceType.Tablet ? 49.5.w : 33.0.w,
              child: Text(
                elementData["title"],
                style: cardTitleStyle,
              ),
            ),
            Visibility(
              visible: elementData["type"] == "외근",
              child: Container(
                width: SizerUtil.deviceType == DeviceType.Tablet ? 15.5.w : 15.0.w,
                child: Text(
                  elementData["location"] == "" ? "" : "[${elementData["location"]}]",
                  style: cardTitleStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  });

  Column childColumn = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: columnChildRow,
  );

  return childColumn;
}

Card workCoScheduleCard({BuildContext context, String name, List<dynamic> workData}) {
  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
      padding: cardPadding,
      child: Row(
        children: [
          Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 9.0.w : 12.0.w,
            child: Text(
              name,
              style: cardTitleStyle,
            ),
          ),
          Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
          ),
          workData.length == 0 ? Container(
            height: scheduleCardDefaultSizeH.h,
            alignment: Alignment.center,
            child: Text(
              word.noSchedule(),
              style: cardTitleStyle,
            ),
          ) : childColumn(
            context: context,
            workData: workData,
          ),
        ],
      ),
    ),
  );
}

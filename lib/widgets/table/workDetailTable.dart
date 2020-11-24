//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/widgets/bottomsheet/schedule/coScheduleDetail.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';

//Flutter
import 'package:flutter/material.dart';

//Model
import 'package:companyplaylist/models/workModel.dart';

//Util
import 'package:companyplaylist/utils/date/dateFormat.dart';

import '../../models/workModel.dart';

const double heightSize = 0.08;
const double sizedBoxHeight = 0.01;
const double workChipHeightSize = 0.025;

List<Map<int, List<dynamic>>> dataFetch(List<dynamic> companyWork) {
  Format _format = Format();

  List<Map<int, List<dynamic>>> companyWorkList = List(5);
  List<int> key = [1, 2]; //1 : 오전, 2 : 오후
  for (int i = 0; i < 5; i++) {
    Map<int, List<dynamic>> timeMap = Map();

    key.forEach((element) {
      timeMap[element] = [];
    });

    companyWork.forEach((element) {
      if (element.data["type"] != "내근") {
        int week =
            _format.timeStampToDateTime(element.data["startDate"]).weekday;
        if ((week - 1) == i) {
          timeMap[element.data["timeSlot"]].add(element);
        }
      }
    });
    companyWorkList[i] = timeMap;
  }
  return companyWorkList;
}

List<List<dynamic>> scheduleDataFetch(List<dynamic> companyWork) {
  Format _format = Format();
  List<List<dynamic>> scheduleData = [];
  for(int i = 0; i < 5; i++){
    scheduleData.add([]);
  }
  companyWork.forEach((element) {
    int week = _format.timeStampToDateTime(element.data["startDate"]).weekday;
    scheduleData[week-1].add(element);
  });

  return scheduleData;
}

TableRow workDetailTableRow(
    {BuildContext context, List<dynamic> companyWork, String name, String loginUserMail}) {
  List<Map<int, List<dynamic>>> companyWorkList = dataFetch(companyWork);
  List<Container> tableRow = List();
  List<List<dynamic>> scheduleData = scheduleDataFetch(companyWork);

  companyWorkList.forEach((element) {
    tableRow.add(Container(
      height: customHeight(context: context, heightSize: heightSize),
      padding: EdgeInsets.symmetric(
          horizontal: customWidth(context: context, widthSize: 0.01)),
      child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              element[1].length == 0
                  ? emptyChip(context: context)
                  : workChip(
                      context: context,
                      companyWork: element[1][0],
                      count: element[1].length),
              element[2].length == 0
                  ? emptyChip(context: context)
                  : workChip(
                      context: context,
                      companyWork: element[2][0],
                      count: element[2].length),
            ],
          ),
          onTap: (element[1].length != 0 || element[2].length != 0)
              ? () {
                  coScheduleDetail(
                    context: context,
                    name: name,
                    loginUserMail: loginUserMail,
                    scheduleData: scheduleData[companyWorkList.indexOf(element)],
                  );
                }
              : null),
    ));
  });

  tableRow.add(Container(
    height: customHeight(context: context, heightSize: heightSize),
    padding: EdgeInsets.symmetric(
        horizontal: customWidth(context: context, widthSize: 0.01)),
    child: Center(
      child: Text(name),
    ),
  ));

  return TableRow(children: tableRow);
}

//일정 칩
Container workChip({BuildContext context, dynamic companyWork, int count}) {
  return Container(
    child: Row(
      children: [
        Container(
          height:
              customHeight(context: context, heightSize: workChipHeightSize),
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(8),
              color: companyWork.data["type"] == "미팅"
                  ? blueColor
                  : companyWork.data["type"] == "외근"
                      ? workTypeOut
                      : workTypeRest),
          child: Center(
            child: Text(
              companyWork.data["type"],
              style: customStyle(
                  fontColor: whiteColor,
                  fontWeightName: "Regular",
                  fontSize: 10),
            ),
          ),
        ),
        (count - 1) != 0
            ? Text(
                "+${count - 1}",
                style: TextStyle(fontSize: 11),
              )
            : Text("")
      ],
    ),
  );
}

//빈칩
Container emptyChip({BuildContext context}) {
  return Container(
    height: customHeight(context: context, heightSize: workChipHeightSize),
  );
}

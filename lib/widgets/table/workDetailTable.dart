//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/widgets/bottomsheet/schedule/coScheduleDetail.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';

//Flutter
import 'package:flutter/material.dart';

//Model
import 'package:MyCompany/models/workModel.dart';

//Util
import 'package:MyCompany/utils/date/dateFormat.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

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
      var elementData = element.data();
      if (elementData["type"] != "내근") {
        int week =
            _format.timeStampToDateTime(elementData["startDate"]).weekday;
        if ((week - 1) == i) {
          timeMap[elementData["timeSlot"]].add(element);
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
  for (int i = 0; i < 5; i++) {
    scheduleData.add([]);
  }
  companyWork.forEach((element) {
    var elementData = element.data();
    int week = _format.timeStampToDateTime(elementData["startDate"]).weekday;
    scheduleData[week - 1].add(element);
  });

  return scheduleData;
}

TableRow workDetailTableRow(
    {BuildContext context,
    List<dynamic> companyWork,
    String name,
    String loginUserMail}) {
  List<Map<int, List<dynamic>>> companyWorkList = dataFetch(companyWork);
  List<Container> tableRow = List();
  List<List<dynamic>> scheduleData = scheduleDataFetch(companyWork);

  companyWorkList.forEach((element) {
    tableRow.add(Container(
      height: 10.0.h,
      padding: EdgeInsets.symmetric(horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w),
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
                    scheduleData:
                        scheduleData[companyWorkList.indexOf(element)],
                  );
                }
              : null),
    ));
  });

  tableRow.add(Container(
    height: 10.0.h,
    padding: EdgeInsets.symmetric(horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w),
    child: Center(
      child: Text(
        name,
        style: defaultMediumStyle,
      ),
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
          height: 3.0.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: companyWork.data()["type"] == "미팅"
                  ? blueColor
                  : companyWork.data()["type"] == "외근"
                      ? workTypeOut
                      : workTypeRest),
          child: Text(
            companyWork.data()["type"],
            style: customStyle(
                fontColor: whiteColor,
                fontWeightName: "Regular",
                fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 6.75.sp : 9.0.sp),
          ),
        ),
        (count - 1) != 0
            ? Text(
                "+${count - 1}",
                style: customStyle(
                  fontColor: mainColor,
                  fontWeightName: "Regular",
                  fontSize: 7.0.sp,
                ),
              )
            : Text("")
      ],
    ),
  );
}

//빈칩
Container emptyChip({BuildContext context}) {
  return Container(
      height: 3.0.h,
  );
}

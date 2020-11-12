//Flutter
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

List<Column> columnChild(
    {BuildContext context, List<CompanyWork> companyWorkList}) {
  List<Column> columnChild = [];

  companyWorkList.forEach((element) {
    columnChild.add(Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                element.timeTest,
                style: customStyle(
                    fontSize: timeFontSize,
                    fontWeightName: "Regular",
                    fontColor: blueColor),
              ),
              SizedBox(
                width: customWidth(context: context, widthSize: widthDistance),
              ),

              //업무 타입입
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: textFieldUnderLine),
                    borderRadius: BorderRadius.circular(8)),
                width: customWidth(context: context, widthSize: 0.1),
                height: customHeight(context: context, heightSize: 0.03),
                alignment: Alignment.center,
                child: Text(
                  element.type,
                  style: customStyle(
                      fontSize: typeFontSize,
                      fontWeightName: "Regular",
                      fontColor: fontColor),
                ),
              ),
              SizedBox(
                width: customWidth(context: context, widthSize: 0.02),
              ),

              //제목
              Container(
                width: element.type == "외근" ? customWidth(context: context, widthSize: 0.4) : customWidth(context: context, widthSize: 0.55),
                child: Text(
                  element.workTitle,
                  //textAlign: ,
                  style: customStyle(
                      fontSize: titleFontSize,
                      fontWeightName: "Medium",
                      fontColor: mainColor,
                      height: 1),
                ),
              ),
              element.type == "외근" ? Container(
                width: customWidth(context: context, widthSize: 0.15),
                child: Text(
                  element.location == null ? "" : "[${element.location}]",
                  style: customStyle(
                      fontSize: titleFontSize,
                      fontWeightName: "Medium",
                      fontColor: mainColor,
                      height: 1),
                ),
              ) : Container()
            ],
          ),
        )
      ],
    ));
  });

  return columnChild;
}

Widget workCoScheduleCard(
    {BuildContext context,
    String key,
    String name,
    Map<String, List<CompanyWork>> companyWork}) {
  return companyWork[key].length == 0 ? Container() : Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1,
          color: boarderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(name),
            Column(
              children: columnChild(context: context, companyWorkList: companyWork[key])
            )
          ],
        ),
      ));
}

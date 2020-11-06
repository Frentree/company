//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Flutter
import 'package:flutter/material.dart';

//Model
import 'package:companyplaylist/models/workModel.dart';

//Util
import 'package:companyplaylist/utils/date/dateFormat.dart';

const double heightSize = 0.08;
const double sizedBoxHeight = 0.01;
const double workChipHeightSize = 0.025;

List<Map<String, List<CompanyWork>>> dataFetch(List<CompanyWork> companyWork){
  Format _format = Format();

  List<Map<String, List<CompanyWork>>> companyWorkList = List(5);
  List<String> key = ["오전", "종일", "오후"];
  for(int i = 0; i < 5; i++){
    Map<String, List<CompanyWork>> timeMap = Map();

    key.forEach((element) {
      timeMap[element] = [];
    });
    companyWork.forEach((element) {
      int week = _format.timeStampToDateTime(element.startDate).weekday;
      if((week -1) == i){
        timeMap[element.timeTest].add(element);
      }
    });
    companyWorkList[i] = timeMap;
  }
  return companyWorkList;
}

TableRow workDetailTableRow({BuildContext context, List<CompanyWork> companyWork, String name}){

  List<Map<String, List<CompanyWork>>> companyWorkList = dataFetch(companyWork);
  List<Container> tableRow = List();

  companyWorkList.forEach((element) {
    tableRow.add(Container(
      height: customHeight(context: context, heightSize: heightSize),
      padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.01)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          element["오전"].length == 0 ? emptyChip(context: context) : workChip(context: context, companyWork: element["오전"][0], count: element["오전"].length),
          //element["종일"].length == 0 ? emptyChip(context: context) : workChip(context: context, companyWork: element["종일"][0], count: element["종일"].length),
          element["오후"].length == 0 ? emptyChip(context: context) : workChip(context: context, companyWork: element["오후"][0], count: element["오후"].length),
        ],
      ),
    ));
  });

  tableRow.add(Container(
    height: customHeight(context: context, heightSize: heightSize),
    padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.01)),
    child: Center(
      child: Text(name),
    ),
  ));

  return TableRow(
      children: tableRow
  );
}

//일정 칩
Container workChip({BuildContext context, CompanyWork companyWork, int count}){
  return Container(
    child: Row(
      children: [
        Container(
          height: customHeight(context: context, heightSize: workChipHeightSize),
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(8),
              color: companyWork.type == "미팅" ? blueColor : companyWork.type == "외근" ? workTypeOut : companyWork.type == "생일" ? workTypeBirthDay : workTypeRest
          ),
          child: GestureDetector(
            child: Center(
              child: Text(
                companyWork.type,
                style: customStyle(
                    fontColor: whiteColor,
                    fontWeightName: "Regular",
                    fontSize: 10
                ),
              ),
            ),
          ),
        ),
        (count-1) != 0 ? Text(
            "+${count-1}",
          style: TextStyle(
            fontSize: 11
          ),

        ) : Text("")
      ],
    ),
  );
}

//빈칩
Container emptyChip({BuildContext context}){
  return Container(
    height: customHeight(context: context, heightSize: workChipHeightSize),
    child: GestureDetector(

    ),
  );
}
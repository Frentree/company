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

const double heightSize = 0.1;
const double sizedBoxHeight = 0.01;
const double workChipHeightSize = 0.03;

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

TableRow workDetailTableRow({BuildContext context, List<CompanyWork> companyWork}){
  List<Map<String, List<CompanyWork>>> companyWorkList = dataFetch(companyWork);
  List<Container> tableRow = List();

  companyWorkList.forEach((element) {
    List<int> workCount = List();
    element.forEach((key, value) {
      workCount.add(element[key].length);
    });
    if(workCount.every((element) => element==0)){
      tableRow.add(emptyCell());
    }
    else{
      tableRow.add(Cell(
        context: context,
        companyWorkMap: element,
        workCount: workCount
      ));
    }
  });

  return TableRow(
    children: tableRow
  );
}

//빈 cell
Container emptyCell({BuildContext context}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        child: GestureDetector(
          onTap: (){},
        ),
      ),
    ),
  );
}

//오전 일정만 있는 cell
Container Cell({BuildContext context, Map<String ,List<CompanyWork>> companyWorkMap, List<int> workCount}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          workCount[0] != 0 ? workChip(
            context: context,
            companyWork: companyWorkMap["오전"][0],
            count: workCount[0]
          ) : emptyChip(context: context),
          workCount[1] != 0 ? workChip(
              context: context,
              companyWork: companyWorkMap["종일"][0],
              count: workCount[1]
          ) : emptyChip(context: context),
          workCount[2] != 0 ? workChip(
              context: context,
              companyWork: companyWorkMap["오후"][0],
              count: workCount[2]
          ) : emptyChip(context: context),
        ],
      )
    ),
  );
}

//오후 일정만 있는 cell
Container onlyAfternoonCell({BuildContext context, CompanyWork companyWork}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            emptyChip(context: context),
            SizedBox(height: customHeight(context: context, heightSize: sizedBoxHeight)),
            workChip(
                context: context,
                companyWork: companyWork
            ),
          ],
        )
    ),
  );
}

//오전오후 일정 Cell
Container twoScheduleCell({BuildContext context, CompanyWork companyWork}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            workChip(
                context: context,
                companyWork: companyWork
            ),
            SizedBox(height: customHeight(context: context, heightSize: sizedBoxHeight)),
            workChip(
                context: context,
                companyWork: companyWork
            ),
          ],
        )
    ),
  );
}

//종일 일정 Cell
Container allDayCell({BuildContext context, CompanyWork companyWork}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: workChip(
            context: context,
            companyWork: companyWork
          ),
        )
    ),
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
            borderRadius: BorderRadius.circular(8),
            color: companyWork.type == "미팅" ? blueColor : companyWork.type == "외근" ? workTypeOut : companyWork.type == "생일" ? workTypeBirthDay : workTypeRest
          ),
          child: GestureDetector(
            child: Center(
              child: Text(
                companyWork.type,
                style: customStyle(
                  fontColor: whiteColor,
                  fontWeightName: "Regular",
                  fontSize: 12
                ),
              ),
            ),
          ),
        ),
        count != 0 ? Text(
          "+$count"
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





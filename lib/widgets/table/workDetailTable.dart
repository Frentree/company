//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/repos/tableCalendar/table_calendar.dart';

//Model
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/models/userModel.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Util
import 'package:companyplaylist/utils/date/dateFormat.dart';

//Widget
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/card/workCoScheduleCard.dart';

const double heightSize = 0.1;
const double sizedBoxHeight = 0.01;
const double workChipHeightSize = 0.03;


TableRow workDetailTableRow({BuildContext context, List<CompanyWork> companyWorkList}){
  companyWorkList.forEach((element) {

  });


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
Container onlyMorningCell({BuildContext context, List<CompanyWork> companyWorkList}){
  return Container(
    height: customHeight(context: context, heightSize: heightSize),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          workChip(
            context: context,
            //companyWork: companyWork
          ),
          SizedBox(height: customHeight(context: context, heightSize: sizedBoxHeight)),
          emptyChip(context: context)
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
Container workChip({BuildContext context, CompanyWork companyWork}){
  return Container(
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





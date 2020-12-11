//Flutter
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';

import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

const widthDistance = 0.02; // 항목별 간격
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Card workScheduleCard(
    {BuildContext context,
    String companyCode,
    WorkModel workModel,
    bool isDetail}) {
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
            vertical: cardPaddingH.h,),
        child: isDetail
            ? workDetailContents(
                context: context,
                companyCode: companyCode,
                workModel: workModel,
                isDetail: isDetail,
              )
            : titleCard(
                context: context,
                companyCode: companyCode,
                workModel: workModel,
                isDetail: isDetail,
              )),
  );
}

Container titleCard(
    {BuildContext context,
    String companyCode,
    WorkModel workModel,
    bool isDetail}) {
  Format _format = Format();

  return Container(
    height: 6.0.h,
    child: Row(
      children: [
        //시간대
        Text(
          _format.timeToString(workModel.startTime),
          style: customStyle(
              fontSize: 11.0.sp,
              fontWeightName: "Regular",
              fontColor: blueColor),
        ),
        SizedBox(
          width: 2.0.w,
        ),

        //업무 타입입
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: textFieldUnderLine),
              borderRadius: BorderRadius.circular(2.0.w)),
          width: 15.0.w,
          height: 3.5.h,
          alignment: Alignment.center,
          child: Text(
            workModel.type == "내근" ? word.workIn() : word.workOut(),
            style: customStyle(
                fontSize: 10.0.sp,
                fontWeightName: "Regular",
                fontColor: fontColor),
          ),
        ),
        SizedBox(
          width: 2.0.w,
        ),

        //제목
        Container(
          width: workModel.type == "외근"
              ? 30.0.w
              : 45.0.w,
          child: Text(
            workModel.title,
            style: customStyle(
                fontSize: cardTitleFontSize.sp,
                fontWeightName: "Medium",
                fontColor: mainColor,),
          ),
        ),
        Visibility(
          visible: workModel.type == "외근",
          child: Container(
            width: 15.0.w,
            child: Text(
                workModel.location == "" ? "" : "[${workModel.location}]",
                style: customStyle(
                    fontSize: 11.0.sp,
                    fontWeightName: "Medium",
                    fontColor: mainColor,)),
          ),
        ),
        SizedBox(
          width: 2.0.w,
        ),

        //popup 버튼
        isDetail
            ? popupMenu(
                context: context,
                workModel: workModel,
                companyCode: companyCode,
              )
            : Container(),
      ],
    ),
  );
}

Column workDetailContents(
    {BuildContext context,
    String companyCode,
    WorkModel workModel,
    bool isDetail}) {
  Format _format = Format();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleCard(
          context: context,
          companyCode: companyCode,
          workModel: workModel,
          isDetail: isDetail),
      SizedBox(
        height: 1.0.h,
      ),
      Padding(
        padding: EdgeInsets.only(
            left: 13.0.w
        ),
        child: Text(workModel.contents, style: customStyle(fontSize: 12.0.sp),),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            workModel.createDate == workModel.lastModDate
                ? "작성시간 : "
                : "수정시간 : ",
            style: customStyle(
                fontSize: 12.0.sp,
                fontWeightName: "Regular",
                fontColor: grayColor),
          ),
          Text(
            _format.dateToString(
                _format.timeStampToDateTime(workModel.lastModDate)),
            style: customStyle(
                fontSize: 12.0.sp,
                fontWeightName: "Regular",
                fontColor: grayColor),
          )
        ],
      )
    ],
  );
}

Container popupMenu(
    {BuildContext context, WorkModel workModel, String companyCode}) {
  FirebaseRepository _repository = FirebaseRepository();
  return Container(
    width: 5.0.w,
    child: PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_horiz,
        size: iconSizeW.w,
      ),
      onSelected: (value) async {
        if (value == 1) {
          workContent(
            context: context,
            workModel: workModel,
            type: workModel.type == "내근" ? 1 : 2,
          );
        } else {
          await _repository.deleteWork(
            documentID: workModel.id,
            companyCode: companyCode,
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [Icon(Icons.edit, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text("수정하기", style: customStyle(fontSize: 13.0.sp),)],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [Icon(Icons.delete, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text("삭제하기", style: customStyle(fontSize: 13.0.sp),)],
          ),
        ),
      ],
    ),
  );
}

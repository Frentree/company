//Flutter
import 'package:companyplaylist/widgets/bottomsheet/work/workContent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
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
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        width: 1,
        color: boarderColor,
      ),
    ),
    child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: customWidth(context: context, widthSize: 0.02),
            vertical: customHeight(context: context, heightSize: 0.01)),
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
    height: customHeight(context: context, heightSize: 0.06),
    child: Row(
      children: [
        //시간대
        Text(
          _format.timeToString(workModel.startTime),
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
            workModel.type,
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
          width: workModel.type == "외근"
              ? customWidth(context: context, widthSize: 0.4)
              : customWidth(context: context, widthSize: 0.55),
          child: Text(
            workModel.title,
            style: customStyle(
                fontSize: titleFontSize,
                fontWeightName: "Medium",
                fontColor: mainColor,),
          ),
        ),
        Visibility(
          visible: workModel.type == "외근",
          child: Container(
            width: customWidth(context: context, widthSize: 0.15),
            child: Text(
                workModel.location == "" ? "" : "[${workModel.location}]",
                style: customStyle(
                    fontSize: titleFontSize,
                    fontWeightName: "Medium",
                    fontColor: mainColor,)),
          ),
        ),
        SizedBox(
          width: customWidth(context: context, widthSize: 0.01),
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
        height: customHeight(context: context, heightSize: 0.01),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: customWidth(context: context, widthSize: 0.13)),
        child: Text(workModel.contents),
      ),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            workModel.createDate == workModel.lastModDate
                ? "작성시간 : "
                : "수정시간 : ",
            style: customStyle(
                fontSize: writeTimeFontSize,
                fontWeightName: "Regular",
                fontColor: grayColor),
          ),
          Text(
            _format.dateToString(
                _format.timeStampToDateTime(workModel.lastModDate)),
            style: customStyle(
                fontSize: writeTimeFontSize,
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
    width: customWidth(context: context, widthSize: 0.05),
    child: PopupMenuButton(
      icon: Icon(
        Icons.more_horiz,
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
            children: [Icon(Icons.edit), Text("수정하기")],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [Icon(Icons.delete), Text("삭제하기")],
          ),
        ),
      ],
    ),
  );
}

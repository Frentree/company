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
const titleFontSize = 20.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Card workScheduleCard({BuildContext context, String documentId, String companyCode, CompanyWork companyWork, bool isDetail}){
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
      padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.02), vertical: customHeight(context: context, heightSize: 0.01)),
      child: isDetail ? detailContents(
          context: context,
          documentId: documentId,
          companyCode: companyCode,
          companyWork: companyWork,
          isDetail: isDetail,
      ) : titleContents(
        context: context,
        documentId: documentId,
        companyCode: companyCode,
        companyWork: companyWork,
        isDetail: isDetail,
      )
    ),
  );
}

Row titleContents({BuildContext context, String documentId, String companyCode, CompanyWork companyWork, bool isDetail}){
  return Row(
    children: [
      //시간대
      Text(
        companyWork.timeTest,
        style: customStyle(
            fontSize: timeFontSize,
            fontWeightName: "Regular",
            fontColor: fontColor
        ),
      ),
      SizedBox(
        width: customWidth(context: context, widthSize: widthDistance),
      ),

      //업무 타입입
      Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: textFieldUnderLine
            ),
            borderRadius: BorderRadius.circular(8)
        ),
        width: customWidth(context: context, widthSize: 0.1),
        height: customHeight(context: context, heightSize: 0.03),
        alignment: Alignment.center,
        child: Text(
          companyWork.type,
          style: customStyle(
              fontSize: typeFontSize,
              fontWeightName: "Regular",
              fontColor: fontColor
          ),
        ),
      ),
      SizedBox(
        width: customWidth(context: context, widthSize: 0.02),
      ),

      //제목
      Container(
        width: customWidth(context: context, widthSize: 0.6),
        child: Text(
          companyWork.workTitle,
          //textAlign: ,
          style: customStyle(
            fontSize: titleFontSize,
            fontWeightName: "Medium",
            fontColor: mainColor,
            height: 1
          ),
        ),
      ),
      SizedBox(
        width: customWidth(context: context, widthSize: 0.02),
      ),
      
      //popup 버튼
      isDetail ? popupMenu(
        context: context,
        documentId: documentId,
        companyCode: companyCode,
      ) : Container(),
    ],
  );
}

Column detailContents({BuildContext context, String documentId, String companyCode, CompanyWork companyWork, bool isDetail}){
  Format _format = Format();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleContents(
        context: context,
        documentId: documentId,
        companyCode: companyCode,
        companyWork: companyWork,
        isDetail: isDetail
      ),

      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),
      Padding(
        padding: EdgeInsets.only(left: customWidth(context: context, widthSize: 0.13)),
        child: Text(
          companyWork.workContents
        ),
      ),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /*Container(
            //color: Colors.yellow,
            height: customHeight(context: context, heightSize: 0.05),
            width: customWidth(context: context, widthSize: 0.8),
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: share.length,
              itemBuilder: (BuildContext context, int index){
                return Chip(
                  label: Text(
                    share[index],
                    style: customStyle(
                      fontSize: 14,
                      fontWeightName: "Regular"
                    ),
                  ),
                );
              },
            ),
          ),*/
        ],
      ),

      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "작성시간 : ",
            style: customStyle(
              fontSize: writeTimeFontSize,
              fontWeightName: "Regular",
              fontColor: greyColor
            ),
          ),
          Text(
            _format.timeStampToDateTime(companyWork.createDate).toString().substring(0, 16),
            style: customStyle(
              fontSize: writeTimeFontSize,
              fontWeightName: "Regular",
              fontColor: greyColor
            ),
          )
        ],
      )
    ],
  );
}

Container popupMenu({BuildContext context, String documentId, String companyCode}){
  CrudRepository _crudRepository = CrudRepository.companyWork(companyCode: companyCode);
  return Container(
    width: customWidth(context: context, widthSize: 0.05),
    child: PopupMenuButton(
      icon: Icon(
        Icons.more_horiz,
      ),
      onSelected: (value) async {
        if(value == 1) {
          print("수정하기");
        }
        else{
          await _crudRepository.removeCompanyWorkDataToFirebase(documentId: documentId);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                  Icons.edit
              ),
              Text(
                  "수정하기"
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                  Icons.delete
              ),
              Text(
                  "삭제하기"
              )
            ],
          ),
        ),
      ],
    ),
  );
}


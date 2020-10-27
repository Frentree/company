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


Card workCoScheduleCard({BuildContext context, String documentId, String companyCode, CompanyWork companyWork, bool isDetail}){
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

Column titleContents({BuildContext context, String documentId, String companyCode, CompanyWork companyWork, bool isDetail}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      isDetail ? popupMenu(
          context: context,
          documentId: documentId,
          companyCode: companyCode
      ) : Container(),
      Row(
        children: [
          Container(
            width: customWidth(context: context, widthSize: 0.1),
            child: Center(
              child: Text(
                companyWork.name,
                style: customStyle(
                  fontSize: 13,
                  fontColor: mainColor,
                  fontWeightName: "Regular"
                ),
              ),
            ),
          ),
          SizedBox(
            width: customWidth(context: context, widthSize: 0.03),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: textFieldUnderLine
                    ),
                    borderRadius: BorderRadius.circular(12)
                ),
                width: customWidth(context: context, widthSize: 0.08),
                height: customHeight(context: context, heightSize: 0.04),
                alignment: Alignment.center,
                child: Text(
                  companyWork.type,
                  style: customStyle(
                      fontSize: 12,
                      fontWeightName: "Regular",
                      fontColor: mainColor
                  ),
                ),
              ),
              Text(
                companyWork.timeTest,
                style: customStyle(
                    fontSize: 13,
                    fontWeightName: "Regular",
                    fontColor: mainColor
                ),
              ),
            ],
          ),

          SizedBox(
            width: customWidth(context: context, widthSize: 0.03),
          ),
          Container(
            width: customWidth(context: context, widthSize: 0.5),
            child: Text(
              companyWork.workTitle,
              style: customStyle(
                  fontSize: 16,
                  fontWeightName: "Medium",
                  fontColor: mainColor
              ),
            ),
          ),
          SizedBox(
            width: customWidth(context: context, widthSize: 0.01),
          ),
          progressPopupMenu(
              context: context,
              documentId: documentId,
              companyCode: companyCode,
              companyWork: companyWork
          )
        ],
      ),
    ],
  );
}

Container popupMenu({BuildContext context, String documentId, String companyCode}){
  CrudRepository _crudRepository = CrudRepository.companyWork(companyCode: companyCode);

  return Container(
    height: 15,
    child: PopupMenuButton(
      padding: EdgeInsets.only(right: customWidth(context: context, widthSize: 0.04)),
      icon: Icon(
          Icons.more_horiz
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

PopupMenuButton progressPopupMenu({BuildContext context, String documentId, String companyCode, CompanyWork companyWork}){
  CrudRepository _crudRepository = CrudRepository.companyWork(companyCode: companyCode);

  return PopupMenuButton(
    padding: EdgeInsets.only(right: customWidth(context: context, widthSize: 0.04)),
    child: Container(
      width: customWidth(context: context, widthSize: 0.15),
      height: customHeight(context: context, heightSize: 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: companyWork.progress == 1 ? progressComplete : companyWork.progress == 2 ? blueColor : companyWork.progress == 3 ? progressBefore : progressHold
      ),
      child: Center(
        child: Text(
          companyWork.progress == 1 ? "완료" : companyWork.progress == 2 ? "진행중" : companyWork.progress == 3 ? "진행전" : "보류",
          style: customStyle(
              fontSize: 13,
              fontWeightName: "Regular",
              fontColor: whiteColor
          ),
        ),
      ),
    ),
    onSelected: (value) async {
      companyWork.progress = value;
      await _crudRepository.updateCompanyWorkDataToFirebase(documentId: documentId, dataModel: companyWork);
      Fluttertoast.showToast(
          msg: "진행상태가 변경되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity:  ToastGravity.BOTTOM,
          backgroundColor: blackColor
      );
    },
    itemBuilder: (BuildContext context) => [
      PopupMenuItem(
        child: Center(
          child: Text(
            "진행상태 수정",
            style: customStyle(
                fontColor: blackColor
            ),
          ),
        ),
        enabled: false,
      ),
      PopupMenuItem(
        value: 1,
        child: Center(
          child: Container(
            width: customWidth(context: context, widthSize: 0.15),
            height: customHeight(context: context, heightSize: 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: progressComplete
            ),
            child: Center(
              child: Text(
                "완료",
                style: customStyle(
                    fontSize: 13,
                    fontWeightName: "Regular",
                    fontColor: whiteColor
                ),
              ),
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Center(
          child: Container(
            width: customWidth(context: context, widthSize: 0.15),
            height: customHeight(context: context, heightSize: 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: blueColor
            ),
            child: Center(
              child: Text(
                "진행중",
                style: customStyle(
                    fontSize: 13,
                    fontWeightName: "Regular",
                    fontColor: whiteColor
                ),
              ),
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: 3,
        child: Center(
          child: Container(
            width: customWidth(context: context, widthSize: 0.15),
            height: customHeight(context: context, heightSize: 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: progressBefore
            ),
            child: Center(
              child: Text(
                "진행전",
                style: customStyle(
                    fontSize: 13,
                    fontWeightName: "Regular",
                    fontColor: whiteColor
                ),
              ),
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: 4,
        child: Center(
          child: Container(
            width: customWidth(context: context, widthSize: 0.15),
            height: customHeight(context: context, heightSize: 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: progressHold
            ),
            child: Center(
              child: Text(
                "보류",
                style: customStyle(
                    fontSize: 13,
                    fontWeightName: "Regular",
                    fontColor: whiteColor
                ),
              ),
            ),
          ),
        ),
      ),
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
        padding: EdgeInsets.only(left: customWidth(context: context, widthSize: 0.15)),
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
                fontSize: 14,
                fontWeightName: "Regular",
                fontColor: greyColor
            ),
          ),
          Text(
            _format.timeStampToDateTime(companyWork.createDate).toString(),
            style: customStyle(
                fontSize: 14,
                fontWeightName: "Regular",
                fontColor: greyColor
            ),
          )
        ],
      )
    ],
  );
}

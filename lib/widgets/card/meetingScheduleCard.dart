//Flutter
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/widgets/bottomsheet/meeting/meetingMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Card meetingScheduleCard({BuildContext context, String loginUserMail, String companyCode, MeetingModel meetingModel, bool isDetail}) {
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
            ? detailContents(
          context: context,
          loginUserMail: loginUserMail,
          companyCode: companyCode,
          meetingModel: meetingModel,
          isDetail: isDetail,
        )
            : titleCard(
          context: context,
          loginUserMail: loginUserMail,
          companyCode: companyCode,
          meetingModel: meetingModel,
          isDetail: isDetail,
        )),
  );
}

Container titleCard({BuildContext context, String loginUserMail, String companyCode, MeetingModel meetingModel, bool isDetail}) {
  Format _format = Format();

  return Container(
    height: customHeight(
        context: context,
        heightSize: 0.06
    ),
    child: Row(
      children: [
        //시간대
        Text(
          _format.timeToString(meetingModel.startTime),
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
            meetingModel.type,
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
          width: customWidth(context: context, widthSize: 0.6),
          child: Text(
            meetingModel.title,
            style: customStyle(
                fontSize: titleFontSize,
                fontWeightName: "Medium",
                fontColor: mainColor,
                height: 1),
          ),
        ),
        SizedBox(
          width: customWidth(context: context, widthSize: 0.02),
        ),

        //popup 버튼
        meetingModel.createUid == loginUserMail ? isDetail ? popupMenu(
          context: context,
          meetingModel: meetingModel,
          companyCode: companyCode,
        ) : Container() : Container()
      ],
    ),
  );
}

Column detailContents(
    {BuildContext context,
      String loginUserMail,
      String companyCode,
      MeetingModel meetingModel,
      bool isDetail}) {
  Format _format = Format();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleCard(
          context: context,
          companyCode: companyCode,
          loginUserMail: loginUserMail,
          meetingModel: meetingModel,
          isDetail: isDetail),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            meetingModel.createDate == meetingModel.lastModDate ? "작성시간 : " : "수정시간 : ",
            style: customStyle(
                fontSize: writeTimeFontSize,
                fontWeightName: "Regular",
                fontColor: greyColor),
          ),
          Text(
            _format.dateToString(_format.timeStampToDateTime(meetingModel.lastModDate)),
            style: customStyle(
                fontSize: writeTimeFontSize,
                fontWeightName: "Regular",
                fontColor: greyColor),
          )
        ],
      ),

      Visibility(
        visible: meetingModel.createUid != loginUserMail,
        child: SizedBox(
          height: customHeight(context: context, heightSize: 0.01),
        ),
      ),

      Visibility(
        visible: meetingModel.createUid != loginUserMail,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "작성자 : ",
              style: customStyle(
                  fontSize: writeTimeFontSize,
                  fontWeightName: "Regular",
                  fontColor: greyColor),
            ),
            Text(
              meetingModel.name,
              style: customStyle(
                  fontSize: writeTimeFontSize,
                  fontWeightName: "Regular",
                  fontColor: greyColor),
            )
          ],
        ),
      )
    ],
  );
}

Container popupMenu(
    {BuildContext context, MeetingModel meetingModel, String companyCode}) {
  FirebaseRepository _repository = FirebaseRepository();
  return Container(
    width: customWidth(context: context, widthSize: 0.05),
    child: PopupMenuButton(
      icon: Icon(
        Icons.more_horiz,
      ),
      onSelected: (value) async {
        if (value == 1) {
          meetingMain(
            context: context,
            meetingModel: meetingModel,
          );
        } else {
          await _repository.deleteMeeting(
            documentID: meetingModel.id,
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

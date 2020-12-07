import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/widgets/card/workCoScheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Widget> getSearchNoticeDataList(List<DocumentSnapshot> documents, BuildContext context) {
  List<Widget> widgets = [];
  for(int index = 0; index < (documents.length > 4 ? 4 : documents.length); index++) {
    widgets.add(Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                documents[index].data['noticeCreateUser']['name'],
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                documents[index].data['noticeTitle'],
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 3, child: Text("")),
            Expanded(
              flex: 7,
              child: Text(
                DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                    .format(DateTime.parse(documents[index].data['noticeCreateDate'].toDate().toString()).add(Duration(hours: 9))) +
                    " 작성됨",
                style: customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: grayColor),
              ),
            ),
          ],
        )
      ],
    ));
  }

  return widgets;
}

List<Widget> getSearchWorkDataList(List<DocumentSnapshot> documents, BuildContext context) {
  List<Widget> widgets = [];

  for(int index = 0; index < (documents.length > 4 ? 4 : documents.length); index++) {
    widgets.add(Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                documents[index].data['name'],
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
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
                  documents[index].data['type'],
                  style: customStyle(
                      fontSize: typeFontSize,
                      fontWeightName: "Regular",
                      fontColor: fontColor
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Text(
                documents[index].data['workTitle'],
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text("")
            ),
            Expanded(
              flex: 7,
              child: Text(
                DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                    DateTime.parse(
                        documents[index].data['createDate'].toDate().toString()
                    ).add(Duration(hours: 9))
                ) + " 작성됨",
                style: customStyle(
                    fontSize: 12,
                    fontWeightName: 'Regular',
                    fontColor: grayColor
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  return widgets;
}

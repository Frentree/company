//Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

Card workScheduleCard({BuildContext context, String type, String startTime, String endTime, String title, String bigCategory, String normalCategory, String workContents, List<String> share, String createDate, bool isDetail}){
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
        type: type,
        startTime: startTime,
        endTime: endTime,
        title: title,
        bigCategory: bigCategory,
        normalCategory: normalCategory,
        workContents: workContents,
        share: share,
        createDate: "2020.06.01 오전 07:59",
        isDetail: true
      ) : titleContents()
    ),
  );
}

Row titleContents({BuildContext context, String type, String startTime, String endTime, String title, String bigCategory, bool isDetail}){
  return Row(
    children: <Widget>[
      //업무타입
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: textFieldUnderLine,
          ),
          borderRadius: BorderRadius.circular(12)
        ),
        width: customWidth(context: context, widthSize: 0.1),
        height: customHeight(context: context, heightSize: 0.05),
        alignment: Alignment.center,
        child: Text(
          type,
          style: customStyle(
            fontSize: 14,
            fontWeightName: "Regular",
            fontColor: mainColor,
          ),
        ),
      ),

      SizedBox(
        width: customWidth(context: context, widthSize: 0.03),
      ),

      //시간
      Column(
        children: <Widget>[
          Text(
            startTime,
            style: customStyle(
              fontSize: 13,
              fontWeightName: "Regular",
              fontColor: mainColor,
            ),
          ),
          Text(
            "~",
            style: customStyle(
              fontSize: 13,
              fontWeightName: "Regular",
              fontColor: mainColor,
            ),
          ),
          Text(
            endTime,
            style: customStyle(
              fontSize: 13,
              fontWeightName: "Regular",
              fontColor: mainColor,
            ),
          ),
        ],
      ),

      SizedBox(
        width: customWidth(context: context, widthSize: 0.04),
      ),

      Expanded(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: customStyle(
                      fontSize: 16,
                      fontWeightName: "Medium",
                      fontColor: mainColor
                    ),
                  ),
                  isDetail ? Container(
                    height: customHeight(context: context, heightSize: 0.03),
                    width: customWidth(context: context, widthSize: 0.15),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    child: PopupMenuButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.more_horiz,
                      ),
                      itemBuilder: (BuildContext context){
                        PopupMenuItem(
                          child: Text(
                            "수정하기",
                          ),
                        );
                      },
                    ),
                  ) : Container(),
                ],
              ),

              SizedBox(
                height: customHeight(context: context, heightSize: 0.02),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    bigCategory,
                    style: customStyle(
                      fontSize: 14,
                      fontWeightName: "Regular",
                      fontColor: greyColor
                    ),
                  ),
                  Container(
                    width: customWidth(context: context, widthSize: 0.15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor
                    ),
                    child: Center(
                      child: Text(
                        "진행전",
                        style: customStyle(
                          fontSize: 14,
                          fontWeightName: "Regular",
                          fontColor: whiteColor
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Column detailContents({BuildContext context, String type, String startTime, String endTime, String title, String bigCategory, String normalCategory, String workContents, List<String> share, String createDate, bool isDetail}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleContents(
        context: context,
        type: type,
        startTime: startTime,
        endTime: endTime,
        title: title,
        bigCategory: bigCategory,
        isDetail: isDetail
      ),
      Padding(
        padding: EdgeInsets.only(left: customWidth(context: context, widthSize: 0.25)),
        child: Text(
          "└ $normalCategory",
          style: customStyle(
            fontSize: 14,
            fontWeightName: "Regular",
            fontColor: greyColor
          ),
        ),
      ),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),
      Padding(
        padding: EdgeInsets.only(left: customWidth(context: context, widthSize: 0.13)),
        child: Text(
          workContents
        ),
      ),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
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
          ),
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
            createDate,
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
//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

Card workScheduleCard(BuildContext context){
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
      padding: EdgeInsets.symmetric(horizontal: customHeight(context: context, heightSize: 0.02)),
    ),
  );
}

Row titleContents(BuildContext context, workType){
  return Row(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: textFieldUnderLine,
          ),
          borderRadius: BorderRadius.circular(12)
        ),
        width: customWidth(context: context, widthSize: 0.1),
        height: customHeight(context: context, heightSize: 0.05),
        child: Text(

        ),
      ),
    ],
  );
}
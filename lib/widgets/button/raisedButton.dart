//Flutter
import 'package:MyCompany/consts/colorCode.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';


//로그인 관련 페이지에서 사용되는 RaisedButton
Container loginScreenRaisedBtn({BuildContext context, Color btnColor, String btnText, Color btnTextColor, Function btnAction}){
  return Container(
    width: customWidth(
      context: context,
      widthSize: 0.5
    ),
    height: customHeight(
      context: context,
      heightSize: 0.07
    ),

    child: RaisedButton(
      color: btnColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: btnTextColor
          )
      ),

      child: Text(
        btnText,
        style: customStyle(
          fontSize: 18,
          fontWeightName: "Medium",
          fontColor: btnTextColor,
        ),
      ),
      elevation: 0.0,
      onPressed: btnAction,
    ),
  );
}

//회사 유형 선택 페이지에서 사용되는 RaisedButton
Container userTypeSelectScreenRaisedBtn({BuildContext context, Color btnColor, String btnText, Color btnTextColor, Function btnAction}){
  return Container(
    width: customWidth(
      context: context,
      widthSize: 0.3,
    ),
    height: customHeight(
      context: context,
      heightSize: 0.06,
    ),

    child: RaisedButton(
      color: btnColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: btnTextColor,
          )
      ),

      child: Text(
        btnText,
        style: customStyle(
          fontSize: 18,
          fontWeightName: "Medium",
          fontColor: btnTextColor,
        ),
      ),
      elevation: 0.0,
      onPressed: btnAction,
    ),
  );
}

Container maunalOnWorkRaisedBtn({BuildContext context, String btnText, Function btnAction}){
  return Container(
    width: customWidth(
        context: context,
        widthSize: 0.21
    ),
    height: customHeight(
        context: context,
        heightSize: 0.04
    ),

    child: RaisedButton(
      color: whiteColor,
      focusColor: blueColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: mainColor
          )
      ),

      child: Text(
        btnText,
        style: customStyle(
          fontSize: 14,
          fontWeightName: "Medium",
          fontColor: mainColor,
        ),
      ),
      elevation: 0.0,
      onPressed: btnAction,
    ),
  );
}

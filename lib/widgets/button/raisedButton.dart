//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';


//로그인 관련 페이지에서 사용되는 RaisedButton
Container loginScreenRaisedBtn(BuildContext context, Color btnColor, String btnText, Color btnTextColor, Function btnAction){
  return Container(
    width: customWidth(context, 0.5),
    height: customHeight(context, 0.07),

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
        style: customStyle(18, "Medium", btnTextColor),
      ),
      elevation: 0.0,
      onPressed: btnAction,
    ),
  );
}

//회사 유형 선택 페이지에서 사용되는 RaisedButton
Container userTypeSelectScreenRaisedBtn(BuildContext context, Color btnColor, String btnText, Color btnTextColor, Function btnAction){
  return Container(
    width: customWidth(context, 0.3),
    height: customHeight(context, 0.06),

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
        style: customStyle(18, "Medium", btnTextColor),
      ),
      elevation: 0.0,
      onPressed: btnAction,
    ),
  );
}

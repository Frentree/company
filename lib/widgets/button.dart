import 'package:companyplaylist/consts/font.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

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

InkWell textBtn(String btnText, TextStyle btnTextStyle, btnAction){
  return InkWell(
      child: Text(
        btnText,
        style: btnTextStyle,
      ),
      onTap: btnAction
  );
}
import 'package:flutter/material.dart';
import 'package:companyplaylist/Theme/fontsize.dart';

Container raisedBtn(BuildContext context, double btnWidth, double btnHeight, Color btnColor, String btnText, TextStyle btnTextStyle, Function btnAction){
  return Container(
    width: customWidth(context, btnWidth),
    height: customHeight(context, btnHeight),

    child: RaisedButton(
      color: btnColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Text(
        btnText,
        style: btnTextStyle,
      ),

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
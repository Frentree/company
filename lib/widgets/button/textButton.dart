//Flutter
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:flutter/material.dart';

InkWell textBtn({String btnText, TextStyle btnTextStyle, btnAction}){
  return InkWell(
      child: Text(
        btnText,
        style: btnTextStyle,
      ),
      onTap: btnAction
  );
}

InkWell tabBtn({BuildContext context, String btnText, int tabIndexVariable, int tabOrder, Function tabAction}){
  return InkWell(
    child: Container(
      height: customHeight(
        context: context,
        heightSize: 0.05
      ),
      width: customWidth(
        context: context,
        widthSize: 0.31
      ),
      child: Center(
        child: Text(
          btnText,
          style: customStyle(
            fontSize: 14,
            fontWeightName: "Medium",
            fontColor: mainColor
          ),
        ),
      ),
      decoration: tabIndexVariable == tabOrder ? BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor
      ) : null
    ),
    onTap: tabAction,
  );
}
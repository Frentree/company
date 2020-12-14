//Flutter
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

InkWell textBtn({String btnText, TextStyle btnTextStyle, btnAction}){
  return InkWell(
      child: Text(
        btnText,
        style: btnTextStyle,
      ),
      onTap: btnAction
  );
}

InkWell tabBtn({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction}){
  return InkWell(
    child: Container(
      height: heightSize.h,
      width: widthSize.w,
      child: Center(
        child: Text(
          btnText,
          style: customStyle(
            fontSize: homePageDefaultFontSize.sp,
            fontWeightName: "Medium",
            fontColor: mainColor
          ),
        ),
      ),
      decoration: tabIndexVariable == tabOrder ? BoxDecoration(
        borderRadius: BorderRadius.circular(2.0.w),
        color: whiteColor
      ) : null
    ),
    onTap: tabAction,
  );
}

InkWell tabBtnWithUnderline({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction}){
  return InkWell(
    child: Container(
        height: heightSize.h,
        width: widthSize.w,
        child: Center(
          child: Text(
            btnText,
            style: customStyle(
                fontSize: homePageDefaultFontSize.sp,
                fontWeightName: "Medium",
                fontColor: tabIndexVariable == tabOrder ? mainColor : grayColor
            ),
          ),
        ),
        decoration: tabIndexVariable == tabOrder ? BoxDecoration(
          //borderRadius: BorderRadius.circular(8),
            color: whiteColor,
            border: Border(
                bottom: BorderSide(
                  color: mainColor,
                  width: 1.0,
                )
            )
        ) : null
    ),
    onTap: tabAction,
  );
}

Container filterBtn({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction, Color color}){
  return Container(
    padding: EdgeInsets.all(1),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: tabColor
    ),
    child: Container(
      height: customHeight(
        context: context,
        heightSize: heightSize,
      ),
      width: customWidth(
          context: context,
          widthSize: widthSize
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: whiteColor
      ),
      child: InkWell(
        child: Container(
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
                borderRadius: BorderRadius.circular(8),
                color: color
            ) : null
        ),
        onTap: tabAction,
      ),
    ),
  );
}

InkWell manualOnWorkBtn({BuildContext context, String btnText, Function btnAction, bool isSelect}) {
  return InkWell(
    child: Container(
      width: 18.0.w,
      height: 4.0.h,
      decoration: BoxDecoration(
        color: isSelect ? mainColor : whiteColor,
        borderRadius: BorderRadius.circular(3.0.w),
        border: Border.all(
          color: mainColor,
        )
      ),
      child: Center(
        child: Text(
          btnText,
          style: customStyle(
              fontSize: 12.0.sp,
              fontWeightName: "Regular",
              fontColor: isSelect ? whiteColor : mainColor
          ),
        ),
      )
    ),
    onTap: btnAction,
  );
}

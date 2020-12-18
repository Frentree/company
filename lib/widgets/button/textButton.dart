//Flutter
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';

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
      height: 4.0.h,
      width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
      decoration: BoxDecoration(
        color: isSelect ? mainColor : whiteColor,
        borderRadius: BorderRadius.circular(
            SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
        ),
        border: Border.all(color: mainColor),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
      ),
      alignment: Alignment.center,
      child: Text(
        btnText,
        style: customStyle(
          fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
          fontColor: isSelect ? whiteColor : mainColor,
          fontWeightName: "Regular",
        ),
      )
    ),
    onTap: btnAction,
  );
}

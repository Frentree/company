import 'package:flutter/material.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:sizer/sizer.dart';

/*TEXT STYLE*/
//signUpMain, companySetMain
TextStyle appNameStyle = customStyle(
  fontSize: appNameSize.sp,
  fontColor: whiteColor,
  fontWeightName: "Bold",
);

TextStyle appVersionStyle = customStyle(
    fontSize: appVersionSize.sp,
    fontColor: whiteColor,
    fontWeightName: "Bold",
);

TextStyle pageNameStyle = customStyle(
  fontSize: defaultSize.sp,
  fontColor: blueColor,
  fontWeightName: "Bold",
);

TextStyle defaultStyle = customStyle(
  fontSize: defaultSize.sp,
  fontColor: mainColor,
  fontWeightName: "Medium",
);
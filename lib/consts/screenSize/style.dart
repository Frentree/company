import 'package:flutter/material.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:sizer/sizer.dart';

/*TEXT STYLE*/
//signUpMain, companySetMain
TextStyle appNameStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? appNameSizeT.sp : appNameSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Bold",
);

TextStyle appVersionStyle = customStyle(
    fontSize: SizerUtil.deviceType == DeviceType.Tablet ? appVersionSizeT.sp : appVersionSizeM.sp,
    fontColor: whiteColor,
    fontWeightName: "Bold",
);

TextStyle pageNameStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? pageNameSizeT.sp : pageNameSizeM.sp,
  fontColor: blueColor,
  fontWeightName: "Bold",
);

TextStyle hintStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: grayColor,
  fontWeightName: "Regular",
);

TextStyle defaultSmallStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? smallSizeT.sp : smallSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Regular",
);

TextStyle defaultRegularStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Regular",
);

TextStyle defaultRegularStyleWhite = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Regular",
);

TextStyle defaultMediumStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Medium",
);

TextStyle defaultMediumWhiteStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Medium",
);

TextStyle cardTitleStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTitleSizeT.sp : cardTitleSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Medium",
);

TextStyle cardSubTitleStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardSubTitleSizeT.sp : cardSubTitleSizeM.sp,
  fontColor: grayColor,
  fontWeightName: "Regular",
);

TextStyle cardContentsStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardContentsSizeT.sp : cardContentsSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Regular",
);

TextStyle timeStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Regular",
);

/*TextStyle cardBlueStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
  fontWeightName: "Regular",
  fontColor: blueColor
);*/

TextStyle cardBlueStyle = customStyle(
    fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
    fontWeightName: "Regular",
    fontColor: blueColor
);

TextStyle containerChipStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Regular",
);

TextStyle containerChipStyleWhite = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Regular",
);

TextStyle reversContainerChipStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Regular",
);

TextStyle popupMenuStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuSizeT.sp : popupMenuSizeM.sp,
  fontColor: mainColor,
  fontWeightName: "Medium",
);

TextStyle buttonBlueStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: blueColor,
  fontWeightName: "Medium",
);

TextStyle buttonWhiteStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
  fontColor: whiteColor,
  fontWeightName: "Medium",
);

TextStyle inquireDateBlackStyle = customStyle(
  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? containerChipSizeT.sp : containerChipSizeM.sp,
  fontColor: blackColor,
  fontWeightName: "Regular",
);


/*WIDGET STYLE*/
Container emptySpace = Container(
  height: widgetDistanceH.h,
);

Container cardSpace = Container(
  width: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
);

ShapeBorder raisedButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? buttonRadiusTW.w : buttonRadiusMW.w),
);

ShapeBorder raisedButtonBlueShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? buttonRadiusTW.w : buttonRadiusMW.w),
  side: BorderSide(
    color: blueColor,
  ),
);

ShapeBorder cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? buttonRadiusTW.w : buttonRadiusMW.w),
  side: BorderSide(
    width: 1,
    color: boarderColor,
  ),
);

ShapeBorder converShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? buttonRadiusTW.w : buttonRadiusMW.w),
  side: BorderSide(
    width: 1,
    color: chipColorBlue,
  ),
);

BoxDecoration containerChipDecoration = BoxDecoration(
  border: Border.all(color: textFieldUnderLine),
    borderRadius: BorderRadius.circular(
        SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
    ),
);

EdgeInsetsGeometry textFormPadding = EdgeInsets.symmetric(
  vertical: textFormFontPaddingH.h,
  horizontal: SizerUtil.deviceType == DeviceType.Tablet ? textFormFontPaddingTW.w : textFormFontPaddingMW.w,
);

EdgeInsetsGeometry cardPadding = EdgeInsets.symmetric(
  vertical: cardPaddingH.h,
  horizontal: SizerUtil.deviceType == DeviceType.Tablet ? cardPaddingTW.w : cardPaddingMW.w,
);
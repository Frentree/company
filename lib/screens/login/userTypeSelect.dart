//Flutter
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
//Provider
import 'package:provider/provider.dart';

class UserTypeSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: pageNameSizeH.h,
            alignment: Alignment.center,
            child: Text(
              "사용자 유형 선택",
              style: pageNameStyle,
            ),
          ),
          Container(
            height: widgetDistanceH.h,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 20.0.h,
                  width: 35.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.0.h,
                        child: Text(
                          "새로운 회사 생성",
                          style: customStyle(
                            fontWeightName: "Regular",
                            fontColor: grayColor,
                            fontSize: defaultSize.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: widgetDistanceH.h,
                      ),
                      Center(
                        child: Container(
                          height: buttonSizeH.h,
                          width: buttonSizeW.w,
                          child: RaisedButton(
                            color: blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(buttonRadiusW.w),
                            ),
                            elevation: 0.0,
                            child: Text(
                              "관리자",
                              style: customStyle(
                                fontWeightName: "Medium",
                                fontColor: whiteColor,
                                fontSize: defaultSize.sp,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/CompanyCreate");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.0.h,
                  width: 35.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.0.h,
                        child: Text(
                          "생성된 회사 합류",
                          style: customStyle(
                            fontWeightName: "Regular",
                            fontColor: grayColor,
                            fontSize: defaultSize.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: widgetDistanceH.h,
                      ),
                      Container(
                        height: buttonSizeH.h,
                        width: buttonSizeW.w,
                        child: RaisedButton(
                          color: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonRadiusW.w),
                            side: BorderSide(
                              color: blueColor,
                            ),
                          ),
                          elevation: 0.0,
                          child: Text(
                            "직원",
                            style: customStyle(
                              fontWeightName: "Medium",
                              fontColor: blueColor,
                              fontSize: defaultSize.sp,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/CompanyJoin");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.025,
            ),
          ),
        ],
      ),
    );
  }
}

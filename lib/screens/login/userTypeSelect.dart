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
            height: 5.0.h,
            alignment: Alignment.center,
            child: Text(
              "사용자 유형 선택",
              style: pageNameStyle,
            ),
          ),
          emptySpace,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 20.0.h,
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 26.25.w : 35.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.0.h,
                        child: Text(
                          "새로운 회사 생성",
                          style: hintStyle,
                        ),
                      ),
                      emptySpace,
                      Center(
                        child: Container(
                          height: buttonSizeH.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet ? buttonSizeTW.w : buttonSizeMW.w,
                          child: RaisedButton(
                            color: blueColor,
                            shape: raisedButtonShape,
                            elevation: 0.0,
                            child: Text(
                              "관리자",
                              style: buttonWhiteStyle,
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
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 26.25.w : 35.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.0.h,
                        child: Text(
                          "생성된 회사 합류",
                          style: hintStyle,
                        ),
                      ),
                      emptySpace,
                      Container(
                        height: buttonSizeH.h,
                        width: SizerUtil.deviceType == DeviceType.Tablet ? buttonSizeTW.w : buttonSizeMW.w,
                        child: RaisedButton(
                          color: whiteColor,
                          shape: raisedButtonBlueShape,
                          elevation: 0.0,
                          child: Text(
                            "직원",
                            style: buttonBlueStyle,
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
        ],
      ),
    );
  }
}

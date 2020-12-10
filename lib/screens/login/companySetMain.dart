//Flutter

import 'package:MyCompany/screens/login/companyCreate.dart';
import 'package:MyCompany/screens/login/companyJoin.dart';
import 'package:MyCompany/screens/login/userTypeSelect.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';


class CompanySetMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: mainColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: appNameSizeH.h,
                    alignment: Alignment.center,
                    child: Text(
                      APP_NAME,
                      style: customStyle(
                        fontWeightName: "Medium",
                        fontColor: whiteColor,
                        fontSize: appNameFontSize.sp,
                      ),
                    ),
                  ),
                  Container(
                    height: widgetDistanceH.h,
                  ),
                  Container(
                    height: appVersionSizeH.h,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: appVersionPaddingW.w),
                      child: Text(
                        "Release " + APP_VERSION,
                        style: customStyle(
                          fontWeightName: "Regular",
                          fontColor: whiteColor,
                          fontSize: appVersionFontSize.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: widgetDistanceH.h,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pagePaddingW.w,
                    vertical: pagePaddingH.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(pageRadiusW.w),
                      topRight: Radius.circular(pageRadiusW.w),
                    ),
                    color: whiteColor,
                  ),
                  child: ClipRect(
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      initialRoute: "/UserTypeSelect",
                      routes: {
                        "/UserTypeSelect" : (context) => UserTypeSelectPage(),
                        "/CompanyCreate" : (context) => CompanyCreatePage(),
                        "/CompanyJoin" : (context) => CompanyJoinPage(),
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:MyCompany/screens/setting/organizationChart.dart';
import 'package:MyCompany/screens/setting/position.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/setting/gradeMain.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';

final word = Words();

SettingPosition(BuildContext context) {
  User _loginUser;

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(pageRadiusW.w),
          topLeft: Radius.circular(pageRadiusW.w),
        ),
      ),
      builder: (context) {
        LoginUserInfoProvider _loginUserInfoProvider =
            Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 90.0.h,
            padding: EdgeInsets.symmetric(
              horizontal: 3.0.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(pageRadiusW.w),
                topRight: Radius.circular(pageRadiusW.w),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.0.h),
                ),
                Container(
                  height: 7.0.h,
                  child: Row(
                    children: [
                      Container(
                        width: 10.0.w,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: iconSizeW.w,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 15.0.w,
                        child: Center(
                            child: Icon(
                          Icons.account_box_outlined,
                          size: iconSizeW.w,
                        )),
                      ),
                      Container(
                        width: 50.0.w,
                        child: Text(
                          word.positionManagerment(),
                          style: customStyle(
                            fontSize: homePageDefaultFontSize.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: customHeight(context: context, heightSize: 0.01),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.0.w,
                  ),
                ),
                Expanded(
                  child: PositionPage(),
                ),
              ],
            ),
          );
        });
      });
}

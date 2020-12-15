import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingMyPageUpdate.dart';
import 'package:MyCompany/widgets/form/textFormField.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

// 내 정보 화면
Widget getMyInfomationCard({BuildContext context, User user}) {
  return FutureBuilder(
    future: Firestore.instance
        .collection("company")
        .doc(user.companyCode)
        .collection("user")
        .doc(user.mail)
        .get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, bottom: 2.0.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: whiteColor,
                  alignment: Alignment.center,
                  width: 10.0.w,
                  child: GestureDetector(
                    child: Container(
                        height: 4.0.h,
                        width: 10.0.w,
                        child: Image.network(snapshot.data['profilePhoto']),
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 2.0.w)),
                Expanded(
                  child: Text(
                    user.name,
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Text(
                  snapshot.data['team'],
                  style: customStyle(
                    fontSize: 13.0.sp,
                    fontColor: grayColor,
                    fontWeightName: 'Medium',
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 4.0.w)),
                Text(
                  snapshot.data['position'],
                  style: customStyle(
                    fontSize: 13.0.sp,
                    fontColor: grayColor,
                    fontWeightName: 'Medium',
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 4.0.w)),
                Container(
                  child: ActionChip(
                    backgroundColor: blueColor,
                    label: Text(
                      word.update(),
                      style: customStyle(
                        fontSize: 12.0.sp,
                        fontColor: whiteColor,
                        fontWeightName: 'Medium',
                      ),
                    ),
                    onPressed: () {
                      SettingMyPageUpdate(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.joinDate(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "2018.11.01",
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: grayColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.email(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    user.mail,
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: grayColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.phone(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    user.phone,
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: grayColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.accountSecession(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      );
    }
  );
}

// 회사 정보
Widget getCompanyInfomationCard({BuildContext context, User user}) {
  String imageUrl = "";
  return Padding(
    padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w, bottom: 2.0.h),
    child: StreamBuilder(
      stream:
          FirebaseRepository().getCompanyInfos(companyCode: user.companyCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        imageUrl = snapshot.data['companyPhoto'] != ""
            ? snapshot.data['companyPhoto']
            : "https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/defaultImage%2Fnoimage.png?alt=media&token=c447305b-d623-444e-a163-fc1b3e393699";
        return Column(
          children: [
            Row(
              children: [
                Container(
                  color: mainColor,
                  width: 20.0.w,
                  child: Center(
                    child: Container(
                      color: whiteColor,
                      alignment: Alignment.center,
                      width: 20.0.w,
                      child: Image.network(imageUrl),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(padding: EdgeInsets.only(left: 2.0.w)),
                ),
                ActionChip(
                  backgroundColor: blueColor,
                  label: Text(
                    word.update(),
                    style: customStyle(
                      fontSize: 12.0.sp,
                      fontColor: whiteColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  onPressed: () {
                    SettingCompanyPageUpdate(context, imageUrl);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.companyName(),
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyName"],
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.businessNumber(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyNo"],
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    word.address(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyAddr"],
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    word.phone(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyPhone"],
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    word.webAddress(),
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyWeb"],
                    style: customStyle(
                      fontSize: 13.0.sp,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            ),
          ],
        );
      },
    ),
  );
}

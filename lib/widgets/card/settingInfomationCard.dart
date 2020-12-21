import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/widgets/dialog/accountDialogList.dart';
import 'package:MyCompany/widgets/dialog/gradeDialogList.dart';
import 'package:MyCompany/widgets/photo/profilePhoto.dart';
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
Widget getMyInfomationCard({BuildContext context, User user, double statusBarHeight}) {
  return FutureBuilder(
    future: FirebaseFirestore.instance
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
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
            vertical: 1.0.h,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        color: whiteColor,
                        alignment: Alignment.center,
                        child: profilePhoto(loginUser: user)
                      ),
                      cardSpace,
                      cardSpace,
                      cardSpace,
                      Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 9.75.w : 13.0.w,
                        child: Text(
                          user.name,
                          style: defaultRegularStyle,
                        ),
                      ),
                      cardSpace,
                      Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                        child: Text(
                          snapshot.data['position'],
                          style: hintStyle,
                        ),
                      ),
                    ],
                  ),
                  cardSpace,
                  GestureDetector(
                    child: Container(
                      height: 4.0.h,
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        word.update(),
                        style: defaultMediumWhiteStyle,
                      ),
                    ),
                    onTap: (){
                      SettingMyPageUpdate(
                        context: context,
                        statusBarHeight: statusBarHeight,
                        user: user,
                      );
                    },
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.team(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data['team'],
                      style: hintStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.joinDate(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data['enteredDate'],
                      style: hintStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.email(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      user.mail,
                      style: hintStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.phone(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      user.phone,
                      style: hintStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 4.0.h,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        word.accountSecession(),
                        style: defaultMediumWhiteStyle,
                      ),
                    ),
                    onTap: () async {
                      CompanyUser comUser = await FirebaseRepository().getComapnyUser(companyCode: user.companyCode, mail: user.mail);
                      List<String> list = List();
                      comUser.level.map((value) => list.add(value.toString())).toList();

                      if (list.contains("9") || list.contains("8")) {
                        getErrorDialog(context: context, text: word.dropAccountGradeFail());
                      } else {
                        dropAccountDialog(
                          context: context,
                          companyCode: user.companyCode,
                          mail: user.mail,
                          name: user.name,
                        );
                      }
                    },
                  ),
                ],
              ),
              emptySpace,
            ],
          ),
        ),
      );
    },
  );
}

// 회사 정보
Widget getCompanyInfomationCard({BuildContext context, User user, double statusBarHeight}) {
  String imageUrl = "";
  return Container(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
        vertical: 1.0.h,
      ),
      child: StreamBuilder(
        stream:
        FirebaseRepository().getCompanyInfos(companyCode: user.companyCode),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          imageUrl = snapshot.data['companyPhoto'] != ""
              ? snapshot.data['companyPhoto']
              : "https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/defaultImage%2Fnoimage.png?alt=media&token=c447305b-d623-444e-a163-fc1b3e393699";
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      color: whiteColor,
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                      height: SizerUtil.deviceType == DeviceType.Tablet ? 11.25.w : 15.0.w,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.network(imageUrl),
                      )
                  ),
                  GestureDetector(
                    child: Container(
                      height: 4.0.h,
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        word.update(),
                        style: defaultMediumWhiteStyle,
                      ),
                    ),
                    onTap: (){
                      SettingCompanyPageUpdate(
                        context: context,
                        imageUrl: imageUrl,
                        statusBarHeight: statusBarHeight,
                      );
                    },
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.companyName(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data["companyName"],
                      style: defaultRegularStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.businessNumber(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data["companyNo"],
                      style: defaultRegularStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.address(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data["companyAddr"],
                      style: defaultRegularStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.phone(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data["companyPhone"],
                      style: defaultRegularStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      word.webAddress(),
                      style: defaultRegularStyle,
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                    child: Text(
                      snapshot.data["companyWeb"],
                      style: defaultRegularStyle,
                    ),
                  ),
                ],
              ),
              emptySpace,
            ],
          );
        },
      ),
    ),
  );
}

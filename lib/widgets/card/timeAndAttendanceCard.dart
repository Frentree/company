//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';


import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';


import 'package:sizer/sizer.dart';

final word = Words();

Card timeAndAttendanceCard({BuildContext context, Attendance attendanceModel, bool isAllQuery, CompanyUser companyUserInfo}) {
  Format _format = Format();
  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
      padding: cardPadding,
      child: Container(
        height: scheduleCardDefaultSizeH.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet
                  ? 19.0.w
                  : 15.0.w,
              alignment: Alignment.center,
              child: Text(
                _format.dateFormatForExpenseCard(attendanceModel.createDate),
                style: cardBlueStyle,
              ),
            ),
            cardSpace,
            Visibility(
              visible: isAllQuery,
              child: Container(
                width: SizerUtil.deviceType == DeviceType.Tablet
                    ? 22.5.w
                    : 19.5.w,
                alignment: Alignment.center,
                child: Text(
                  isAllQuery ? "${companyUserInfo.team} ${companyUserInfo.name} ${companyUserInfo.position}" : "",
                  style: cardBlueStyle,
                ),
              ),
            ),
            cardSpace,
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet
                  ? 16.0.w
                  : 11.5.w,
              alignment: Alignment.center,
              child: Text(
                attendanceModel.attendTime != null ? _format.timeToString(attendanceModel.attendTime) : "-",
                style: cardBlueStyle,
              ),
            ),
            cardSpace,
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet
                  ? 16.0.w
                  : 11.5.w,
              alignment: Alignment.center,
              child: Text(
                attendanceModel.endTime != null ? _format.timeToString(attendanceModel.endTime) : "-",
                style: cardBlueStyle,
              ),
            ),
            cardSpace,
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet
                  ? 16.0.w
                  : 12.5.w,
              alignment: Alignment.center,
              child: Text(
                attendanceModel.attendTime != null ? attendanceModel.endTime != null ? _format.dateFormatFortimeAndAttendanceCard(attendanceModel.endTime, attendanceModel.attendTime) : _format.dateFormatFortimeAndAttendanceCard(Timestamp.now(), attendanceModel.attendTime) : "-",
                style: cardBlueStyle,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

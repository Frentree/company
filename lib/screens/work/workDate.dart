//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:MyCompany/consts/widgetSize.dart';

workDatePage({BuildContext context, DateTime startTime}) async {

  DateTime date = DateTime.now();

  await showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Container(
              color: whiteColor,
              padding: EdgeInsets.only(
                left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                top: 2.0.h,
              ),
              height: 50.0.h,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     DateTimePickerWidget(
                       minuteDivider: 1,
                       initDateTime: startTime != null ? startTime : DateTime.now().minute < 30 ? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,00) : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,30),
                       locale: DateTimePickerLocale.ko,
                       dateFormat: "yyyy년 MM월 dd일 EE요일 HH:mm",
                       onConfirm: (dateTime, selectedIndex) {
                         date= dateTime;
                       },
                       pickerTheme: DateTimePickerTheme(
                         titleHeight: 5.0.h,
                         cancelTextStyle: hintStyle,
                         confirmTextStyle: defaultRegularStyle,
                         pickerHeight: 40.0.h,
                         itemTextStyle: defaultRegularStyle,
                         itemHeight: 7.0.h,
                       ),
                     ),
                  ]
              ),
            );
          },
        );
      }
  );
  return date;
}
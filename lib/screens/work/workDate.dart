//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

import '../../consts/widgetSize.dart';

workDatePage({BuildContext context, DateTime startTime}) async {

  DateTime date = DateTime.now();

  await showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
          )
      ),
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 300,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                       SizedBox(
                         width: customWidth(
                           context: context,
                           widthSize: 1
                         ),
                         child: DateTimePickerWidget(
                           minuteDivider: 30,
                           initDateTime: startTime != null ? startTime : DateTime.now().minute < 30 ? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,00) : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,30),
                           locale: DateTimePickerLocale.ko,
                           dateFormat: "yyyy년 MM월 dd일 HH:mm",
                           onConfirm: (dateTime, selectedIndex) {
                             date= dateTime;
                           },
                         ),
                       ),

                     /* Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      ),*/
                    ]
                ),
              ),
            );
          },
        );
      }
  );
  return date;
}
//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

import '../../consts/widgetSize.dart';

workDatePage(BuildContext context) async {

  String date = "";
  String timeTitle = "";

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
                           locale: DateTimePickerLocale.ko,
                           dateFormat: "yyyy년 MM월 dd일 HH:mm",
                           onConfirm: (dateTime, selectedIndex) {
                             date= DateTime.parse(dateTime.toString()).toString();
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
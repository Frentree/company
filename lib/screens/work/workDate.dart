//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';


workDatePage(BuildContext context, int timeType) async {
  String startTime = '09:00';
  String endTime = '18:00';

  final String initDateStr="";

  String date = "";
  String timeTitle = "";

  if(timeType == 0) {
    timeTitle = "시작 일시";
  } else {
    timeTitle = "종료 일시";
  }


  String settingDateTime(int day) {
    String time = Format().dateFormat(DateTime.now().add(Duration(days: day)));
    return time;
  }

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
                padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                height: 300,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              "취소",
                              style: customStyle(14, 'Regular', red_color),
                            ),
                            onTap: ()  {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "$timeTitle",
                            style: customStyle(14, 'Regular', top_color),
                          ),
                          InkWell(
                            child: Text(
                              "완료",
                              style: customStyle(14, 'Regular', red_color),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      ),
                      Container(
                        child: SizedBox(
                            height: 300,
                            child: CupertinoDatePicker(
                              minimumYear: 1900,
                              maximumYear: DateTime.now().year,
                              maximumDate: DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                            ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      ),
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

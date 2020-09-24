//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';


workDate(BuildContext context) async {
  String startTime = '09:00';
  String endTime = '18:00';

  String date = "";

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
                            "날짜 선택",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                "오늘",
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: ()  {
                                date = settingDateTime(0);
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Text(
                                Format().dateFormat(DateTime.now()),
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: ()  {
                                date = settingDateTime(0);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                "내일",
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: ()  {
                                date = settingDateTime(1);
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Text(
                                Format().dateFormat(DateTime.now().add(Duration(days: 1))),
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: () {
                                date = settingDateTime(1);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                "다음 주",
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: () {
                                date = settingDateTime(7);
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    settingDateTime(7),
                                    style: customStyle(14, 'Regular', top_color),
                                  ),
                                ],
                              ),
                              onTap: () {
                                date = settingDateTime(7);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                "날짜 선택",
                                style: customStyle(14, 'Regular', top_color),
                              ),
                              onTap: () {
                                print("텍스트");
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),
                            )
                          ],
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

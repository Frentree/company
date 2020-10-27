//내근 및 외근 스케줄을 입력하는 bottom sheet 입니다.

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

//Theme

//Src
import 'package:companyplaylist/utils/date/dateFormat.dart';


dateSetBottomSheet(BuildContext context) async {
  String startTime = '09:00';
  String endTime = '18:00';

  String date='';

  TextStyle _customStyleRed = customStyle(fontSize: 14, fontWeightName: 'Regular', fontColor: redColor);
  TextStyle _customStyleMain = customStyle(fontSize: 14, fontWeightName: 'Regular', fontColor: mainColor);

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
                              style: _customStyleRed,
                            ),
                          ),
                          Text(
                            "날짜 선택",
                            style: _customStyleMain,
                          ),
                          InkWell(
                            child: Text(
                              "완료",
                              style: _customStyleRed,
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
                                style: _customStyleMain,
                              ),
                              onTap: ()  {
                                setState((){
                                  date = Format().dateFormat(DateTime.now());
                                });
                                Navigator.of(context).pop(date);
                                return date;
                              },
                            ),
                            InkWell(
                              child: Text(
                                Format().dateFormat(DateTime.now()),
                                style: _customStyleMain,
                              ),
                              onTap: () {
                                print("날짜");
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
                                style: _customStyleMain,
                              ),
                              onTap: () {
                                date = Format().dateFormat(DateTime.now().add(Duration(days: 1)));
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Text(
                                Format().dateFormat(DateTime.now().add(Duration(days: 1))),
                                style: _customStyleMain,
                              ),
                              onTap: () {
                                print("날짜");
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
                                style: _customStyleMain,
                              ),
                              onTap: () {
                                print("텍스트");
                              },
                            ),
                            InkWell(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    Format().dateFormat(DateTime.now().add(Duration(days: 7))),
                                    style: _customStyleMain,
                                  ),
                                  Text(
                                      "$startTime ~ $endTime"
                                  ),
                                ],
                              ),
                              onTap: () {

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
                                style: _customStyleMain,
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
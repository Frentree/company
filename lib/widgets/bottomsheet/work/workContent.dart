/*
import 'package:companyplaylist/widgets/bottomsheet/work/workDate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

workContent(BuildContext context, int type) {
  TextEditingController _titleCon = TextEditingController();

  // bottomSheet 상단 Title Name
  List<String> _titleList = ["내근일정", "외근일정", "회의일정", "개인일정", "업무요청", "구매품의", "경비품의", "연차신청"];

  String date = "날짜";

  String fnType = "type";
  String fnDetail = "detail";
  String fnEndTime = "end_time";
  String fnProgree = "progress";
  String fnStartDate = "start_date";
  String fnStartTime = "start_time";
  String fnTitle = "title";
  String fnWriteTime = "write_time";
  String fnWriter = "writer";
  String fnEndDate = "end_date";

  // 내근 or 외근 일 경우 실행
  if (type == 1 || type == 2) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: MediaQuery
                    .of(context)
                    .viewInsets,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 10),
                  height: 140,
                  child: Column(
                      children: <Widget>[
                        IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              Chip(
                                label: Text(
                                  "${_titleList[type]}",
                                  style: customStyle(14, 'Regular', top_color),
                                ),
                                backgroundColor: chip_color_blue,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              tabDivider(2, top_color, 15, 15),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: _titleCon,
                                  decoration: InputDecoration(
                                      hintText: '제목을 입력해 주세요'
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              CircleAvatar(
                                  radius: 20,
                                  backgroundColor: _titleCon.text == '' ? Colors
                                      .black12 : Colors.blue,
                                  child: IconButton(
                                      icon: Icon(
                                          Icons.arrow_upward
                                      ),
                                      onPressed: _titleCon.text == ''
                                          ? null
                                          : () {
                                        Firestore.instance.collection(
                                            "my_schedule").add({
                                          fnType: "내근",
                                          fnDetail: "Flutter 개발",
                                          fnEndTime: "18:00",
                                          fnProgree: "진행전",
                                          fnStartDate: date,
                                          fnStartTime: "09:00",
                                          fnTitle: _titleCon.text,
                                          fnWriteTime: DateTime.now()
                                              .toString(),
                                          fnEndDate: date,
                                        });
                                      }
                                  )
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Text(
                                      date,
                                      style: customStyle(
                                          14, 'Regular', top_color),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                String setDate = await workDate(
                                    context);
                                if (setDate != '') {
                                  setState(() {
                                    date = setDate;
                                  });
                                }
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            InkWell(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.scatter_plot,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Text(
                                      "관련 프로젝트",
                                      style: customStyle(
                                          14, 'Regular', top_color),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("클릭");
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            InkWell(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.chat_bubble_outline,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Text(
                                      "내용",
                                      style: customStyle(
                                          14, 'Regular', top_color),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("클릭");
                              },
                            )
                          ],
                        )
                      ]
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
*/

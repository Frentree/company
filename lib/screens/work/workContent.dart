import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/repos/login/workRepository.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workDate.dart';
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

class WorkContentPage extends StatefulWidget {
  @override
  WorkContentPageState createState() => WorkContentPageState();
}

class WorkContentPageState extends State<WorkContentPage> {
  TextEditingController _titileTextEdit;
  TextEditingController _startDateTextEdit;
  TextEditingController _endDateTextEdit;
  TextEditingController _projectTextEdit;
  TextEditingController _contentEdit;
  TextEditingController _targetTextEdit;

  String date = "";
  String _project = "project";
  List<bool> _isTarget = [false, false, false];

  WorkRepository _workRepository = WorkRepository();

  @override
  void initState() {
    super.initState();
    _titileTextEdit = TextEditingController();
    _startDateTextEdit = TextEditingController();
    _endDateTextEdit = TextEditingController();
    _projectTextEdit = TextEditingController();
    _contentEdit = TextEditingController();
    _targetTextEdit = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            //상단 로고
            Container(
              width: customWidth(
                context : context,
                widthSize: 0.96),
              height: customHeight(
                context: context,
                heightSize: 0.13,
              ),
              decoration: BoxDecoration(color: mainColor),

              //앱 이름 및 버전 표시
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: customHeight(
                        context : context,
                        heightSize : 0.04
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        ),
                        Text(
                          "근무중",
                          style: customStyle(15, '', whiteColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: customHeight(
                      context: context,
                      heightSize: 0.05,
                    ),
                  ),
                ],
              ),
            ),

            //하단
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    top: customHeight(
                      context: context,
                      heightSize: 0.03,
                    ),
                    left: customHeight(
                      context: context,
                      heightSize: 0.05,
                    ),
                    right: customHeight(
                      context: context,
                      heightSize: 0.05,
                    ),
                ),
                width: customWidth(
                  context : context,
                  widthSize : 1,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: whiteColor),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[

                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: textFieldUnderLine
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: customWidth(context: context, widthSize: 0.1),
                              height: customHeight(context: context, heightSize: 0.06),
                              child: Text(
                                "내근",
                                style: customStyle(
                                    14, "Regular", mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: _titileTextEdit,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "제목을 입력하세요",
                              //labelText: "제목"
                            ),
                          ),
                        ),
                        SizedBox(
                          height:  customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 155,
                              height: 50,
                              child: Stack(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _startDateTextEdit,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "시작 일시",
                                      //labelText: "제목"
                                    ),
                                  ),
                                  IconButton(
                                    padding:
                                        EdgeInsets.only(left: 120, top: 0),
                                    icon: Icon(
                                      Icons.date_range,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      String setDate = await workDatePage(context, 0);
                                      if(setDate != '') {
                                        setState(() {
                                          _startDateTextEdit.text = setDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Text("~"),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Spacer(),
                            Container(
                              width: 155,
                              height: 50,
                              child: Stack(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _endDateTextEdit,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "종료 일시",
                                      //labelText: "제목"
                                    ),
                                  ),
                                  IconButton(
                                    padding:
                                        EdgeInsets.only(left: 120, top: 0),
                                    icon: Icon(
                                      Icons.date_range,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      String setDate = await workDatePage(context, 1);
                                      if(setDate != '') {
                                        setState(() {
                                          _endDateTextEdit.text = setDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:Border.all(
                              width: 1,
                              color: Colors.black26
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0) // POINT
                            ),
                          ),
                          child: ExpansionTile(
                            title: Text("관련 프로젝트를 선택하세요"),
                            children: [
                              RadioListTile(
                                title: Text('AIA'),
                                value: "AIA",
                                groupValue: _project,
                                onChanged: (value) {
                                  setState(() {
                                    _project = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text('KB'),
                                value: "KB",
                                groupValue: _project,
                                onChanged: (value) {
                                  setState(() {
                                    _project = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        TextFormField(
                          controller: _contentEdit,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "내용을 입력하세요",
                            //labelText: "제목"
                          ),
                        ),
                        SizedBox(
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:Border.all(
                                width: 1,
                                color: Colors.black26
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0) // POINT
                            ),
                          ),
                          child: ExpansionTile(
                            title: Text("공개 대상을 선택하세요"),
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isTarget[0],
                                      onChanged: (value) {
                                        setState(() {
                                          _isTarget[0] = value;
                                          _isTarget[1] = false;
                                          _isTarget[2] = false;
                                        });
                                      },
                                    ),
                                    Text(
                                        "팀원"
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isTarget[1],
                                      onChanged: (value) {
                                        setState(() {
                                          _isTarget[0] = false;
                                          _isTarget[1] = value;
                                          _isTarget[2] = false;
                                        });
                                      },
                                    ),
                                    Text(
                                        "전체 직원"
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isTarget[2],
                                      onChanged: (value) {
                                        setState(() {
                                          _isTarget[0] = false;
                                          _isTarget[1] = false;
                                          _isTarget[2] = value;
                                        });
                                      },
                                    ),
                                    Text(
                                        "직접 선택"
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            loginScreenRaisedBtn(
                                context :context,
                                btnColor : blueColor,
                                btnText : "내근 일정 생성",
                                btnTextColor : whiteColor,
                                btnAction : () => {
                                  _workRepository.workScheduleFirebaseAuth(
                                    context: context,
                                    workTitle: _titileTextEdit.text,
                                    startDate: _startDateTextEdit.text,
                                    endDate: _endDateTextEdit.text,
                                    workContent: _contentEdit.text,
                                    share: null,
                                  ) : null
                                }
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*

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
}*/

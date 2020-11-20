import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/work/workRepository.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/screens/work/workTeam.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

workContent(BuildContext context, int type) {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  User _loginUser;

  String date = "";
  String formatDate = "";
  String timeTest = "종일";

  bool isChk = false;

  List<bool> isColor = [false, false, false];

  WorkRepository _workRepository = WorkRepository();;
  List<Map<String, String>> _teamList;

  // 내근 or 외근 일 경우 실행
  if (type == 1 || type == 2) {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
          _loginUser = _loginUserInfoProvider.getLoginUser();

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Listener(
                  onPointerDown: (_) {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.focusedChild.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Chip(
                                backgroundColor: chipColorBlue,
                                label: Text(
                                  type == 1 ? "내근 일정" : "외근 일정",
                                  style: customStyle(
                                    fontSize: 14,
                                    fontColor: mainColor,
                                    fontWeightName: 'Regular',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextField(
                                controller: _titleController,
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                                decoration: InputDecoration(
                                  hintText: '제목을 입력하세요',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: _titleController.text == ''
                                      ? Colors.black12
                                      : _titleController.text == ''
                                      ? Colors.black12
                                      : Colors.blue,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    onPressed: () => {
                                      _workRepository.workScheduleFirebaseAuth(
                                        context: context,
                                        startDate: Timestamp.fromDate(DateTime.parse(formatDate)),
                                        startTime: Timestamp.fromDate(DateTime.parse(date)),
                                        type: type == 1 ? "내근" : "외근",
                                        workTitle: _titleController.text,
                                        workContents: isChk == true ? _contentController.text : "",
                                        createDate: Timestamp.now(),
                                        progress: 3,
                                        location: _locationController.text,
                                        timeTest: timeTest == null ? "종일" : timeTest,
                                        share: isChk == true ? _teamList : null,
                                        user : _loginUser,
                                      ): null
                                    },
                                  )),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Text(
                                      type == 1 ? "내근 일시" : "외근 일시",
                                      style: customStyle(
                                        fontSize: 14,
                                        fontColor: mainColor,
                                        fontWeightName: 'Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  child: Text(
                                    date.trim() == "" ? "일자를 선택해 주세요" : DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(DateTime.parse(date)).toString(),
                                    style: customStyle(
                                      fontSize: 13,
                                      fontColor: mainColor,
                                      fontWeightName: 'Bold',
                                    ),
                                  ),
                                  onTap: () async {
                                    date = await workDatePage(context);

                                    formatDate = DateFormat('yyyy-MM-dd 21:00:00').format(
                                        DateTime.parse(
                                            date
                                        )
                                    );

                                    setState((){
                                    });
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Text(
                                      type == 1 ? "내근 시간" : "외근 시간",
                                      style: customStyle(
                                        fontSize: 14,
                                        fontColor: mainColor,
                                        fontWeightName: 'Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 5,
                                child: Container(
                                  height: 30,
                                  child: CupertinoPicker(
                                    looping: true,
                                    itemExtent: 30.0,
                                    onSelectedItemChanged: (int type){
                                      if(type == 0){
                                        timeTest = "종일";
                                      } else if(type == 0){
                                        timeTest = "오후";
                                      } else {
                                        timeTest = "오전";
                                      }
                                    },
                                    children: [
                                      Text("종일",
                                          style: customStyle(
                                            fontSize: 13,
                                            fontColor: mainColor,
                                            fontWeightName: 'Bold',
                                          )
                                      ),
                                      Text("오후",
                                        style: customStyle(
                                          fontSize: 13,
                                          fontColor: mainColor,
                                          fontWeightName: 'Bold',
                                        ),
                                      ),
                                      Text("오전",
                                        style: customStyle(
                                          fontSize: 13,
                                          fontColor: mainColor,
                                          fontWeightName: 'Bold',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Visibility(
                          visible: (type == 2),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 10)),
                                      Text(
                                        "외근 장소",
                                        style: customStyle(
                                          fontSize: 14,
                                          fontColor: mainColor,
                                          fontWeightName: 'Regular',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 30,
                                    child: TextField(
                                      controller: _locationController,
                                      style: customStyle(
                                        fontSize: 14,
                                        fontColor: mainColor,
                                        fontWeightName: 'Regular',
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '외근지를 입력하세요',
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChk,
                                onChanged: (value) {
                                  setState(() {
                                    isChk = value;
                                  });
                                },
                              ),
                              Text(
                                "추가 항목 입력",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isChk,
                          child: Column(
                            children: [
                              /*Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.supervisor_account_outlined,
                                            ),
                                            Padding(padding: EdgeInsets.only(left: 10)),
                                            Text(
                                              "공개 대상",
                                              style: customStyle(
                                                fontSize: 14,
                                                fontColor: mainColor,
                                                fontWeightName: 'Regular',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              child: Text("전체 공개",
                                                  style: customStyle(
                                                    fontSize: 13,
                                                    fontColor: isColor[0] == true ? mainColor : greyColor,
                                                    fontWeightName: 'Bold',
                                                  )
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  isColor[0] = true;
                                                  isColor[1] = false;
                                                  isColor[2] = false;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              child: Text("팀원 공개",
                                                style: customStyle(
                                                  fontSize: 13,
                                                  fontColor: isColor[1] == true ? mainColor : greyColor,
                                                  fontWeightName: 'Bold',
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  isColor[0] = false;
                                                  isColor[1] = true;
                                                  isColor[2] = false;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: InkWell(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("기타 공개",
                                                      style: customStyle(
                                                        fontSize: 13,
                                                        fontColor: isColor[2] == true ? mainColor : greyColor,
                                                        fontWeightName: 'Bold',
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(right: 10)),
                                                    Visibility(
                                                      visible: isColor[2],
                                                      child: InkWell(
                                                        child: Text(
                                                          "수정",
                                                          style: customStyle(
                                                            fontSize: 13,
                                                            fontColor: blueColor,
                                                            fontWeightName: 'Bold',
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          List<Map<String, String>>
                                                          _teamNameList =
                                                          await WorkTeamPage(context);
                                                          _teamList = _teamNameList;
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    isColor[0] = false;
                                                    isColor[1] = false;
                                                    isColor[2] = true;
                                                  });
                                                  _teamList = WorkTeamPage(context);
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                              SizedBox(
                                height: customHeight(
                                    context: context,
                                    heightSize: 0.01
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.list,
                                          ),
                                          Padding(padding: EdgeInsets.only(left: 10)),
                                          Text(
                                            "상세 내용",
                                            style: customStyle(
                                              fontSize: 14,
                                              fontColor: mainColor,
                                              fontWeightName: 'Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextField(
                                      controller: _contentController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 2,
                                      maxLengthEnforced: true,
                                      style: customStyle(
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "내용을 입력하세요",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: customHeight(
                                    context: context,
                                    heightSize: 0.01
                                ),
                              ),
                              /*Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.how_to_reg_outlined,
                                          ),
                                          Padding(padding: EdgeInsets.only(left: 10)),
                                          Text(
                                            "승인 요청",
                                            style: customStyle(
                                              fontSize: 14,
                                              fontColor: mainColor,
                                              fontWeightName: 'Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });


  }

}
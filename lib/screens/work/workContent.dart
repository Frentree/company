/*
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/repos/work/workRepository.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/screens/work/workTeam.dart';
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

//Theme
class WorkContentPage extends StatefulWidget {
  WorkContentPage(this.workType);

  final int workType;

  @override
  WorkContentPageState createState() => WorkContentPageState(workType);
}

class WorkContentPageState extends State<WorkContentPage> {
  WorkContentPageState(this.workType);

  final int workType;
  String type;
  LoginUserInfoProvider _loginUserInfoProvider;

  List<Map<String, String>> _teamList;
  List<Map<String, String>> _allTeamList;

  WorkRepository _workRepository;

  TextEditingController _titileTextEdit;
  TextEditingController _startDateTextEdit;
  TextEditingController _endDateTextEdit;
  TextEditingController _projectTextEdit;
  TextEditingController _contentEdit;
  TextEditingController _targetTextEdit;
  TextEditingController _outWorkTextEdit; // 외근지

  CrudRepository _crudRepository;

  bool isSelected = false;

  String date = "";
  List<String> aaa = ["aaa", "bbb"];
  String _project = "project";

  String _openTitle = "공개 대상을 선택하세요";

  List<bool> _isTarget = [false, false, false];
  Stream<QuerySnapshot> currentStream;

  // 전체 사용자 갖고 오기
  Future<List<CompanyUser>> _companyUserList;

  List<bigCategoryModel> workCategory;
  List<bigCategoryModel> testminji;

  @override
  void initState() {
    super.initState();

    // 사용자 정보를 불러오는 객체

    _titileTextEdit = TextEditingController();
    _startDateTextEdit = TextEditingController();
    _endDateTextEdit = TextEditingController();
    _projectTextEdit = TextEditingController();
    _contentEdit = TextEditingController();
    _targetTextEdit = TextEditingController();
    _outWorkTextEdit = TextEditingController();

    _workRepository = WorkRepository();

    if (workType == 1) {
      type = "내근";
    } else if (workType == 2) {
      type = "외근";
    }
  }

  String isCategoryName() {
    if (isSelected == false) {
      return "관련 프로젝트를 선택하세요";
    } else {
      return _project;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    User user = _loginUserInfoProvider.getLoginUser();
    _crudRepository =
        CrudRepository.workCategory(companyCode: user.companyCode);
    currentStream = _crudRepository.fetchWorkCategoryAsStream();
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
              width: customWidth(context: context, widthSize: 0.96),
              height: customHeight(
                context: context,
                heightSize: 0.13,
              ),
              decoration: BoxDecoration(color: mainColor),

              //앱 이름 및 버전 표시
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: customHeight(context: context, heightSize: 0.04),
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
                          style: customStyle(
                              fontSize: 15,
                              fontWeightName: "Regular",
                              fontColor: whiteColor),
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
                  context: context,
                  widthSize: 1,
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
                        Container(
                          width: customWidth(context: context, widthSize: 1),
                          child: Row(
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: textFieldUnderLine),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: customWidth(
                                        context: context, widthSize: 0.1),
                                    height: customHeight(
                                        context: context, heightSize: 0.06),
                                    child: Text(
                                      "$type",
                                      style: customStyle(
                                          fontSize: 14,
                                          fontWeightName: "Regular",
                                          fontColor: mainColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                  Text(
                                    "일정 생성",
                                    style: customStyle(
                                        fontSize: 16,
                                        fontWeightName: "Regular",
                                        fontColor: mainColor),
                                  ),
                                ],
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
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Container(
                          width: customWidth(widthSize: 1, context: context),
                          height: customHeight(
                            context: context,
                            heightSize: 0.06,
                          ),
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
                                padding: EdgeInsets.only(left: 280, top: 0),
                                icon: Icon(
                                  Icons.date_range,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  String setDate =
                                      await workDatePage(context, 0);
                                  if (setDate != '') {
                                    setState(() {
                                      _startDateTextEdit.text = setDate;
                                    });
                                  }
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
                        Container(
                          width: customWidth(widthSize: 1, context: context),
                          height: customHeight(
                            context: context,
                            heightSize: 0.06,
                          ),
                          child: Stack(children: <Widget>[
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
                              padding: EdgeInsets.only(left: 280, top: 0),
                              icon: Icon(
                                Icons.date_range,
                                size: 30,
                              ),
                              onPressed: () async {
                                String setDate = await workDatePage(context, 1);
                                if (setDate != '') {
                                  setState(() {
                                    _endDateTextEdit.text = setDate;
                                  });
                                }
                              },
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: customHeight(
                            context: context,
                            heightSize: 0.03,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0) // POINT
                                    ),
                          ),
                          child: StreamBuilder(
                            stream: currentStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              List<DocumentSnapshot> documents =
                                  snapshot.data.documents;
                              print("snapshot =====> " +
                                  documents
                                      .map((e) => e.data.values.elementAt(1))
                                      .toList()
                                      .toString());
                              return ExpansionTile(
                                title: Text("${isCategoryName()}"),
                                children: <Widget>[
                                  RadioButtonGroup(
                                      labels: documents
                                          .map((e) => e.data.values
                                              .elementAt(1)
                                              .toString())
                                          .toList(),
                                      onSelected: (String selected) =>
                                          print(_project = selected))
                                ],
                              );
                            },
                          ),
                        ),
                        Visibility(
                          child: Column(
                            children: [
                              SizedBox(
                                height: customHeight(
                                  context: context,
                                  heightSize: 0.03,
                                ),
                              ),
                              TextField(
                                controller: _outWorkTextEdit,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "외근지를 입력하세요.",
                                  //labelText: "제목"
                                ),
                              ),
                            ],
                          ),
                          visible: (type == "외근"),
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
                            border: Border.all(width: 1, color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0) // POINT
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
                                          //_isTarget[2] = false;
                                        });
                                      },
                                    ),
                                    Text("팀원"),
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

                                        if (_isTarget[1]) {
                                          _teamList = _allTeamList;
                                        }
                                      },
                                    ),
                                    Text("전체 직원"),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isTarget[2],
                                      onChanged: (value) async {
                                        List<Map<String, String>> _teamNameList;
                                        setState(() {
                                          //_isTarget[0] = false;
                                          _isTarget[1] = false;
                                          _isTarget[2] = value;
                                        });

                                        if (_isTarget[2] == true) {
                                          List<Map<String, String>>
                                              _teamNameList =
                                              await WorkTeamPage(context);
                                          _teamList = _teamNameList;
                                        }
                                      },
                                    ),
                                    Text("직접 선택"),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: customHeight(
                                              heightSize: 0.2,
                                              context: context)),
                                    ),
                                    Visibility(
                                      child: Container(
                                        width: customWidth(
                                            context: context, widthSize: 0.2),
                                        height: customHeight(
                                            context: context, heightSize: 0.04),
                                        child: RaisedButton(
                                          color: blueColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              side:
                                              BorderSide(color: whiteColor)),
                                          child: Text(
                                            "수정",
                                            style: customStyle(
                                              fontSize: 12,
                                              fontWeightName: "Medium",
                                              fontColor: whiteColor,
                                            ),
                                          ),
                                          elevation: 0.0,
                                          onPressed: () async {
                                            List<Map<String, String>>
                                            _teamNameList =
                                            await WorkTeamPage(context);
                                            _teamList = _teamNameList;
                                          },
                                        ),
                                      ),
                                      visible: (_isTarget[2] == true),
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
                                context: context,
                                btnColor: blueColor,
                                btnText: "$type 일정 생성",
                                btnTextColor: whiteColor,
                                btnAction: () => {
                                      _workRepository.workScheduleFirebaseAuth(
                                        createUid: _loginUserInfoProvider
                                            .getLoginUser()
                                            .mail,
                                        context: context,
                                        workTitle: _titileTextEdit.text,
                                        startDate: _startDateTextEdit.text,
                                        endDate: _endDateTextEdit.text,
                                        workContent: _contentEdit.text,
                                        bigCategory: _project,
                                        type: type,
                                        share: _teamList,
                                      ): null
                                    }),
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
*/

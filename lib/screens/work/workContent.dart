import 'package:async/async.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'file:///D:/Android/dev_company/lib/repos/work/workRepository.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:companyplaylist/widgets/form/RadioList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

class WorkContentPage extends StatefulWidget {
  @override
  WorkContentPageState createState() => WorkContentPageState();
}

class WorkContentPageState extends State<WorkContentPage> {
  List<WorkCategory> list;
  WorkRepository _workRepository;

  TextEditingController _titileTextEdit;
  TextEditingController _startDateTextEdit;
  TextEditingController _endDateTextEdit;
  TextEditingController _projectTextEdit;
  TextEditingController _contentEdit;
  TextEditingController _targetTextEdit;


  bool isSelected = false;

  String type = "내근";
  String date = "";
  String _project = "project";
  List<bool> _isTarget = [false, false, false];

  @override
  void initState() {
    super.initState();
    _titileTextEdit = TextEditingController();
    _startDateTextEdit = TextEditingController();
    _endDateTextEdit = TextEditingController();
    _projectTextEdit = TextEditingController();
    _contentEdit = TextEditingController();
    _targetTextEdit = TextEditingController();

    _workRepository = WorkRepository();
    list = List<WorkCategory>();
    Future<List<WorkCategory>> workCategory =  _workRepository.workCategoryFirebaseAuth(context: context);

    workCategory.then((value) =>
        value.forEach((element) {
          WorkCategory category = WorkCategory(
              createUid: element.createUid,
              createDate: element.createDate,
              bigCategoryTitle: element.bigCategoryTitle,
              bigCategoryContent: element.bigCategoryContent);

          this.list.add(category);
          setState(() {});
        })
    );
  }

  // 빅카테고리 리스트
  List<Widget> workCategoryList (BuildContext context, String project, List<WorkCategory> titleList) {
    List<Widget> children = [];
    titleList.forEach((element) {
      children.add(
        RadioListTile(
          title: Text(element.bigCategoryTitle),
          value: element.bigCategoryTitle,
          groupValue: _project,
          onChanged: (value) {
            setState(() {
              _project = value;
              isSelected = true;
            });
          },
        ),
      );
    });

    return children;
  }

  String isCategoryName(){
    if(isSelected == false){
      return "관련 프로젝트를 선택하세요";
    } else {
      return _project;
    }
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
                          width: customWidth(
                              context: context,
                              widthSize: 1
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: textFieldUnderLine),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: customWidth(
                                        context: context, widthSize: 0.1),
                                    height: customHeight(
                                        context: context, heightSize: 0.06),
                                    child: Text(
                                      "$type",
                                      style: customStyle(
                                        14,
                                        "Regular",
                                        mainColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                  Text(
                                    "일정 생성",
                                    style: customStyle(
                                      16,
                                      "Regular",
                                      mainColor,
                                    ),
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
                        Row(
                          children: [
                            Container(
                              width: 140,
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
                                    padding: EdgeInsets.only(left: 110, top: 0),
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
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Text("~"),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Spacer(),
                            Container(
                              width: 140,
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
                                    padding: EdgeInsets.only(left: 110, top: 0),
                                    icon: Icon(
                                      Icons.date_range,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      String setDate =
                                      await workDatePage(context, 1);
                                      if (setDate != '') {
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
                            border: Border.all(width: 1, color: Colors.black26),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0) // POINT
                            ),
                          ),
                          child: ExpansionTile(
                            title: Text("${isCategoryName()}"),
                            children: workCategoryList(context,_project, list),
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
                                          _isTarget[2] = false;
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
                                      onChanged: (value) {
                                        setState(() {
                                          _isTarget[0] = false;
                                          _isTarget[1] = false;
                                          _isTarget[2] = value;
                                        });
                                      },
                                    ),
                                    Text("직접 선택"),
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
                                    context: context,
                                    workTitle: _titileTextEdit.text,
                                    startDate: _startDateTextEdit.text,
                                    endDate: _endDateTextEdit.text,
                                    workContent: _contentEdit.text,
                                    bigCategory: _project,
                                    type: type,
                                    share: null,
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

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/screens/work/workContent.dart';
import 'package:companyplaylist/widgets/bottomsheet/expense/expenseMain.dart';
import 'package:companyplaylist/widgets/bottomsheet/purchase/purchaseMain.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workContent.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workNotice.dart';
import 'package:companyplaylist/widgets/bottomsheet/meeting/meetingMain.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';

MainBottomSheet({BuildContext context, String companyCode, String mail}) {
  // 사용자 권한
  bool result = false;
  void _workBottomMove(int type) async {
    switch(type){
      case 0: break;
      case 1: case 2:   //내근 or 외근
        result = await workContent(context: context, type: type);
        if(result){
          Navigator.of(context).pop();
        }
        break;
      case 3:
        result = await meetingMain(context: context);
        if(result){
          Navigator.of(context).pop();
        }
        break;
      case 4: case 5: break;
      case 6:
        NotImplementedFunction(context);
        break;
      case 7:
        ExpenseMain(context);
        break;
      case 9:   // 공지사항
        WorkNoticeBottomSheet(context, "", "", "");
        break;
      default:
        NotImplementedFunction(context);
        break;
    }
  }
  // 관리자 권한이 아닐 경우
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: FirebaseRepository().userGrade(companyCode, mail),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              List<dynamic> grade = snapshot.data['level'];

              if (!grade.contains(9) && !grade.contains(8)) {
                return Container(
                  height: 200,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        "추가할 일정을 선택하세요",
                        style: customStyle(
                            fontSize: 16,
                            fontWeightName:'Regular',
                            fontColor: grayColor
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13),
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "최근 일정에서 생성",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(0);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "내근 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(1);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "외근 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(2);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "회의 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: (){
                              _workBottomMove(3);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "개인 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: (){
                              NotImplementedFunction(context);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ActionChip(

                            backgroundColor: chipColorPurple,
                            label: Text(
                              "업무 요청",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: (){
                              NotImplementedFunction(context);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorRed,
                            label: Text(
                              "구매 품의",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(6);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorRed,
                            label: Text(
                              "경비 품의",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(7);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorRed,
                            label: Text(
                              "연차 신청",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              NotImplementedFunction(context);
                              //_workBottomMove(7);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 200,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        "추가할 일정을 선택하세요",
                        style: customStyle(
                            fontSize: 14,
                            fontWeightName:'Regular',
                            fontColor: grayColor
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "내근 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(1);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "외근 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(2);
                            },
                          ),
                          ActionChip(
                            backgroundColor: chipColorBlue,
                            label: Text(
                              "회의 일정",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: (){
                              _workBottomMove(3);
                            },
                          ),
                          Chip(
                              backgroundColor: chipColorBlue,
                              label: Text(
                                "개인 일정",
                                style: customStyle(
                                    fontSize: 14,
                                    fontWeightName:'Regular',
                                    fontColor: mainColor
                                ),
                              )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13),
                          ),
                          Chip(
                              backgroundColor: chipColorPurple,
                              label: Text(
                                "업무 요청",
                                style: customStyle(
                                    fontSize: 14,
                                    fontWeightName:'Regular',
                                    fontColor: mainColor
                                ),
                              )
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13),
                          ),
                          ActionChip(
                            backgroundColor: chipColorGreen,
                            label: Text(
                              "프로젝트",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(1);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                          ),
                          ActionChip(
                            backgroundColor: chipColorGreen,
                            label: Text(
                              "급여명세",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: () {
                              _workBottomMove(2);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                          ),
                          ActionChip(
                            backgroundColor: chipColorGreen,
                            label: Text(
                              "공지사항",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName:'Regular',
                                  fontColor: mainColor
                              ),
                            ),
                            onPressed: (){
                              _workBottomMove(9);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
    );
}

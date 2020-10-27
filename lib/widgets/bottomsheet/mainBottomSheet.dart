import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/screens/work/workContent.dart';
import 'package:companyplaylist/widgets/bottomsheet/expense/expenseMain.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workContent.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workNotice.dart';
import 'package:flutter/material.dart';


MainBottomSheet(BuildContext context) {
  // 사용자 권한
  int _userGrade = 0;

  void _workBottomMove(int type) {
    if(type == 0) {   // 내근 또는 외근 일때
    } else if(type == 1 || type == 2) {   // 내근 또는 외근 일때
      /*Navigator.push(context, MaterialPageRoute(builder: (context) => WorkContentPage(type)));*/
      workContent(context, type);
    } else if (type == 3) {

    } else if (type == 4) {

    } else if (type == 5) {

    } else if (type == 6) { //구매 품의

    } else if (type == 7) { //경비 품의
      if (_userGrade == 9) { //공지사항
        WorkNoticeBottomSheet(context);
      }
      ExpenseMain(context);
    }
  }

  // 관리자 권한이 아닐 경우
  if (_userGrade != 9) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                      fontColor: greyColor
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
                    Chip(
                        backgroundColor: chipColorBlue,
                        label: Text(
                          "회의 일정",
                          style: customStyle(
                              fontSize: 14,
                              fontWeightName:'Regular',
                              fontColor: mainColor
                          ),
                        )
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
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
                        _workBottomMove(7);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  } else {  // 관리자 권한일 경우
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                      fontColor: greyColor
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
                    Chip(
                        backgroundColor: chipColorBlue,
                        label: Text(
                          "회의 일정",
                          style: customStyle(
                              fontSize: 14,
                              fontWeightName:'Regular',
                              fontColor: mainColor
                          ),
                        )
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
                        _workBottomMove(7);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}

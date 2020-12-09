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
    switch (type) {
      case 0:
        break;
      case 1:
      case 2: //내근 or 외근
        result = await workContent(context: context, type: type);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 3:
        result = await meetingMain(context: context);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 4:
      case 5:
        break;
      case 6:
        NotImplementedFunction(context);
        break;
      case 7:
        ExpenseMain(context);
        break;
      case 9: // 공지사항
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
              bool _isStaff = true;

              bool _isStaffMethod(grade) {
                if (!grade.contains(9) && !grade.contains(8))
                  return _isStaff = true;
                else
                  return _isStaff = false;
              }

              _isStaffMethod(grade);

              return Container(
                height: 180,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.arrow_downward_sharp),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "추가할 일정을 선택하세요",
                                  style: customStyle(
                                      fontSize: 16,
                                      fontWeightName: 'Regular',
                                      fontColor: grayColor),
                                ),
                              ],
                            ),
                          ),
                          Expanded(flex: 1, child: Container())
                        ]),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),

                    /// 개발 미완료로 인한 숨김 처리
                    /*Row(
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
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(0);
                          },
                        ),
                      ],
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ActionChip(
                          backgroundColor: chipColorBlue,
                          label: Text(
                            "내근 일정",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
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
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
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
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(3);
                          },
                        ),

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorBlue,
                          label: Text(
                            "개인 일정",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                          },
                        ),*/
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorPurple,
                          label: Text(
                            "업무 요청",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                          },
                        ),*/

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorRed,
                          label: Text(
                            "구매 품의",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(6);
                          },
                        ),*/
                        ActionChip(
                          backgroundColor: chipColorRed,
                          label: Text(
                            "경비 품의",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(7);
                          },
                        ),

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorRed,
                          label: Text(
                            "연차 신청",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                            //_workBottomMove(7);
                          },
                        ),*/

                        if (!_isStaff) ActionChip(
                          backgroundColor: chipColorGreen,
                          label: Text(
                            "급여 명세",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor
                            ),
                          ),
                          onPressed: () {
                            _workBottomMove(2);
                          },
                        ),

                        if (!_isStaff) ActionChip(
                          backgroundColor: chipColorGreen,
                          label: Text(
                            "공지 사항",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(9);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            });
      });
}

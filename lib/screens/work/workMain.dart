import 'package:companyplaylist/screens/buy/createBuyRequest.dart';
import 'package:companyplaylist/screens/work/workContent.dart';
import 'package:flutter/material.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

WorkMainPage(BuildContext context) {
  // 사용자 권한
  int _userGrade = 0;

  void _workBottomMove(int type) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkContentPage()));
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
                  style: customStyle(16, 'Regular', grey_color),
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
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "최근 일정에서 생성",
                        style: customStyle(14, 'Regular', top_color),
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
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "내근 일정",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(1);
                      },
                    ),
                    ActionChip(
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "외근 일정",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(2);
                      },
                    ),
                    Chip(
                        backgroundColor: chip_color_blue,
                        label: Text(
                          "회의 일정",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                    Chip(
                        backgroundColor: chip_color_blue,
                        label: Text(
                          "개인 일정",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Chip(
                        backgroundColor: chip_color_purple,
                        label: Text(
                          "업무 요청",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                    ActionChip(
                      backgroundColor: chip_color_red,
                      label: Text(
                        "구매 품의",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateBuyRequest()));
                      },
                    ),
                    Chip(
                        backgroundColor: chip_color_red,
                        label: Text(
                          "경비 품의",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                    Chip(
                        backgroundColor: chip_color_red,
                        label: Text(
                          "연차 신청",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  } else {
    // 관리자 권한일 경우
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
                  style: customStyle(16, 'Regular', grey_color),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ActionChip(
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "내근 일정",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(1);
                      },
                    ),
                    ActionChip(
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "외근 일정",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(2);
                      },
                    ),
                    Chip(
                        backgroundColor: chip_color_blue,
                        label: Text(
                          "회의 일정",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                    Chip(
                        backgroundColor: chip_color_blue,
                        label: Text(
                          "개인 일정",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 13),
                    ),
                    Chip(
                        backgroundColor: chip_color_purple,
                        label: Text(
                          "업무 요청",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 13),
                    ),
                    ActionChip(
                      backgroundColor: chip_color_green,
                      label: Text(
                        "프로젝트",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(1);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    ActionChip(
                      backgroundColor: chip_color_green,
                      label: Text(
                        "급여명세",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        _workBottomMove(2);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Chip(
                        backgroundColor: chip_color_green,
                        label: Text(
                          "공지사항",
                          style: customStyle(14, 'Regular', top_color),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

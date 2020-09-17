//메뉴를 선택하는 bottom sheet 입니다.

import 'package:flutter/material.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';

//BottomSheet
import 'package:companyplaylist/BottomSheet/work_bottom_sheet.dart';

mainBottomSheet(BuildContext context){
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 200,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: <Widget>[
              Text(
                "추가할 항목을 선택하세요",
                style: customStyle(16, 'Regular', grey_color),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
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
                      return workBottomSheet(context, "내근");
                    },
                  ),
                  ActionChip(
                    backgroundColor: chip_color_blue,
                    label: Text(
                      "외근 일정",
                      style: customStyle(14, 'Regular', top_color),
                    ),
                    onPressed: () {
                      return workBottomSheet(context, "외근");
                    },
                  ),
                  ActionChip(
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "회의 일정",
                        style: customStyle(14, 'Regular', top_color),
                      ),
                      onPressed: () {
                        return workBottomSheet(context, "회의");
                      },
                  ),
                  Chip(
                      backgroundColor: chip_color_blue,
                      label: Text(
                        "개인 일정",
                        style: customStyle(14, 'Regular', top_color),
                      )
                  ),
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
                      )
                  ),
                  Chip(
                      backgroundColor: chip_color_red,
                      label: Text(
                        "구매 품의",
                        style: customStyle(14, 'Regular', top_color),
                      )
                  ),
                  Chip(
                      backgroundColor: chip_color_red,
                      label: Text(
                        "경비 품의",
                        style: customStyle(14, 'Regular', top_color),
                      )
                  ),
                  Chip(
                      backgroundColor: chip_color_red,
                      label: Text(
                        "연차 신청",
                        style: customStyle(14, 'Regular', top_color),
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
                      backgroundColor: chip_color_green,
                      label: Text(
                        "프로젝트",
                        style: customStyle(14, 'Regular', top_color),
                      )
                  ),
                ],
              ),
            ],
          ),
        );
      }
  );
}
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Container expensePopupMenu(BuildContext context){

  return Container(
    height: 15,
    child: PopupMenuButton(
      padding: EdgeInsets.only(right: customWidth(context: context, widthSize: 0.04)),

      onSelected: (value) async {
        if(value == 1) {
          print("수정하기");
        }

        else{
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                  Icons.edit
              ),
              Text(
                  "수정하기"
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                  Icons.delete
              ),
              Text(
                  "삭제하기"
              )
            ],
          ),
        ),
      ],
    ),
  );
}

PopupMenuItem getPopupItem({BuildContext context, IconData icons, int value, String text}) {
  return PopupMenuItem(
    height: 7.0.h,
    value: value,
    child: Row(
      children: [
        Container(
          child: Icon(
            icons,
            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
          ),
        ),
        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
        Text(
          text,
          style: popupMenuStyle,
        )
      ],
    ),
  );
}
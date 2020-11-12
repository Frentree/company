import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:flutter/material.dart';

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
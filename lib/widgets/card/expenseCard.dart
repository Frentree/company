// 내 결재함 화면에서 경비 청구 리스트 보여줄 때 사용하는 카드 위젯

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Card ExpenseCard(BuildContext context, String companyCode, ExpenseModel model) {
  Format _format = Format();

  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        width: 1,
        color: boarderColor,
      ),
    ),
    child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: customWidth(context: context, widthSize: 0.02),
            vertical: customHeight(context: context, heightSize: 0.01)),
        child: Container(
          height: customHeight(context: context, heightSize: 0.03),
          child: Row(
            children: [
              Text(
                _format.dateFormatForExpenseCard(model.buyDate),
                style: customStyle(
                    fontSize: timeFontSize,
                    fontWeightName: "Regular",
                    fontColor: blueColor),
              ),
              SizedBox(
                width: customWidth(context: context, widthSize: widthDistance),
              ),
              Text(
                model.contentType,
              ),
            ],
          )
        )),
  );
}

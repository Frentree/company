// 내 결재함 화면에서 경비 청구 리스트 보여줄 때 사용하는 카드 위젯

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:companyplaylist/widgets/alarm/expenseImageDialog.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const widthDistance = 0.02; // 항목별 간격
const timeFontSize = 13.0;
const typeFontSize = 12.0;
const titleFontSize = 15.0;
const writeTimeFontSize = 14.0;
const fontColor = mainColor;

Card ExpenseCard(BuildContext context, String companyCode, ExpenseModel model) {
  Format _format = Format();
  var returnString = NumberFormat("###,###", "en_US");

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
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _format.dateFormatForExpenseCard(model.buyDate),
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: mainColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      model.contentType,
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: mainColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Row(children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            returnString.format(model.cost),
                            style: customStyle(
                                fontSize: timeFontSize,
                                fontWeightName: "Regular",
                                fontColor: mainColor),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    ]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      ExpenseImageDialog(context, model.imageUrl);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: model.imageUrl == "" ? Container() : Icon(Icons.receipt_long_outlined, size: 20),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      model.status.toString(),
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: mainColor),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: _popupMenu(context)),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ))),
  );
}

Container _popupMenu(BuildContext context) {
  return Container(
      alignment: Alignment.topCenter,
      width: customWidth(context: context, widthSize: 0.05),
      child: PopupMenuButton(
          icon: Icon(Icons.arrow_forward_ios_sharp, size: 12),
          onSelected: (value) async {},
          itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [Icon(Icons.edit), Text("수정하기")],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [Icon(Icons.delete), Text("삭제하기")],
                  ),
                ),
              ]));
}

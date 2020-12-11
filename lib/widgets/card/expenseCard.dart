// 내 결재함 화면에서 경비 청구 리스트 보여줄 때 사용하는 카드 위젯

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/alarm/expenseImageDialog.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();



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
            horizontal: cardPaddingW.w,
            vertical: cardPaddingH.h),
        child: Container(
            height: 3.0.h,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _format.dateFormatForExpenseCard(model.buyDate),
                      style: customStyle(
                          fontSize: 11.0.sp,
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
                      model.contentType == "석시비" ? word.dinner(): word.lunch(),
                      style: customStyle(
                          fontSize: 11.0.sp,
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
                                fontSize: 11.0.sp,
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
                      child: model.imageUrl == "" ? Container() : Icon(Icons.receipt_long_outlined, size: iconSizeW.w),
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
                          fontSize: 11.0.sp,
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
      width: 5.0.w,
      child: PopupMenuButton(
          icon: Icon(Icons.arrow_forward_ios_sharp, size: iconSizeW.w),
          onSelected: (value) async {},
          itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(

                    children: [Icon(Icons.edit, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text(word.update(), style: customStyle(fontSize: 13.0.sp),)],

                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(

                    children: [Icon(Icons.delete, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text(word.delete(), style: customStyle(fontSize: 13.0.sp),)],

                  ),
                ),
              ]));
}
